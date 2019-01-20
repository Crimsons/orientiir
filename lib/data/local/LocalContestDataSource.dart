import 'dart:convert';

import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/checkpoint/ContestDataSource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalContestDataSource implements ContestDataSource {
  static const KEY = "key_contests";
  static const KEY_ACTIVE_CONTEST_ID = "key_active_contest_id";

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

    return contentsList.firstWhere((item) => item.id == id, orElse: () => null);
  }

  Future<bool> save(Contest contest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var contests = _loadAll(prefs);
    contests.removeWhere((item) => item.id == contest.id);
    contests.add(contest);
    return _save(prefs, contests);
  }

  Future<bool> _save(SharedPreferences prefs, List contests) {
    return prefs.setString(KEY, json.encode(contests));
  }

  @override
  Future<String> loadActiveContestId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_ACTIVE_CONTEST_ID);
  }

  @override
  Future<bool> saveActiveContestId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY_ACTIVE_CONTEST_ID, id);
  }

  @override
  Future<bool> clearActiveContestId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(KEY_ACTIVE_CONTEST_ID);
  }
}
