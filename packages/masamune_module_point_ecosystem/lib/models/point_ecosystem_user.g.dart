// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_ecosystem_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PointEcosystemUserModelImpl _$$PointEcosystemUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PointEcosystemUserModelImpl(
      lastDate: json['lastDate'] == null
          ? null
          : ModelTimestamp.fromJson(json['lastDate'] as Map<String, dynamic>),
      continuousCount: json['continuousCount'] as int? ?? 0,
    );

Map<String, dynamic> _$$PointEcosystemUserModelImplToJson(
        _$PointEcosystemUserModelImpl instance) =>
    <String, dynamic>{
      'lastDate': instance.lastDate,
      'continuousCount': instance.continuousCount,
    };
