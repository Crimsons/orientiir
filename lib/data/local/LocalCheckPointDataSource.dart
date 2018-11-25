import 'dart:convert';

import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPointDataSource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCheckPointDataSource implements CheckPointDataSource {
  Future<List<CheckPoint>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString("key_qr_data");
    var data = List();
    if (jsonString != null) {
      var list = json.decode(jsonString) as List;
      data = list.map((item) => CheckPoint.fromJson(item)).toList();
    }

    return data;
  }

  void saveData(List<CheckPoint> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("key_qr_data", json.encode(data));
  }
}
