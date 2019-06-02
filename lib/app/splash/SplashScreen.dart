import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hybrid_app/app/addeditusername/AddEditUserNameScreen.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
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
  final ContestDataSource _contestDataSource = LocalContestDataSource();
  final UserDataSource _userDataSource = LocalUserDataSource();

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: splashDuration), continueToApp);
  }

  void continueToApp() async {
    var user = await _userDataSource.loadData();

    if (user != null) {
      final activeContestId = await _contestDataSource.loadActiveContestId();
      if (activeContestId != null) {
        navigateToContest(activeContestId);
      } else {
        navigateToMain();
      }
    } else {
      navigateToAddEditUserName();
    }
  }

  void navigateToContest(String activeContestId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ContestDetailsScreen(contestId: activeContestId)),
    );
  }

  void navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  void navigateToAddEditUserName() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddEditUserNameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 128),
          child: Text(
            "Orientiir",
            style: TextStyle(color: Colors.white, fontSize: 64),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
