import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'package:hybrid_app/data/model/checkpoint/Contest.g.dart';

@JsonSerializable()
class Contest {
  String id;
  DateTime date;
  String name;
  List<CheckPoint> checkpoints;

  Contest(this.id, this.date, this.name, this.checkpoints);

  Contest.fromName(String name, DateTime date) {
    this.id = Uuid().v4();
    this.date = date;
    this.name = name;
    this.checkpoints = List();
  }

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);

  Map<String, dynamic> toJson() => _$ContestToJson(this);
}
