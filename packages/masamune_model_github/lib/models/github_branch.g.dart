// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubBranchModel _$GithubBranchModelFromJson(Map<String, dynamic> json) =>
    _GithubBranchModel(
      name: json['name'] as String?,
      commit: json['commit'] == null
          ? null
          : GithubCommitModel.fromJson(json['commit'] as Map<String, dynamic>),
      baseRef: json['baseRef'] == null
          ? null
          : ModelRefBase<GithubBranchModel>.fromJson(
              json['baseRef'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubBranchModelToJson(_GithubBranchModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'commit': instance.commit,
      'baseRef': instance.baseRef,
      'fromServer': instance.fromServer,
    };
