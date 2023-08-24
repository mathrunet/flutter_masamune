// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_ecosystem_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PointEcosystemUserModel _$$_PointEcosystemUserModelFromJson(
        Map<String, dynamic> json) =>
    _$_PointEcosystemUserModel(
      lastDate: json['lastDate'] == null
          ? null
          : ModelTimestamp.fromJson(json['lastDate'] as Map<String, dynamic>),
      continuousCount: json['continuousCount'] as int? ?? 0,
    );

Map<String, dynamic> _$$_PointEcosystemUserModelToJson(
        _$_PointEcosystemUserModel instance) =>
    <String, dynamic>{
      'lastDate': instance.lastDate,
      'continuousCount': instance.continuousCount,
    };
