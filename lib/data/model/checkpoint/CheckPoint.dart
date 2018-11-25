import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'package:hybrid_app/data/model/checkpoint/CheckPoint.g.dart';

@JsonSerializable()
class CheckPoint {
  String id;
  String code;
  DateTime dateTime;
  String hash;

  CheckPoint(this.id, this.code, this.dateTime, this.hash);

  CheckPoint.fromCode(String code) {
    this.id = Uuid().v4();
    this.code = code;
    this.dateTime = DateTime.now();
    var bytes = utf8.encode(id + code + dateTime.toIso8601String());
    this.hash = sha256.convert(bytes).toString();
  }

  factory CheckPoint.fromJson(Map<String, dynamic> json) =>
      _$CheckPointFromJson(json);

  Map<String, dynamic> toJson() => _$CheckPointToJson(this);
}

/*
* flutter packages pub run build_runner watch
*/
