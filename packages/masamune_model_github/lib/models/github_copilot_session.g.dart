// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_copilot_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubCopilotSessionModel _$GithubCopilotSessionModelFromJson(
        Map<String, dynamic> json) =>
    _GithubCopilotSessionModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      resourceType: json['resourceType'] as String?,
      resourceId: json['resourceId'] as String?,
      userId: json['userId'] as String?,
      agentId: json['agentId'] as String?,
      errorMessage: json['errorMessage'] as String?,
      errorCode: json['errorCode'] as String?,
      pullRequestNumber: (json['pullRequestNumber'] as num?)?.toInt(),
      pullRequestUrl: json['pullRequestUrl'] as String?,
      pullRequestId: json['pullRequestId'] as String?,
      pullRequestBaseRef: json['pullRequestBaseRef'] as String?,
      status: $enumDecodeNullable(
              _$GithubCopilotSessionStatusEnumMap, json['status']) ??
          GithubCopilotSessionStatus.none,
      completedAt: json['completedAt'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['completedAt'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubCopilotSessionModelToJson(
        _GithubCopilotSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'resourceType': instance.resourceType,
      'resourceId': instance.resourceId,
      'userId': instance.userId,
      'agentId': instance.agentId,
      'errorMessage': instance.errorMessage,
      'errorCode': instance.errorCode,
      'pullRequestNumber': instance.pullRequestNumber,
      'pullRequestUrl': instance.pullRequestUrl,
      'pullRequestId': instance.pullRequestId,
      'pullRequestBaseRef': instance.pullRequestBaseRef,
      'status': _$GithubCopilotSessionStatusEnumMap[instance.status]!,
      'completedAt': instance.completedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'fromServer': instance.fromServer,
    };

const _$GithubCopilotSessionStatusEnumMap = {
  GithubCopilotSessionStatus.none: 'none',
  GithubCopilotSessionStatus.unknown: 'unknown',
  GithubCopilotSessionStatus.running: 'running',
  GithubCopilotSessionStatus.completed: 'completed',
  GithubCopilotSessionStatus.failed: 'failed',
};
