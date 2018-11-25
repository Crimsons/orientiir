import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';

abstract class CheckPointDataSource {
  Future<List<CheckPoint>> loadData();

  void saveData(List<CheckPoint> data);
}
