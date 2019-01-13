import 'package:hybrid_app/data/model/checkpoint/Contest.dart';

abstract class ContestDataSource {
  Future<List<Contest>> loadAll();

  Future<Contest> load(String id);

  void save(Contest contest);

  Future<String> loadActiveId();

  void saveActiveContestId(String id);
}
