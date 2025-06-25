// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PullRequestModel _$PullRequestModelFromJson(Map<String, dynamic> json) =>
    _PullRequestModel(
      title: json['title'] as String? ?? "",
      body: json['body'] as String? ?? "",
      state: json['state'] as String? ?? "open",
      id: (json['id'] as num?)?.toInt(),
      number: (json['number'] as num?)?.toInt(),
      user: json['user'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      head: json['head'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      base: json['base'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      mergedAt: json['mergedAt'] as String?,
    );

Map<String, dynamic> _$PullRequestModelToJson(_PullRequestModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'state': instance.state,
      'id': instance.id,
      'number': instance.number,
      'user': instance.user,
      'head': instance.head,
      'base': instance.base,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'mergedAt': instance.mergedAt,
    };
