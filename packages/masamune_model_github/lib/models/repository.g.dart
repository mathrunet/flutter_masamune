// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RepositoryModel _$RepositoryModelFromJson(Map<String, dynamic> json) =>
    _RepositoryModel(
      name: json['name'] as String? ?? "",
      fullName: json['fullName'] as String? ?? "",
      description: json['description'] as String? ?? "",
      private: json['private'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt(),
      htmlUrl: json['htmlUrl'] as String?,
      cloneUrl: json['cloneUrl'] as String?,
      sshUrl: json['sshUrl'] as String?,
      owner:
          json['owner'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      defaultBranch: json['defaultBranch'] as String?,
      language: json['language'] as String?,
      stargazersCount: (json['stargazersCount'] as num?)?.toInt() ?? 0,
      forksCount: (json['forksCount'] as num?)?.toInt() ?? 0,
      openIssuesCount: (json['openIssuesCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      pushedAt: json['pushedAt'] as String?,
    );

Map<String, dynamic> _$RepositoryModelToJson(_RepositoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'fullName': instance.fullName,
      'description': instance.description,
      'private': instance.private,
      'id': instance.id,
      'htmlUrl': instance.htmlUrl,
      'cloneUrl': instance.cloneUrl,
      'sshUrl': instance.sshUrl,
      'owner': instance.owner,
      'defaultBranch': instance.defaultBranch,
      'language': instance.language,
      'stargazersCount': instance.stargazersCount,
      'forksCount': instance.forksCount,
      'openIssuesCount': instance.openIssuesCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'pushedAt': instance.pushedAt,
    };
