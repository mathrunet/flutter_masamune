// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_pull_request_head.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubPullRequestHeadValue _$GithubPullRequestHeadValueFromJson(
        Map<String, dynamic> json) =>
    _GithubPullRequestHeadValue(
      label: json['label'] as String?,
      ref: json['ref'] as String?,
      sha: json['sha'] as String?,
      user: json['user'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['user'] as Map<String, dynamic>),
      repo: json['repo'] == null
          ? null
          : ModelRefBase<GithubRepositoryModel>.fromJson(
              json['repo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubPullRequestHeadValueToJson(
        _GithubPullRequestHeadValue instance) =>
    <String, dynamic>{
      'label': instance.label,
      'ref': instance.ref,
      'sha': instance.sha,
      'user': instance.user,
      'repo': instance.repo,
    };
