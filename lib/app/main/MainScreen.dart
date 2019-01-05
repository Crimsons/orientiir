import 'package:flutter/material.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/main/NewContestDialog.dart';
import 'package:hybrid_app/app/main/component/LastCompetitionButton.dart';
import 'package:hybrid_app/app/main/component/NewCompetitionButton.dart';
import 'package:hybrid_app/app/main/component/UserName.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final ContestDataSource contestDataSource = LocalContestDataSource();

  Contest _lastContest;

  @override
  void initState() {
    super.initState();
    _loadLastContest();
  }

  void _loadLastContest() async {
    var contests = await contestDataSource.loadAll();

    setState(() {
      _lastContest = contests.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orienteerumise rakendus"),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 148, bottom: 16),
        children: <Widget>[
          UserName(),
          NewCompetitionButton(onPressed: _showNewContestDialog),
          LastCompetitionButton(
              onPressed:
              _lastContest != null ? _navigateToLastContestDetails : null),
        ],
      ),
    );
  }

  void _showNewContestDialog() async {
    var name = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => NewContestDialog());

    if (name != null) {
      Contest contest = _createNewContest(name);
      _saveContest(contest);
      _navigateToContestDetails(contest);
    }
  }

  Contest _createNewContest(String name) {
    return Contest.fromName(name, DateTime.now());
  }

  void _saveContest(Contest contest) {
    contestDataSource.save(contest);
  }

  void _navigateToContestDetails(Contest contest) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContestDetailsScreen(contestId: contest.id)),
    );
  }

  void _navigateToLastContestDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ContestDetailsScreen(contestId: _lastContest.id)),
    );
  }
}
