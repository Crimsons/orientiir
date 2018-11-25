import 'package:flutter/material.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/login/LoginScreen.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final UserDataSource userDataSource = LocalUserDataSource();
  final ContestDataSource contestDataSource = LocalContestDataSource();
  List<Contest> _contests = List();

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadContests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddNewContestPressed,
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Orienteerumise rakendus"),
    );
  }

  Center _buildBody() {
    return Center(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Contest contest = _contests[index];
          IconData iconData = Icons.motorcycle;
          String title = contest.name;
          var formatter = new DateFormat("dd.MM.yyyy");
          String subTitle = formatter.format(contest.date);
          return ListTile(
            leading: Icon(iconData),
            title: Text(title),
            subtitle: Text(subTitle),
            onTap: () => _onListItemTapped(contest),
          );
        },
        itemCount: _contests.length,
      ),
    );
  }

  void _loadUser() async {
    var user = await userDataSource.loadData();

    if (user == null) {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _loadContests() async {
    var contestList = await contestDataSource.loadAll();

    setState(() {
      this._contests = contestList;
    });
  }

  void _onAddNewContestPressed() {
    Contest contest = Contest.fromName("Esimene võistlus", DateTime.now());
    contest.checkpoints = [CheckPoint.fromCode("29")];
    setState(() {
      this._contests.add(contest);
    });
    _saveContest(contest);
  }

  void _saveContest(Contest contest) {
    contestDataSource.save(contest);
  }

  void _onListItemTapped(Contest contest) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContestDetailsScreen(contestId: contest.id)),
    );
  }
}
