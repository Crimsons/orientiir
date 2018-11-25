import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_app/data/local/LocalDataSource.dart';
import 'package:hybrid_app/data/model/CheckPoint.dart';
import 'package:hybrid_app/data/model/DataSource.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DataSource<CheckPoint> dataSource = LocalDataSource();
  List<CheckPoint> _qrData = List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: _scan,
          child: Icon(Icons.add),
        ),
        appBar: new AppBar(
          title: new Text('Orienteerumise rakendus'),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            CheckPoint checkPoint = _qrData[index];
            return ListTile(
              leading: Icon(Icons.map),
              title: Text(checkPoint.code +
                  " - " +
                  checkPoint.dateTime.toIso8601String()),
              subtitle: Text(checkPoint.hash ?? ""),
            );
          },
          itemCount: _qrData.length,
        ),
      ),
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
