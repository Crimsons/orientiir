import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Orienteerumise rakendus'),
      ),
      body: Center(
        child: Text("Sisesta võistlejanimi"),
      ),
    );
  }
}
