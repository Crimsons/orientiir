import 'package:hybrid_app/data/model/checkpoint/CheckPointType.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'CheckPoint.g.dart';

@JsonSerializable()
class CheckPoint {
  String id;
  String code;
  DateTime dateTime;
  int timestamp;

  CheckPoint(this.id, this.code, this.dateTime, this.timestamp);

  factory CheckPoint.create(String code, DateTime dateTime, int timestamp) {
    return CheckPoint(Uuid().v4(), code, dateTime, timestamp);
  }

  CheckPointType get type {
    if (this.code.contains("START:")) {
      return CheckPointType.start;
    } else if (this.code.contains("FINIS:")) {
      return CheckPointType.finish;
    } else if (this.code.contains("%")) {
      return CheckPointType.checkpoint;
    } else if (this.code.contains("*")) {
      return CheckPointType.extra;
    } else if (this.code.contains("\$")) {
      return CheckPointType.auxiliary;
    } else {
      return CheckPointType.unknown;
    }
  }

  factory CheckPoint.fromJson(Map<String, dynamic> json) =>
      _$CheckPointFromJson(json);

  Map<String, dynamic> toJson() => _$CheckPointToJson(this);
}
