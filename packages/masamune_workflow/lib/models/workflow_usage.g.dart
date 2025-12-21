// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowUsageModel _$WorkflowUsageModelFromJson(Map<String, dynamic> json) =>
    _WorkflowUsageModel(
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      usage: (json['usage'] as num?)?.toDouble() ?? 0,
      latestPlan: json['latestPlan'] as String?,
      bucketBalance: (json['bucketBalance'] as num?)?.toDouble() ?? 0,
      lastCheckTime: json['lastCheckTime'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['lastCheckTime'] as Map<String, dynamic>),
      currentMonth: json['currentMonth'] as String?,
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowUsageModelToJson(_WorkflowUsageModel instance) =>
    <String, dynamic>{
      'organization': instance.organization,
      'usage': instance.usage,
      'latestPlan': instance.latestPlan,
      'bucketBalance': instance.bucketBalance,
      'lastCheckTime': instance.lastCheckTime,
      'currentMonth': instance.currentMonth,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };
