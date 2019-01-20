// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResultCheckPoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultCheckPoint _$ResultCheckPointFromJson(Map<String, dynamic> json) {
  return ResultCheckPoint(
      json['code'] as String,
      json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      json['timestamp'] as int,
      json['hash'] as String);
}

Map<String, dynamic> _$ResultCheckPointToJson(ResultCheckPoint instance) =>
    <String, dynamic>{
      'code': instance.code,
      'dateTime': instance.dateTime?.toIso8601String(),
      'timestamp': instance.timestamp,
      'hash': instance.hash
    };
