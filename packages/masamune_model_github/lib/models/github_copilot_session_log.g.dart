// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_copilot_session_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubCopilotSessionLogModel _$GithubCopilotSessionLogModelFromJson(
        Map<String, dynamic> json) =>
    _GithubCopilotSessionLogModel(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      message: json['message'] as String,
      level: json['level'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      toolName: json['toolName'] as String?,
      toolResult: json['toolResult'] as String?,
      timestamp: json['timestamp'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(json['timestamp'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubCopilotSessionLogModelToJson(
        _GithubCopilotSessionLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'message': instance.message,
      'level': instance.level,
      'metadata': instance.metadata,
      'toolName': instance.toolName,
      'toolResult': instance.toolResult,
      'timestamp': instance.timestamp,
      'fromServer': instance.fromServer,
    };
