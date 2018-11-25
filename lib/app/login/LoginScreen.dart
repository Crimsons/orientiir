import 'package:flutter/material.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final UserDataSource dataSource = LocalUserDataSource();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textFieldController = TextEditingController();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text('Orienteerumise rakendus'),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Mis on sinu võistlejanimi?",
            style: TextStyle(fontSize: 22.0),
          ),
          buildForm(context),
        ],
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Palun sisesta võistlejanimi';
              }
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            controller: textFieldController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  onFormSubmitted(textFieldController.text);
                }
              },
              child: Text('Edasi'),
            ),
          ),
        ],
      ),
    );
  }

  void onFormSubmitted(String text) {
    saveUser(text);
    navigateToMain();
  }

  void saveUser(String text) async {
    User user = User.fromName(text);
    dataSource.saveData(user);
  }

  void navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }
}
