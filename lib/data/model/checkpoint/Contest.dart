import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'Contest.g.dart';

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

  List<CheckPoint> getCheckPoints() {
    if (checkpoints == null) {
      checkpoints = List();
    }

    return checkpoints;
  }

  void addCheckPoint(CheckPoint checkPoint) {
    if (checkpoints == null) {
      checkpoints = List();
    }

    checkpoints.add(checkPoint);
  }

  void removeCheckPoint(CheckPoint checkPoint) {
    if (checkpoints == null) {
      checkpoints = List();
    }

    checkpoints.remove(checkPoint);
  }

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);

  Map<String, dynamic> toJson() => _$ContestToJson(this);
}
