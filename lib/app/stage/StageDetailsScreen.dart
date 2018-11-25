import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_app/app/login/LoginScreen.dart';
import 'package:hybrid_app/data/local/LocalCheckPointDataSource.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPointDataSource.dart';
import 'package:intl/intl.dart';

class StageDetailsScreen extends StatefulWidget {
  @override
  State createState() => StageDetailsState();
}

class StageDetailsState extends State<StageDetailsScreen> {
  final CheckPointDataSource dataSource = LocalCheckPointDataSource();
  List<CheckPoint> _qrData = List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      appBar: new AppBar(
        title: new Text('Orienteerumise rakendus'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToLogin,
          ),
        ],
      ),
      body: listViewBuilder(),
    );
  }

  ListView listViewBuilder() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        CheckPoint checkPoint = _qrData[index];
        IconData iconData = Icons.beenhere;
        String title = checkPoint.code;
        var formatter = new DateFormat("kk:mm:ss");
        String subTitle = formatter.format(checkPoint.dateTime);
        return ListTile(
          leading: Icon(iconData),
          title: Text(title),
          subtitle: Text(subTitle),
        );
      },
      itemCount: _qrData.length,
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
      setState(() => _qrData.add(checkPoint));
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
    var data = await dataSource.loadData();
    setState(() => _qrData = data);
  }

  void _saveData() async {
    dataSource.saveData(_qrData);
  }
}
