// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_commit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubCommitModel _$GithubCommitModelFromJson(Map<String, dynamic> json) =>
    _GithubCommitModel(
      sha: json['sha'] as String?,
      message: json['message'] as String?,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      additionsCount: (json['additionsCount'] as num?)?.toInt() ?? 0,
      deletionsCount: (json['deletionsCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      commentsUrl: json['commentsUrl'] == null
          ? null
          : ModelUri.fromJson(json['commentsUrl'] as Map<String, dynamic>),
      author: json['author'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['author'] as Map<String, dynamic>),
      committer: json['committer'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['committer'] as Map<String, dynamic>),
      parents: (json['parents'] as List<dynamic>?)
              ?.map(
                  (e) => GithubCommitModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      contents: (json['contents'] as List<dynamic>?)
              ?.map(
                  (e) => GithubContentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubCommitModelToJson(_GithubCommitModel instance) =>
    <String, dynamic>{
      'sha': instance.sha,
      'message': instance.message,
      'commentCount': instance.commentCount,
      'additionsCount': instance.additionsCount,
      'deletionsCount': instance.deletionsCount,
      'totalCount': instance.totalCount,
      'url': instance.url,
      'htmlUrl': instance.htmlUrl,
      'commentsUrl': instance.commentsUrl,
      'author': instance.author,
      'committer': instance.committer,
      'parents': instance.parents,
      'contents': instance.contents,
      'fromServer': instance.fromServer,
    };
