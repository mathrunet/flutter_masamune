// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_issue_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubIssueCommentModel _$GithubIssueCommentModelFromJson(
        Map<String, dynamic> json) =>
    _GithubIssueCommentModel(
      id: (json['id'] as num?)?.toInt(),
      body: json['body'] as String?,
      authorAssociation: json['authorAssociation'] as String?,
      user: json['user'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['user'] as Map<String, dynamic>),
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      issueUrl: json['issueUrl'] == null
          ? null
          : ModelUri.fromJson(json['issueUrl'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubIssueCommentModelToJson(
        _GithubIssueCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'authorAssociation': instance.authorAssociation,
      'user': instance.user,
      'url': instance.url,
      'htmlUrl': instance.htmlUrl,
      'issueUrl': instance.issueUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
