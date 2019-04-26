import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/app/welcome/WelcomeScreen.dart';
import 'package:hybrid_app/conf/Conf.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ContestDataSource contestDataSource = LocalContestDataSource();
  final UserDataSource userDataSource = LocalUserDataSource();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: splashDuration), continueToApp);
  }

  void continueToApp() async {
    final activeContestId = await contestDataSource.loadActiveContestId();
    final user = await userDataSource.loadData();

    if (user == null || user.name == null || user.name.isEmpty) {
      navigateToWelcome(context);
    } else if (activeContestId != null) {
      navigateToContest(context, activeContestId);
    } else {
      navigateToMain(context);
    }
  }

  void navigateToWelcome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  void navigateToContest(BuildContext context, String activeContestId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ContestDetailsScreen(contestId: activeContestId)),
    );
  }

  void navigateToMain(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          "Orientiir",
          style: TextStyle(color: Colors.black, fontSize: 42),
        ),
      ),
    );
  }
}
