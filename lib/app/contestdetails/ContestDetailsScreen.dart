import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_app/app/login/LoginScreen.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:intl/intl.dart';

class ContestDetailsScreen extends StatefulWidget {
  final String contestId;

  ContestDetailsScreen({Key key, @required this.contestId}) : super(key: key);

  @override
  State createState() => ContestDetailsState(contestId);
}

class ContestDetailsState extends State<ContestDetailsScreen> {
  final ContestDataSource dataSource = LocalContestDataSource();
  final String contestId;
  Contest contest;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ContestDetailsState(this.contestId) : super();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        child: Icon(Icons.add),
      ),
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text('Orienteerumise rakendus'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: navigateToLogin,
        ),
      ],
    );
  }

  Widget buildBody() {
    if (contest == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return buildListView();
    }
  }

  Widget buildListView() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        CheckPoint checkPoint = contest.getCheckPoints()[index];
        IconData iconData = Icons.beenhere;
        String title = checkPoint.code;
        var formatter = DateFormat("kk:mm:ss");
        String subTitle = formatter.format(checkPoint.dateTime);
        return ListTile(
          leading: Icon(iconData),
          title: Text(title),
          subtitle: Text(subTitle),
        );
      },
      itemCount: contest
          .getCheckPoints()
          .length,
    );
  }

  Future _scan() async {
    try {
      String code = await BarcodeScanner.scan();
      if (code == null) {
        _showError("qrcode is null");
        return;
      }
      CheckPoint checkPoint = CheckPoint.fromCode(code);
      setState(() => contest.addCheckPoint(checkPoint));
      _saveData();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showError("Access denied");
      } else {
        _showError('Unknown error: $e');
      }
    } on FormatException {
      _showError('User pressed back');
    } catch (e) {
      _showError('Unknown error: $e');
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showError(String message) {
    _showSnackBar(message);
    setState(() {});
  }

  void _showSnackBar(String message) {
    print(message);
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _loadData() async {
    var contest = await dataSource.load(contestId);
    setState(() {
      this.contest = contest;
    });
  }

  void _saveData() async => dataSource.save(contest);
}
