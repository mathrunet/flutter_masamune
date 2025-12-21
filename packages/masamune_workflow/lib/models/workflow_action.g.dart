// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowActionModel _$WorkflowActionModelFromJson(Map<String, dynamic> json) =>
    _WorkflowActionModel(
      command: WorkflowActionCommandValue.fromJson(
          json['command'] as Map<String, dynamic>),
      task: json['task'] == null
          ? null
          : ModelRefBase<WorkflowTaskModel>.fromJson(
              json['task'] as Map<String, dynamic>),
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
      status:
          $enumDecodeNullable(_$WorkflowTaskStatusEnumMap, json['status']) ??
              WorkflowTaskStatus.waiting,
      locale: json['locale'] == null
          ? null
          : ModelLocale.fromJson(json['locale'] as Map<String, dynamic>),
      error: json['error'] as Map<String, dynamic>?,
      prompt: json['prompt'] as String?,
      log: (json['log'] as List<dynamic>?)
              ?.map((e) =>
                  WorkflowTaskLogValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      materials: json['materials'] as Map<String, dynamic>?,
      results: json['results'] as Map<String, dynamic>?,
      assets: json['assets'] as Map<String, dynamic>?,
      usage: (json['usage'] as num?)?.toDouble() ?? 0,
      search: json['search'] as String?,
      token: json['token'] as String?,
      tokenExpiredTime: json['tokenExpiredTime'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['tokenExpiredTime'] as Map<String, dynamic>),
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

Map<String, dynamic> _$WorkflowActionModelToJson(
        _WorkflowActionModel instance) =>
    <String, dynamic>{
      'command': instance.command,
      'task': instance.task,
      'workflow': instance.workflow,
      'organization': instance.organization,
      'project': instance.project,
      'status': _$WorkflowTaskStatusEnumMap[instance.status]!,
      'locale': instance.locale,
      'error': instance.error,
      'prompt': instance.prompt,
      'log': instance.log,
      'materials': instance.materials,
      'results': instance.results,
      'assets': instance.assets,
      'usage': instance.usage,
      'search': instance.search,
      'token': instance.token,
      'tokenExpiredTime': instance.tokenExpiredTime,
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
