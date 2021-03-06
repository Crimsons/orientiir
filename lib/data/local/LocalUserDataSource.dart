import 'dart:convert';

import 'package:hybrid_app/data/model/user/User.dart';
import 'package:hybrid_app/data/model/user/UserDataSource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserDataSource implements UserDataSource {
  static const KEY = "key_user";

  Future<User> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(KEY);
    var user;
    if (jsonString != null) {
      var userJson = json.decode(jsonString);
      user = User.fromJson(userJson);
    }

    return user;
  }

  Future<bool> saveData(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY, json.encode(user));
  }
}
