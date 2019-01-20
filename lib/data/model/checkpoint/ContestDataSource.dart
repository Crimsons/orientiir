import 'package:hybrid_app/data/model/checkpoint/Contest.dart';

abstract class ContestDataSource {
  Future<List<Contest>> loadAll();

  Future<Contest> load(String id);

  Future<bool> save(Contest contest);

  Future<String> loadActiveContestId();

  Future<bool> saveActiveContestId(String id);

  Future<bool> clearActiveContestId();
}
