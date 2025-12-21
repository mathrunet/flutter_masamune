// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowAssetModel _$WorkflowAssetModelFromJson(Map<String, dynamic> json) =>
    _WorkflowAssetModel(
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      source: json['source'] as String?,
      content: json['content'] as String?,
      path: json['path'] as String?,
      mimtType: json['mimtType'] as String?,
      locale: json['locale'] == null
          ? null
          : ModelLocale.fromJson(json['locale'] as Map<String, dynamic>),
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowAssetModelToJson(_WorkflowAssetModel instance) =>
    <String, dynamic>{
      'organization': instance.organization,
      'source': instance.source,
      'content': instance.content,
      'path': instance.path,
      'mimtType': instance.mimtType,
      'locale': instance.locale,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };
