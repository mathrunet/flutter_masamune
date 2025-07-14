// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubUserModel _$GithubUserModelFromJson(Map<String, dynamic> json) =>
    _GithubUserModel(
      id: (json['id'] as num?)?.toInt(),
      login: json['login'] as String?,
      name: json['name'] as String?,
      company: json['company'] as String?,
      blog: json['blog'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      xUsername: json['xUsername'] as String?,
      nodeId: json['nodeId'] as String?,
      type: json['type'] as String?,
      siteAdmin: json['siteAdmin'] as bool? ?? false,
      hirable: json['hirable'] as bool? ?? false,
      publicReposCount: (json['publicReposCount'] as num?)?.toInt() ?? 0,
      publicGistsCount: (json['publicGistsCount'] as num?)?.toInt() ?? 0,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl'] == null
          ? null
          : ModelImageUri.fromJson(json['avatarUrl'] as Map<String, dynamic>),
      gravatarId: json['gravatarId'] as String?,
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      userUrl: json['userUrl'] == null
          ? null
          : ModelUri.fromJson(json['userUrl'] as Map<String, dynamic>),
      eventsUrl: json['eventsUrl'] == null
          ? null
          : ModelUri.fromJson(json['eventsUrl'] as Map<String, dynamic>),
      followersUrl: json['followersUrl'] == null
          ? null
          : ModelUri.fromJson(json['followersUrl'] as Map<String, dynamic>),
      followingUrl: json['followingUrl'] == null
          ? null
          : ModelUri.fromJson(json['followingUrl'] as Map<String, dynamic>),
      gistsUrl: json['gistsUrl'] == null
          ? null
          : ModelUri.fromJson(json['gistsUrl'] as Map<String, dynamic>),
      organizationsUrl: json['organizationsUrl'] == null
          ? null
          : ModelUri.fromJson(json['organizationsUrl'] as Map<String, dynamic>),
      receivedEventsUrl: json['receivedEventsUrl'] == null
          ? null
          : ModelUri.fromJson(
              json['receivedEventsUrl'] as Map<String, dynamic>),
      reposUrl: json['reposUrl'] == null
          ? null
          : ModelUri.fromJson(json['reposUrl'] as Map<String, dynamic>),
      starredUrl: json['starredUrl'] == null
          ? null
          : ModelUri.fromJson(json['starredUrl'] as Map<String, dynamic>),
      subscriptionsUrl: json['subscriptionsUrl'] == null
          ? null
          : ModelUri.fromJson(json['subscriptionsUrl'] as Map<String, dynamic>),
      starredAt: json['starredAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['starredAt'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubUserModelToJson(_GithubUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'name': instance.name,
      'company': instance.company,
      'blog': instance.blog,
      'bio': instance.bio,
      'location': instance.location,
      'email': instance.email,
      'xUsername': instance.xUsername,
      'nodeId': instance.nodeId,
      'type': instance.type,
      'siteAdmin': instance.siteAdmin,
      'hirable': instance.hirable,
      'publicReposCount': instance.publicReposCount,
      'publicGistsCount': instance.publicGistsCount,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'avatarUrl': instance.avatarUrl,
      'gravatarId': instance.gravatarId,
      'htmlUrl': instance.htmlUrl,
      'userUrl': instance.userUrl,
      'eventsUrl': instance.eventsUrl,
      'followersUrl': instance.followersUrl,
      'followingUrl': instance.followingUrl,
      'gistsUrl': instance.gistsUrl,
      'organizationsUrl': instance.organizationsUrl,
      'receivedEventsUrl': instance.receivedEventsUrl,
      'reposUrl': instance.reposUrl,
      'starredUrl': instance.starredUrl,
      'subscriptionsUrl': instance.subscriptionsUrl,
      'starredAt': instance.starredAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
