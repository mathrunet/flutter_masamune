// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubOrganizationModel _$GithubOrganizationModelFromJson(
        Map<String, dynamic> json) =>
    _GithubOrganizationModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      login: json['login'] as String?,
      company: json['company'] as String?,
      blog: json['blog'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      publicReposCount: (json['publicReposCount'] as num?)?.toInt() ?? 0,
      publicGistsCount: (json['publicGistsCount'] as num?)?.toInt() ?? 0,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      avatarUrl: json['avatarUrl'] == null
          ? null
          : ModelImageUri.fromJson(json['avatarUrl'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubOrganizationModelToJson(
        _GithubOrganizationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'login': instance.login,
      'company': instance.company,
      'blog': instance.blog,
      'location': instance.location,
      'email': instance.email,
      'publicReposCount': instance.publicReposCount,
      'publicGistsCount': instance.publicGistsCount,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'htmlUrl': instance.htmlUrl,
      'avatarUrl': instance.avatarUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
