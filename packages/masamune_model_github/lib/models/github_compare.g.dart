// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_compare.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubCompareModel _$GithubCompareModelFromJson(Map<String, dynamic> json) =>
    _GithubCompareModel(
      status: json['status'] as String?,
      aheadBy: (json['aheadBy'] as num?)?.toInt() ?? 0,
      behindBy: (json['behindBy'] as num?)?.toInt() ?? 0,
      totalCommits: (json['totalCommits'] as num?)?.toInt() ?? 0,
      mergeBaseCommit: json['mergeBaseCommit'] == null
          ? null
          : GithubCommitModel.fromJson(
              json['mergeBaseCommit'] as Map<String, dynamic>),
      baseCommit: json['baseCommit'] == null
          ? null
          : GithubCommitModel.fromJson(
              json['baseCommit'] as Map<String, dynamic>),
      commits: (json['commits'] as List<dynamic>?)
              ?.map(
                  (e) => GithubCommitModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      diffUrl: json['diffUrl'] == null
          ? null
          : ModelUri.fromJson(json['diffUrl'] as Map<String, dynamic>),
      patchUrl: json['patchUrl'] == null
          ? null
          : ModelUri.fromJson(json['patchUrl'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      permalinkUrl: json['permalinkUrl'] == null
          ? null
          : ModelUri.fromJson(json['permalinkUrl'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubCompareModelToJson(_GithubCompareModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'aheadBy': instance.aheadBy,
      'behindBy': instance.behindBy,
      'totalCommits': instance.totalCommits,
      'mergeBaseCommit': instance.mergeBaseCommit?.toJson(),
      'baseCommit': instance.baseCommit?.toJson(),
      'commits': instance.commits.map((e) => e.toJson()).toList(),
      'diffUrl': instance.diffUrl?.toJson(),
      'patchUrl': instance.patchUrl?.toJson(),
      'htmlUrl': instance.htmlUrl?.toJson(),
      'permalinkUrl': instance.permalinkUrl?.toJson(),
      'fromServer': instance.fromServer,
    };
