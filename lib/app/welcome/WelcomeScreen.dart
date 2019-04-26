import 'package:flutter/material.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final UserDataSource userDataSource = LocalUserDataSource();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController textFieldController = TextEditingController();
  User _user = User.empty();

  void navigateToMain(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    var user = await userDataSource.loadData();

    setState(() {
      textFieldController.text = user?.name ?? "";
      this._user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text("Võistlejanimi",
                    style: TextStyle(color: Colors.black, fontSize: 26),
                    textAlign: TextAlign.center),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Palun sisesta võistlejanimi';
                    }
                  },
                  style: TextStyle(fontSize: 18),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  autovalidate: true,
                  autofocus: true,
                  controller: textFieldController,
                  onFieldSubmitted: (input) => _onSaveNameClicked(),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    child: Text("Edasi"),
                    onPressed: _onSaveNameClicked,
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
