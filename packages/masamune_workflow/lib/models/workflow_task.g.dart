// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowTaskModel _$WorkflowTaskModelFromJson(Map<String, dynamic> json) =>
    _WorkflowTaskModel(
      workflow: json['workflow'] == null
          ? null
          : ModelRefBase<WorkflowWorkflowModel>.fromJson(
              json['workflow'] as Map<String, dynamic>),
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : ModelRefBase<WorkflowProjectModel>.fromJson(
              json['project'] as Map<String, dynamic>),
      locale: json['locale'] == null
          ? null
          : ModelLocale.fromJson(json['locale'] as Map<String, dynamic>),
      status:
          $enumDecodeNullable(_$WorkflowTaskStatusEnumMap, json['status']) ??
              WorkflowTaskStatus.waiting,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => WorkflowActionCommandValue.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentAction: json['currentAction'] == null
          ? null
          : ModelRefBase<WorkflowActionModel>.fromJson(
              json['currentAction'] as Map<String, dynamic>),
      nextAction: json['nextAction'] == null
          ? null
          : WorkflowActionCommandValue.fromJson(
              json['nextAction'] as Map<String, dynamic>),
      error: json['error'] as Map<String, dynamic>?,
      log: (json['log'] as List<dynamic>?)
              ?.map((e) =>
                  WorkflowTaskLogValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      prompt: json['prompt'] as String?,
      materials: json['materials'] as Map<String, dynamic>?,
      results: json['results'] as Map<String, dynamic>?,
      assets: json['assets'] as Map<String, dynamic>?,
      search: json['search'] as String?,
      usage: (json['usage'] as num?)?.toDouble() ?? 0,
      startTime: json['startTime'] == null
          ? null
          : ModelTimestamp.fromJson(json['startTime'] as Map<String, dynamic>),
      finishedTime: json['finishedTime'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['finishedTime'] as Map<String, dynamic>),
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowTaskModelToJson(_WorkflowTaskModel instance) =>
    <String, dynamic>{
      'workflow': instance.workflow,
      'organization': instance.organization,
      'project': instance.project,
      'locale': instance.locale,
      'status': _$WorkflowTaskStatusEnumMap[instance.status]!,
      'actions': instance.actions,
      'currentAction': instance.currentAction,
      'nextAction': instance.nextAction,
      'error': instance.error,
      'log': instance.log,
      'prompt': instance.prompt,
      'materials': instance.materials,
      'results': instance.results,
      'assets': instance.assets,
      'search': instance.search,
      'usage': instance.usage,
      'startTime': instance.startTime,
      'finishedTime': instance.finishedTime,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };

const _$WorkflowTaskStatusEnumMap = {
  WorkflowTaskStatus.waiting: 'waiting',
  WorkflowTaskStatus.running: 'running',
  WorkflowTaskStatus.failed: 'failed',
  WorkflowTaskStatus.completed: 'completed',
  WorkflowTaskStatus.canceled: 'canceled',
};
