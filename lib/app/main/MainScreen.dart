import 'package:flutter/material.dart';
import 'package:hybrid_app/app/contestdetails/ContestDetailsScreen.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
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
  User user;
  bool shouldShowNameInput = false;

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
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddNewContestPressed,
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Orienteerumise rakendus"),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildName(context),
        ],
      ),
    );
  }

  Widget buildName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: shouldShowNameInput
          ? buildNameInput(context)
          : buildNameWidget(context),
    );
  }

  Widget buildNameWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Text(
            user?.name ?? "",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: IconButton(
              icon: Icon(Icons.edit),
              tooltip: "Muuda nime",
              onPressed: () {
                setState(() {
                  this.shouldShowNameInput = true;
                });
              },
            ),
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
              decoration: InputDecoration(hintText: 'võistlejanimi'),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              autovalidate: true,
              controller: textFieldController,
            ),
          ),
          Flexible(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: IconButton(
                icon: Icon(Icons.done),
                tooltip: "Salvesta",
                onPressed: () {
                  onSaveNameClicked();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSaveNameClicked() {
    if (_formKey.currentState.validate()) {
      setState(() {
        String name = textFieldController.text;
        if (user == null) {
          user = User.fromName(name);
        }
        user.name = name;
        shouldShowNameInput = false;
        saveUser();
      });
    }
  }

  void saveUser() async {
    userDataSource.saveData(user);
  }

  void _loadUser() async {
    var user = await userDataSource.loadData();

    setState(() {
      this.shouldShowNameInput = user == null;
      this.user = user;
    });
  }

  void _onAddNewContestPressed() {
    Contest contest = Contest.fromName("Esimene võistlus", DateTime.now());
    contest.checkpoints = [CheckPoint.fromCode("29")];
    _saveContest(contest);
  }

  void _saveContest(Contest contest) {
    contestDataSource.save(contest);
  }

  void _onListItemTapped(Contest contest) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContestDetailsScreen(contestId: contest.id)),
    );
  }
}
