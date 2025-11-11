// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_actions_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubActionsLogModel _$GithubActionsLogModelFromJson(
        Map<String, dynamic> json) =>
    _GithubActionsLogModel(
      runId: (json['runId'] as num?)?.toInt(),
      jobId: (json['jobId'] as num?)?.toInt(),
      chunk: (json['chunk'] as num?)?.toInt(),
      name: json['name'] as String?,
      downloadUrl: json['downloadUrl'] == null
          ? null
          : ModelUri.fromJson(json['downloadUrl'] as Map<String, dynamic>),
      text: json['text'] as String? ?? "",
      createdAt: json['createdAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubActionsLogModelToJson(
        _GithubActionsLogModel instance) =>
    <String, dynamic>{
      'runId': instance.runId,
      'jobId': instance.jobId,
      'chunk': instance.chunk,
      'name': instance.name,
      'downloadUrl': instance.downloadUrl?.toJson(),
      'text': instance.text,
      'createdAt': instance.createdAt?.toJson(),
      'fromServer': instance.fromServer,
    };
