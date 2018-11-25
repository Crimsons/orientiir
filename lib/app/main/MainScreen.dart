import 'package:flutter/material.dart';
import 'package:hybrid_app/app/login/LoginScreen.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final UserDataSource userDataSource = LocalUserDataSource();
  final ContestDataSource contestDataSource = LocalContestDataSource();
  User user;
  List<Contest> contests = List();

  @override
  void initState() {
    super.initState();
    loadUser();
    loadContests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddNewContestPressed,
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Orienteerumise rakendus"),
    );
  }

  Center buildBody() {
    return Center(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Contest contest = contests[index];
          IconData iconData = Icons.motorcycle;
          String title = contest.name;
          var formatter = new DateFormat("dd.MM.yyyy");
          String subTitle = formatter.format(contest.date);
          return ListTile(
            leading: Icon(iconData),
            title: Text(title),
            subtitle: Text(subTitle),
          );
        },
        itemCount: contests.length,
      ),
    );
  }

  void loadUser() async {
    var user = await userDataSource.loadData();

    if (user == null) {
      navigateToLogin();
    }

    setState(() {
      this.user = user;
    });
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void loadContests() async {
    var contestList = await contestDataSource.loadAll();

    setState(() {
      this.contests = contestList;
    });
  }

  void onAddNewContestPressed() {
    Contest contest = Contest.fromName("Esimene võistlus", DateTime.now());
    setState(() {
      this.contests.add(contest);
    });
    contestDataSource.save(contest);
  }
}
