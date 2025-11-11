// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_actions_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubActionsJobModel _$GithubActionsJobModelFromJson(
        Map<String, dynamic> json) =>
    _GithubActionsJobModel(
      id: (json['id'] as num?)?.toInt(),
      runId: (json['runId'] as num?)?.toInt(),
      runAttempt: (json['runAttempt'] as num?)?.toInt(),
      name: json['name'] as String?,
      runnerName: json['runnerName'] as String?,
      runnerId: (json['runnerId'] as num?)?.toInt(),
      runnerGroupId: (json['runnerGroupId'] as num?)?.toInt(),
      status: json['status'] as String?,
      conclusion: json['conclusion'] as String?,
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      runner: json['runner'] == null
          ? null
          : GithubUserModel.fromJson(json['runner'] as Map<String, dynamic>),
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) =>
                  GithubActionsStepValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GithubActionsStepValue>[],
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      logsUrl: json['logsUrl'] == null
          ? null
          : ModelUri.fromJson(json['logsUrl'] as Map<String, dynamic>),
      startedAt: json['startedAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['startedAt'] as Map<String, dynamic>),
      completedAt: json['completedAt'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['completedAt'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubActionsJobModelToJson(
        _GithubActionsJobModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'runId': instance.runId,
      'runAttempt': instance.runAttempt,
      'name': instance.name,
      'runnerName': instance.runnerName,
      'runnerId': instance.runnerId,
      'runnerGroupId': instance.runnerGroupId,
      'status': instance.status,
      'conclusion': instance.conclusion,
      'labels': instance.labels,
      'runner': instance.runner?.toJson(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'url': instance.url?.toJson(),
      'htmlUrl': instance.htmlUrl?.toJson(),
      'logsUrl': instance.logsUrl?.toJson(),
      'startedAt': instance.startedAt?.toJson(),
      'completedAt': instance.completedAt?.toJson(),
      'fromServer': instance.fromServer,
    };

_GithubActionsStepValue _$GithubActionsStepValueFromJson(
        Map<String, dynamic> json) =>
    _GithubActionsStepValue(
      number: (json['number'] as num?)?.toInt(),
      name: json['name'] as String?,
      status: json['status'] as String?,
      conclusion: json['conclusion'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['startedAt'] as Map<String, dynamic>),
      completedAt: json['completedAt'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['completedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubActionsStepValueToJson(
        _GithubActionsStepValue instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'status': instance.status,
      'conclusion': instance.conclusion,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
    };
