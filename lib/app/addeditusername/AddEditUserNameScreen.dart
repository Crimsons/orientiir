import 'package:flutter/material.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class AddEditUserNameScreen extends StatefulWidget {
  final bool edit;

  AddEditUserNameScreen({Key key, this.edit = false}) : super(key: key);

  @override
  _AddEditUserNameScreenState createState() => _AddEditUserNameScreenState();
}

class _AddEditUserNameScreenState extends State<AddEditUserNameScreen> {
  final UserDataSource _userDataSource = LocalUserDataSource();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  User _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    var user = await _userDataSource.loadData();
    if (user != null) {
      setState(() {
        _user = user;
        _textFieldController.text = _user.name ?? "";
      });
    }
  }

  void navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  void navigateBack() {
    Navigator.pop(context);
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
              _buildForm()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
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
              if (value.trim().isEmpty) {
                return 'Palun sisesta võistlejanimi';
              }
            },
            style: TextStyle(fontSize: 32, color: Colors.white),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            autovalidate: false,
            autofocus: false,
            controller: _textFieldController,
            onFieldSubmitted: (input) => _handleSaveNamePressed(),
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
              child: Text("Valmis"),
              onPressed: _handleSaveNamePressed,
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  _handleSaveNamePressed() async {
    if (_formKey.currentState.validate()) {
      String name = _textFieldController.text.trim();
      if (_user == null) {
        _user = User.fromName(name);
      } else {
        _user.name = name;
      }
      await _saveUser();

      if (widget.edit) {
        navigateBack();
      } else {
        navigateToMain();
      }
    }
  }

  _saveUser() async {
    await _userDataSource.saveData(_user);
  }
}
