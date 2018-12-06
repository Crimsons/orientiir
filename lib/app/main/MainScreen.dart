import 'package:flutter/material.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/app/main/NewContestDialog.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final UserDataSource userDataSource = LocalUserDataSource();
  final ContestDataSource contestDataSource = LocalContestDataSource();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textFieldController = TextEditingController();
  User _user;
  bool _showNameInput = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Orienteerumise rakendus"),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.only(left: 16, right: 16, top: 148, bottom: 16),
      children: <Widget>[
        buildName(context),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text("Uus võistlus"),
            onPressed: (_user != null && _user.name != null)
                ? _showNewContestDialog
                : null,
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text("Vaata viimast"),
            onPressed: null,
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Võistlejanimi",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          _showNameInput ? buildNameInput(context) : buildNameWidget(context),
        ],
      ),
    );
  }

  Widget buildNameWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              _user?.name ?? "",
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
        Flexible(
          flex: 0,
          child: IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Muuda nime",
            onPressed: () {
              setState(() {
                this._showNameInput = true;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildNameInput(BuildContext context) {
    return Form(
      key: _formKey,
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
              onPressed: () {
                _onSaveNameClicked();
              },
            ),
          ),
        ],
      ),
    );
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

  void _loadUser() async {
    var user = await userDataSource.loadData();

    setState(() {
      textFieldController.text = user?.name ?? "";
      this._showNameInput = user == null;
      this._user = user;
    });
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
}
