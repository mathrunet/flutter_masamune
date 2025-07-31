// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubProjectModel _$GithubProjectModelFromJson(Map<String, dynamic> json) =>
    _GithubProjectModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      previousName: json['previousName'] as String?,
      projectUrl: json['projectUrl'] == null
          ? null
          : ModelUri.fromJson(json['projectUrl'] as Map<String, dynamic>),
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubProjectModelToJson(_GithubProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'previousName': instance.previousName,
      'projectUrl': instance.projectUrl,
      'url': instance.url,
    };
