import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hybrid_app/data/model/checkpoint/CheckPoint.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ResultCheckPoint.g.dart';

@JsonSerializable()
class ResultCheckPoint {
  String code;
  DateTime dateTime;
  int timestamp;
  String hash;

  ResultCheckPoint(this.code, this.dateTime, this.timestamp, this.hash);

  factory ResultCheckPoint.create(CheckPoint checkPoint) {
    var code = checkPoint.code;
    var dateTime = checkPoint.dateTime;
    var timestamp = checkPoint.timestamp;
    var bytes =
        utf8.encode(code + dateTime.toIso8601String() + timestamp.toString());
    var hash = sha256.convert(bytes).toString();

    return ResultCheckPoint(code, dateTime, timestamp, hash);
  }

  factory ResultCheckPoint.fromJson(Map<String, dynamic> json) =>
      _$ResultCheckPointFromJson(json);

  Map<String, dynamic> toJson() => _$ResultCheckPointToJson(this);
}
