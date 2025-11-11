// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_actions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubActionsModel _$GithubActionsModelFromJson(Map<String, dynamic> json) =>
    _GithubActionsModel(
      id: (json['id'] as num?)?.toInt(),
      workflowId: (json['workflowId'] as num?)?.toInt(),
      runNumber: (json['runNumber'] as num?)?.toInt(),
      runAttempt: (json['runAttempt'] as num?)?.toInt(),
      name: json['name'] as String?,
      displayTitle: json['displayTitle'] as String?,
      event: json['event'] as String?,
      status: json['status'] as String?,
      conclusion: json['conclusion'] as String?,
      headBranch: json['headBranch'] as String?,
      headSha: json['headSha'] as String?,
      path: json['path'] as String?,
      actor: json['actor'] == null
          ? null
          : GithubUserModel.fromJson(json['actor'] as Map<String, dynamic>),
      triggeringActor: json['triggeringActor'] == null
          ? null
          : GithubUserModel.fromJson(
              json['triggeringActor'] as Map<String, dynamic>),
      repository: json['repository'] == null
          ? null
          : ModelRefBase<GithubRepositoryModel>.fromJson(
              json['repository'] as Map<String, dynamic>),
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      jobsUrl: json['jobsUrl'] == null
          ? null
          : ModelUri.fromJson(json['jobsUrl'] as Map<String, dynamic>),
      logsUrl: json['logsUrl'] == null
          ? null
          : ModelUri.fromJson(json['logsUrl'] as Map<String, dynamic>),
      artifactsUrl: json['artifactsUrl'] == null
          ? null
          : ModelUri.fromJson(json['artifactsUrl'] as Map<String, dynamic>),
      cancelUrl: json['cancelUrl'] == null
          ? null
          : ModelUri.fromJson(json['cancelUrl'] as Map<String, dynamic>),
      rerunUrl: json['rerunUrl'] == null
          ? null
          : ModelUri.fromJson(json['rerunUrl'] as Map<String, dynamic>),
      workflowUrl: json['workflowUrl'] == null
          ? null
          : ModelUri.fromJson(json['workflowUrl'] as Map<String, dynamic>),
      checkSuiteUrl: json['checkSuiteUrl'] == null
          ? null
          : ModelUri.fromJson(json['checkSuiteUrl'] as Map<String, dynamic>),
      previousAttemptUrl: json['previousAttemptUrl'] == null
          ? null
          : ModelUri.fromJson(
              json['previousAttemptUrl'] as Map<String, dynamic>),
      runStartedAt: json['runStartedAt'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['runStartedAt'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubActionsModelToJson(_GithubActionsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workflowId': instance.workflowId,
      'runNumber': instance.runNumber,
      'runAttempt': instance.runAttempt,
      'name': instance.name,
      'displayTitle': instance.displayTitle,
      'event': instance.event,
      'status': instance.status,
      'conclusion': instance.conclusion,
      'headBranch': instance.headBranch,
      'headSha': instance.headSha,
      'path': instance.path,
      'actor': instance.actor?.toJson(),
      'triggeringActor': instance.triggeringActor?.toJson(),
      'repository': instance.repository?.toJson(),
      'url': instance.url?.toJson(),
      'htmlUrl': instance.htmlUrl?.toJson(),
      'jobsUrl': instance.jobsUrl?.toJson(),
      'logsUrl': instance.logsUrl?.toJson(),
      'artifactsUrl': instance.artifactsUrl?.toJson(),
      'cancelUrl': instance.cancelUrl?.toJson(),
      'rerunUrl': instance.rerunUrl?.toJson(),
      'workflowUrl': instance.workflowUrl?.toJson(),
      'checkSuiteUrl': instance.checkSuiteUrl?.toJson(),
      'previousAttemptUrl': instance.previousAttemptUrl?.toJson(),
      'runStartedAt': instance.runStartedAt?.toJson(),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'fromServer': instance.fromServer,
    };
