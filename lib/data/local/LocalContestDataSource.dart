import 'dart:convert';

import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalContestDataSource implements ContestDataSource {
  static const KEY = "key_contests";

  Future<List<Contest>> loadAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return _loadAll(prefs);
  }

  List<Contest> _loadAll(SharedPreferences prefs) {
    String jsonString = prefs.getString(KEY);
    var data = List<Contest>();
    if (jsonString != null) {
      var list = json.decode(jsonString) as List;
      data = list.map((item) => Contest.fromJson(item)).toList();
    }

    return data;
  }

  @override
  Future<Contest> load(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var contentsList = _loadAll(prefs);

    return contentsList.firstWhere((contest) => contest.id == id,
        orElse: () => null);
  }

  void save(Contest contest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var contests = _loadAll(prefs);
    contests.remove(contest);
    contests.add(contest);
    _save(prefs, contests);
  }

  void _save(SharedPreferences prefs, List contests) {
    prefs.setString(KEY, json.encode(contests));
  }
}
