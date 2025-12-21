// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowPageModel _$WorkflowPageModelFromJson(Map<String, dynamic> json) =>
    _WorkflowPageModel(
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : ModelRefBase<WorkflowProjectModel>.fromJson(
              json['project'] as Map<String, dynamic>),
      content: json['content'] as String?,
      path: json['path'] as String?,
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

Map<String, dynamic> _$WorkflowPageModelToJson(_WorkflowPageModel instance) =>
    <String, dynamic>{
      'organization': instance.organization,
      'project': instance.project,
      'content': instance.content,
      'path': instance.path,
      'locale': instance.locale,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };
