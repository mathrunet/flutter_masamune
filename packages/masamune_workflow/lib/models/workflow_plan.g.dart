// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowPlanModel _$WorkflowPlanModelFromJson(Map<String, dynamic> json) =>
    _WorkflowPlanModel(
      limit: (json['limit'] as num?)?.toDouble() ?? 0,
      burst: (json['burst'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$WorkflowPlanModelToJson(_WorkflowPlanModel instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'burst': instance.burst,
    };
