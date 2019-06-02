import 'package:flutter/material.dart';
import 'package:hybrid_app/app/addeditusername/AddEditUserNameScreen.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/main/NewContestDialog.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

import 'ContestList.dart';
import 'MainAppBar.dart';
import 'NoContentText.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final ContestDataSource _contestDataSource = LocalContestDataSource();
  final UserDataSource _userDataSource = LocalUserDataSource();

  List<Contest> _contestList = [];
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadContestList();
  }

  void _loadUserName() async {
    var user = await _userDataSource.loadData();
    setState(() {
      _userName = user?.name ?? "";
    });
  }

  void _loadContestList() async {
    var contests = await _contestDataSource.loadAll();
    contests.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _contestList = contests;
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
        appBar: MainAppBar(_userName, _handleEditUserNamePressed),
        body: _contestList.isEmpty
            ? NoContentText()
            : ContestList(_contestList, _handleContestPressed));
  }

  void _handleEditUserNamePressed() {
    navigateToEditUserName();
  }

  void _handleContestPressed(Contest contest) {
    _navigateToContestDetails(contest);
  }

  void navigateToEditUserName() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditUserNameScreen(edit: true)),
    );
    _loadUserName();
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
    await _contestDataSource.save(contest);
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
    await _contestDataSource.saveActiveContestId(contest.id);
  }
}
