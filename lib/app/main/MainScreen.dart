import 'package:flutter/material.dart';
import 'package:hybrid_app/app/login/LoginScreen.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final UserDataSource dataSource = LocalUserDataSource();
  User user;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold();
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Orienteerumise rakendus"),
    );
  }

  Center buildBody() {
    return Center(
      child: Text('Tere, ' + user.name + "!"),
    );
  }

  void loadData() async {
    var user = await dataSource.loadData();

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
}
