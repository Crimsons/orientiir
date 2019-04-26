import 'package:hybrid_app/data/model/user/User.dart';

abstract class UserDataSource {
  Future<User> loadData();

  Future<bool> saveData(User data);
}
