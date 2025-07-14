// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository_permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubRepositoryPermissionValue _$GithubRepositoryPermissionValueFromJson(
        Map<String, dynamic> json) =>
    _GithubRepositoryPermissionValue(
      admin: json['admin'] as bool? ?? false,
      push: json['push'] as bool? ?? false,
      pull: json['pull'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubRepositoryPermissionValueToJson(
        _GithubRepositoryPermissionValue instance) =>
    <String, dynamic>{
      'admin': instance.admin,
      'push': instance.push,
      'pull': instance.pull,
    };
