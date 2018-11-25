// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Contest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contest _$ContestFromJson(Map<String, dynamic> json) {
  return Contest(
      json['id'] as String,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['name'] as String,
      (json['checkpoints'] as List)
          ?.map((e) =>
              e == null ? null : CheckPoint.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ContestToJson(Contest instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'name': instance.name,
      'checkpoints': instance.checkpoints
    };
