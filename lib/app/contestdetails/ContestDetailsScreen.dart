import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_app/app/contestdetails/ExitContestDialog.dart';
import 'package:hybrid_app/app/contestdetails/ListItem.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/conf/Conf.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/result/Result.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:uptime/uptime.dart';

class ContestDetailsScreen extends StatefulWidget {
  final ContestDataSource dataSource = LocalContestDataSource();
  final UserDataSource userDataSource = LocalUserDataSource();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String contestId;
  final JsonEncoder jsonEncoder = JsonEncoder.withIndent(jsonIndent);

  ContestDetailsScreen({Key key, @required this.contestId}) : super(key: key);

  @override
  State createState() => ContestDetailsState();
}

class ContestDetailsState extends State<ContestDetailsScreen> {
  Contest contest = new Contest("", DateTime.now(), "", List());
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var contest = await widget.dataSource.load(widget.contestId);
    setState(() {
      this.contest = contest;
    });
  }

  void _handleMenuItemPressed(MenuButton selected) {
    if (selected == MenuButton.send_results) {
      _sendResults();
    } else if (selected == MenuButton.exit) {
      showExitContestDialog();
    }
  }

  void showExitContestDialog() async {
    bool exit = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => ExitContestDialog());

    if (exit) {
      _exitContest();
    }
  }

  Future _exitContest() async {
    await widget.dataSource.clearActiveContestId();
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

  Future _sendResults() async {
    final user = await widget.userDataSource.loadData();
    final result = Result.create(user, contest);
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    var file = File(_getFilename(path, user.name));
    await file.writeAsString(widget.jsonEncoder.convert(result), flush: true);

    Share.shareFile(file);
  }

  String _getFilename(String path, String userName) {
    var fileName = userName
        .trim()
        .toLowerCase()
        .replaceAll("õ", "6")
        .replaceAll("ä", "a")
        .replaceAll("ö", "o")
        .replaceAll("ü", "y")
        .replaceAll("š", "s")
        .replaceAll("ž", "z")
        .replaceAll(new RegExp("[^0-9a-zA-Z_-]"), "");

    return "$path/$fileName.json";
  }

  @override
  Widget build(BuildContext context) {
    Widget fab = FloatingActionButton(
      onPressed: _scan,
      child: Icon(Icons.camera_alt),
    );

    Widget appBar = AppBar(title: Text(contest.name), actions: <Widget>[
      PopupMenuButton(
        onSelected: _handleMenuItemPressed,
        itemBuilder: (BuildContext context) =>
        [
          const PopupMenuItem(
            value: MenuButton.send_results,
            child: Text("Saada tulemused"),
          ),
          const PopupMenuItem(
            value: MenuButton.exit,
            child: Text("Lõpeta"),
          ),
        ],
        tooltip: "Menüü",
      )
    ]);

    return new Scaffold(
      key: widget._scaffoldKey,
      appBar: appBar,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        buildList(),
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          child: RaisedButton(
            onPressed: _scan,
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Text("Registreeri punkt",
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
        )
      ],
    );
  }

  Widget buildList() {
    if (contest.checkpoints.isEmpty) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
              child: Text(
                "Võistluse alustamiseks pildista stardi QR-koodi",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )),
        ),
      );
    } else {
      return Expanded(
        child: ListView.separated(
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            CheckPoint checkPoint = contest.getCheckPoints()[index];
            CheckPoint previousCheckPoint;
            if (index > 0) {
              previousCheckPoint = contest.getCheckPoints()[index - 1];
            }
            return ListItem(
                checkPoint: checkPoint,
                previousCheckPoint: previousCheckPoint,
                onDeletePress: this.removeCheckPoint);
          },
          itemCount: contest
              .getCheckPoints()
              .length,
          separatorBuilder: (context, index) =>
              Divider(
                color: Colors.grey,
                height: 1,
              ),
        ),
      );
    }
  }

  void addCheckPoint(String code, DateTime dateTime, int uptime) {
    CheckPoint checkPoint = CheckPoint.create(code, dateTime, uptime);
    setState(() {
      contest.addCheckPoint(checkPoint);
      scrollToBottom();
    });
    _saveData();
  }

  void removeCheckPoint(CheckPoint checkPoint) {
    setState(() {
      contest.removeCheckPoint(checkPoint);
    });
    _saveData();
  }

  Future _scan() async {
    try {
      String code = await BarcodeScanner.scan();
      if (code == null) {
        _showError("Tekkis viga");
        return;
      }
      var dateTime = DateTime.now();
      var uptime = await Uptime.uptime;
      addCheckPoint(code, dateTime, uptime);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showError("Kaamerale puudub ligipääs");
      } else {
        _showError('Tekkis viga: $e');
      }
    } on FormatException {} catch (e) {
      _showError('Tekkis viga: $e');
    }
  }

  void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future _saveData() async => await widget.dataSource.save(contest);

  void _showError(String message) {
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    print(message);
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    widget._scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

enum MenuButton { send_results, exit }
