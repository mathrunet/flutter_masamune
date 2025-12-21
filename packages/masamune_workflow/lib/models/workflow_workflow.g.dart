// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_workflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowWorkflowModel _$WorkflowWorkflowModelFromJson(
        Map<String, dynamic> json) =>
    _WorkflowWorkflowModel(
      name: json['name'] as String?,
      project: json['project'] == null
          ? null
          : ModelRefBase<WorkflowProjectModel>.fromJson(
              json['project'] as Map<String, dynamic>),
      locale: json['locale'] == null
          ? null
          : ModelLocale.fromJson(json['locale'] as Map<String, dynamic>),
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      repeat: $enumDecodeNullable(_$WorkflowRepeatEnumMap, json['repeat']) ??
          WorkflowRepeat.none,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => WorkflowActionCommandValue.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      prompt: json['prompt'] as String?,
      materials: json['materials'] as Map<String, dynamic>?,
      nextTime: json['nextTime'] == null
          ? null
          : ModelTimestamp.fromJson(json['nextTime'] as Map<String, dynamic>),
      startTime: json['startTime'] == null
          ? null
          : ModelTimestamp.fromJson(json['startTime'] as Map<String, dynamic>),
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowWorkflowModelToJson(
        _WorkflowWorkflowModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'project': instance.project,
      'locale': instance.locale,
      'organization': instance.organization,
      'repeat': _$WorkflowRepeatEnumMap[instance.repeat]!,
      'actions': instance.actions,
      'prompt': instance.prompt,
      'materials': instance.materials,
      'nextTime': instance.nextTime,
      'startTime': instance.startTime,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };

const _$WorkflowRepeatEnumMap = {
  WorkflowRepeat.none: 'none',
  WorkflowRepeat.daily: 'daily',
  WorkflowRepeat.weekly: 'weekly',
  WorkflowRepeat.monthly: 'monthly',
};
