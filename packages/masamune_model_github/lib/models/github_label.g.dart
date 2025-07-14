// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_label.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubLabelValue _$GithubLabelValueFromJson(Map<String, dynamic> json) =>
    _GithubLabelValue(
      name: json['name'] as String?,
      color: json['color'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GithubLabelValueToJson(_GithubLabelValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'description': instance.description,
    };
