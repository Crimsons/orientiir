// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
      json['userName'] as String,
      json['contestName'] as String,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      (json['checkpoints'] as List)
          ?.map((e) => e == null
              ? null
              : ResultCheckPoint.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'userName': instance.userName,
      'contestName': instance.contestName,
      'date': instance.date?.toIso8601String(),
      'checkpoints': instance.checkpoints
    };
