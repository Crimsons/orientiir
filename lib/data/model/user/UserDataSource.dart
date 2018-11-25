import 'package:hybrid_app/data/model/user/User.dart';

abstract class UserDataSource {
  Future<User> loadData();

  void saveData(User data);
}
