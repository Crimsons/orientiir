import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/conf/Conf.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ContestDataSource contestDataSource = LocalContestDataSource();
  final UserDataSource userDataSource = LocalUserDataSource();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textFieldController = TextEditingController();
  User _user = User.empty();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    var user = await userDataSource.loadData();

    setState(() {
      this._user = user;
      Timer(const Duration(milliseconds: splashDuration), continueToApp);
    });
  }

  void continueToApp() async {
    if (_user != null) {
      final activeContestId = await contestDataSource.loadActiveContestId();
      if (activeContestId != null) {
        navigateToContest(context, activeContestId);
      } else {
        navigateToMain(context);
      }
    }
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
      resizeToAvoidBottomPadding: false,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            padding: const EdgeInsets.only(top: 128, left: 16, right: 16),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 128),
                child: Text(
                  "Orientiir",
                  style: TextStyle(color: Colors.white, fontSize: 64),
                  textAlign: TextAlign.center,
                ),
              ),
              this._user == null ? buildForm() : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Võistlejanimi",
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.left),
        Form(
          key: _formKey,
          child: TextFormField(
            cursorColor: Colors.white,
            validator: (value) {
              if (value
                  .trim()
                  .isEmpty) {
                return 'Palun sisesta võistlejanimi';
              }
            },
            style: TextStyle(fontSize: 32, color: Colors.white),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            autovalidate: false,
            autofocus: false,
            controller: textFieldController,
            onFieldSubmitted: (input) => _onSaveNameClicked(),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                errorStyle: TextStyle(fontSize: 20)),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: RaisedButton(
              child: Text("Edasi"),
              onPressed: _onSaveNameClicked,
              color: Theme
                  .of(context)
                  .accentColor,
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  _onSaveNameClicked() async {
    if (_formKey.currentState.validate()) {
      String name = textFieldController.text.trim();
      if (_user == null) {
        _user = User.fromName(name);
      }
      _user.name = name;
      await _saveUser();
      navigateToMain(context);
    }
  }

  _saveUser() async {
    await userDataSource.saveData(_user);
  }
}
