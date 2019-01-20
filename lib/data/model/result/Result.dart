import 'package:hybrid_app/data/model/checkpoint/Contest.dart';
import 'package:hybrid_app/data/model/result/ResultCheckPoint.dart';
import 'package:hybrid_app/data/model/user/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Result.g.dart';

@JsonSerializable()
class Result {
  String userName;
  String contestName;
  DateTime date;
  List<ResultCheckPoint> checkpoints;

  Result(this.userName, this.contestName, this.date, this.checkpoints);

  factory Result.create(User user, Contest contest) {
    return Result(
        user.name,
        contest.name,
        contest.date,
        contest.checkpoints
            .map((checkpoint) => ResultCheckPoint.create(checkpoint))
            .toList());
  }

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
