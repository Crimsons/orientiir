import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_app/app/contestdetails/ListItem.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';

class ContestDetailsScreen extends StatefulWidget {
  final String contestId;

  ContestDetailsScreen({Key key, @required this.contestId}) : super(key: key);

  @override
  State createState() => ContestDetailsState();
}

class ContestDetailsState extends State<ContestDetailsScreen> {
  final ContestDataSource dataSource = LocalContestDataSource();
  Contest contest = new Contest("", DateTime.now(), "", List());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var contest = await dataSource.load(widget.contestId);
    setState(() {
      this.contest = contest;
    });
  }

  void _handleMenuItemPressed(MenuButton selected) {
    if (selected == MenuButton.send_results) {
      _sendResults();
    } else if (selected == MenuButton.exit) {
      _exitContest();
    }
  }

  void _exitContest() async {
    await dataSource.clearActiveContestId();
    _navigateToMain();
  }

  void _navigateToMain() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  void _sendResults() {}

  @override
  Widget build(BuildContext context) {
    Widget fab = FloatingActionButton(
      onPressed: _scan,
      child: Icon(Icons.camera_alt),
    );

    Widget appBar = AppBar(title: Text(contest.name), actions: <Widget>[
      PopupMenuButton(
          onSelected: _handleMenuItemPressed,
          itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: MenuButton.send_results,
                  child: Text("Saada tulemused"),
                ),
                const PopupMenuItem(
                  value: MenuButton.exit,
                  child: Text("Lõpeta"),
                ),
              ])
    ]);

    Widget list = ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        CheckPoint checkPoint = contest.getCheckPoints()[index];
        CheckPoint previousCheckPoint;
        if (index > 0) {
          previousCheckPoint = contest.getCheckPoints()[index - 1];
        }
        return ListItem(
          checkPoint: checkPoint,
          previousCheckPoint: previousCheckPoint,
        );
      },
      itemCount: contest.getCheckPoints().length,
    );

    return new Scaffold(
      key: _scaffoldKey,
      floatingActionButton: fab,
      appBar: appBar,
      body: list,
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
      setState(() {
        contest.addCheckPoint(checkPoint);
        _saveData();
      });
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

  void _saveData() async => await dataSource.save(contest);

  void _showError(String message) {
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    print(message);
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

enum MenuButton { send_results, exit }
