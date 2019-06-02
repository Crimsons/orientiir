import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:hybrid_app/app/contestdetails/ExitContestDialog.dart';
import 'package:hybrid_app/app/main/MainScreen.dart';
import 'package:hybrid_app/conf/Conf.dart';
import 'package:hybrid_app/data/local/LocalContestDataSource.dart';
import 'package:hybrid_app/data/local/LocalUserDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:hybrid_app/data/model/result/Result.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uptime/uptime.dart';
import 'package:vibration/vibration.dart';

import 'CheckPointsList.dart';
import 'ContestDetailsAppBar.dart';
import 'NoCheckPointsMessage.dart';

class ContestDetailsScreen extends StatefulWidget {
  final ContestDataSource dataSource = LocalContestDataSource();
  final UserDataSource userDataSource = LocalUserDataSource();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String contestId;

  ContestDetailsScreen({Key key, @required this.contestId}) : super(key: key);

  @override
  State createState() => ContestDetailsState();
}

class ContestDetailsState extends State<ContestDetailsScreen> {
  Contest contest = new Contest("", DateTime.now(), "", List());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var contest = await widget.dataSource.load(widget.contestId);

    if (contest == null) {
      _exitContest();
      return;
    }

    setState(() {
      this.contest = contest;
    });
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
    await _sendResultsEmail(user, contest);
  }

  @override
  Widget build(BuildContext context) {
    final name = contest?.name ?? "";
    final checkpoints = contest?.checkpoints ?? <CheckPoint>[];

    return new Scaffold(
      key: widget._scaffoldKey,
      appBar: ContestDetailsAppBar(name, _sendResults, showExitContestDialog),
      body: Column(
        children: <Widget>[
          Flexible(
              child: checkpoints.isEmpty
                  ? NoCheckPointsMessage()
                  : CheckPointsList(
                  data: checkpoints.reversed.toList(),
                  onDeleteCheckPointPress: this.removeCheckPoint),
              fit: FlexFit.tight),
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
      ),
    );
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
      vibrate();
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

  void addCheckPoint(String code, DateTime dateTime, int uptime) {
    CheckPoint checkPoint = CheckPoint.create(code, dateTime, uptime);
    setState(() {
      contest.addCheckPoint(checkPoint);
    });
    _saveData();
  }

  void vibrate() {
    Vibration.hasVibrator().then((has) {
      if (has) {
        Vibration.vibrate(duration: vibrationDuration);
      }
    });
  }

  void removeCheckPoint(CheckPoint checkPoint) {
    setState(() {
      contest.removeCheckPoint(checkPoint);
    });
    _saveData();
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

Future _sendResultsEmail(User user, Contest contest) async {
  final JsonEncoder jsonEncoder = JsonEncoder.withIndent(jsonIndent);
  final result = Result.create(user, contest);
  final directory = await getTemporaryDirectory();
  final path = directory.path;
  var file = File(_getFilename(path, user.name));
  await file.writeAsString(jsonEncoder.convert(result), flush: true);

  final Email email = Email(
    body: _getResultsEmailBody(user, contest),
    subject: _getResultsEmailSubject(user, contest),
    recipients: [resultRecipientEmail],
    attachmentPath: file.path,
  );

  await FlutterEmailSender.send(email);
}

String _getResultsEmailSubject(User user, Contest contest) {
  return '${user.name} - ${contest.name} tulemused';
}

String _getResultsEmailBody(User user, Contest contest) {
  return 'Võistleja nimi: ${user.name}\nEtapp: ${contest.name}';
}
