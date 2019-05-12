import 'package:flutter/material.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/main/NewContestDialog.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final ContestDataSource contestDataSource = LocalContestDataSource();
  final UserDataSource userDataSource = LocalUserDataSource();

  List<Contest> contestList = [];
  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadContestList();
  }

  void _loadUser() async {
    var user = await userDataSource.loadData();
    setState(() {
      this.userName = user?.name ?? "";
    });
  }

  void _loadContestList() async {
    var contests = await contestDataSource.loadAll();
    contests.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      contestList = contests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _showNewContestDialog,
          child: Icon(Icons.add),
          tooltip: "Alusta uut võistlust",
        ),
        appBar: AppBar(
          title: Text("Võistleja: " + userName),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    if (contestList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
            child: Text(
          "Võistluse lisamiseks vajuta \"+\" nupule",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        )),
      );
    } else {
      return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          Contest contest = contestList[index];
          return ListTile(
              title: Text(
                contest.name,
                style: TextStyle(fontSize: 22),
              ),
              subtitle: Text(
                getDateString(contest),
                style: TextStyle(fontSize: 16),
              ),
              onTap: () => _navigateToContestDetails(contest));
        },
        itemCount: contestList.length,
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
              height: 1,
            ),
        padding: EdgeInsets.only(bottom: 70),
      );
    }
  }

  String getDateString(Contest contest) {
    var formatter = DateFormat("dd.MM.yyyy kk:mm");
    return "${formatter.format(contest.date)}";
  }

  void _showNewContestDialog() async {
    var name = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => NewContestDialog());

    if (name != null) {
      Contest contest = _createNewContest(name);
      await _saveContest(contest);
      await _navigateToContestDetails(contest);
    }
  }

  Contest _createNewContest(String name) {
    return Contest.fromName(name, DateTime.now());
  }

  Future _saveContest(Contest contest) async {
    await contestDataSource.save(contest);
  }

  Future _navigateToContestDetails(Contest contest) async {
    await setContestActive(contest);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ContestDetailsScreen(contestId: contest.id)),
    );
  }

  Future setContestActive(Contest contest) async {
    await contestDataSource.saveActiveContestId(contest.id);
  }
}
