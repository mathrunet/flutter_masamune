// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_license.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubLicenseValue _$GithubLicenseValueFromJson(Map<String, dynamic> json) =>
    _GithubLicenseValue(
      key: json['key'] as String?,
      name: json['name'] as String?,
      spdxId: json['spdxId'] as String?,
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      nodeId: json['nodeId'] as String?,
    );

Map<String, dynamic> _$GithubLicenseValueToJson(_GithubLicenseValue instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'spdxId': instance.spdxId,
      'url': instance.url,
      'nodeId': instance.nodeId,
    };
