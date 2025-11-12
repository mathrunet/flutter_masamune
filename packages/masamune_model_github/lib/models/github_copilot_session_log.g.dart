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
      metadata: json['metadata'] as Map<String, dynamic>?,
      toolName: json['toolName'] as String?,
      toolResult: json['toolResult'] as String?,
      level: $enumDecodeNullable(
              _$GithubCopilotSessionLogLevelEnumMap, json['level']) ??
          GithubCopilotSessionLogLevel.unknown,
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
      'metadata': instance.metadata,
      'toolName': instance.toolName,
      'toolResult': instance.toolResult,
      'level': _$GithubCopilotSessionLogLevelEnumMap[instance.level]!,
      'timestamp': instance.timestamp,
      'fromServer': instance.fromServer,
    };

const _$GithubCopilotSessionLogLevelEnumMap = {
  GithubCopilotSessionLogLevel.unknown: 'unknown',
  GithubCopilotSessionLogLevel.debug: 'debug',
  GithubCopilotSessionLogLevel.info: 'info',
  GithubCopilotSessionLogLevel.warning: 'warning',
  GithubCopilotSessionLogLevel.error: 'error',
};
