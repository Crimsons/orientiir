import 'package:flutter/material.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class UserNameText extends StatelessWidget {
  UserNameText({this.name, this.onPressed});

  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
        Flexible(
          flex: 0,
          child: IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Muuda nime",
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

class UserNameInput extends StatelessWidget {
  UserNameInput({this.formKey, this.textFieldController, this.onPressed});

  final GlobalKey<FormState> formKey;
  final TextEditingController textFieldController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Palun sisesta võistlejanimi';
                }
              },
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: 32, color: Colors.black),
              keyboardType: TextInputType.text,
              autovalidate: true,
              autofocus: true,
              controller: textFieldController,
            ),
          ),
          Flexible(
            flex: 0,
            child: IconButton(
              icon: Icon(Icons.done),
              tooltip: "Salvesta",
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final UserDataSource userDataSource = LocalUserDataSource();
  final _formKey = GlobalKey<FormState>();

  // state
  final TextEditingController textFieldController = TextEditingController();
  User _user = User.empty();
  bool _showNameInput = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    var user = await userDataSource.loadData();

    setState(() {
      textFieldController.text = user?.name ?? "";
      this._showNameInput = user == null;
      this._user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Võistlejanimi",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          _showNameInput
              ? UserNameInput(
                  formKey: _formKey,
                  textFieldController: textFieldController,
                  onPressed: _onSaveNameClicked,
                )
              : UserNameText(name: _user.name, onPressed: _changeUserName),
        ],
      ),
    );
  }

  void _changeUserName() {
    setState(() {
      this._showNameInput = true;
    });
  }

  void _onSaveNameClicked() {
    if (_formKey.currentState.validate()) {
      setState(() {
        String name = textFieldController.text;
        if (_user == null) {
          _user = User.fromName(name);
        }
        _user.name = name;
        _showNameInput = false;
        _saveUser();
      });
    }
  }

  void _saveUser() async {
    userDataSource.saveData(_user);
  }
}
