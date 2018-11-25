// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CheckPoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckPoint _$CheckPointFromJson(Map<String, dynamic> json) {
  return CheckPoint(
      json['id'] as String,
      json['code'] as String,
      json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      json['hash'] as String);
}

Map<String, dynamic> _$CheckPointToJson(CheckPoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'dateTime': instance.dateTime?.toIso8601String(),
      'hash': instance.hash
    };
