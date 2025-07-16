// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_pull_request_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubPullRequestCommentModel _$GithubPullRequestCommentModelFromJson(
        Map<String, dynamic> json) =>
    _GithubPullRequestCommentModel(
      id: (json['id'] as num?)?.toInt(),
      body: json['body'] as String?,
      diffHunk: json['diffHunk'] as String?,
      path: json['path'] as String?,
      position: (json['position'] as num?)?.toInt(),
      originalPosition: (json['originalPosition'] as num?)?.toInt(),
      commitId: json['commitId'] as String?,
      originalCommitId: json['originalCommitId'] as String?,
      user: json['user'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['user'] as Map<String, dynamic>),
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      pullRequestUrl: json['pullRequestUrl'] == null
          ? null
          : ModelUri.fromJson(json['pullRequestUrl'] as Map<String, dynamic>),
      links: json['links'] == null
          ? null
          : ModelUri.fromJson(json['links'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubPullRequestCommentModelToJson(
        _GithubPullRequestCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'diffHunk': instance.diffHunk,
      'path': instance.path,
      'position': instance.position,
      'originalPosition': instance.originalPosition,
      'commitId': instance.commitId,
      'originalCommitId': instance.originalCommitId,
      'user': instance.user,
      'url': instance.url,
      'pullRequestUrl': instance.pullRequestUrl,
      'links': instance.links,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'fromServer': instance.fromServer,
    };
