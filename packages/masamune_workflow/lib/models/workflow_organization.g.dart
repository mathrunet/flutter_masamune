// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowOrganizationModel _$WorkflowOrganizationModelFromJson(
        Map<String, dynamic> json) =>
    _WorkflowOrganizationModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      ownerId: json['ownerId'] as String?,
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowOrganizationModelToJson(
        _WorkflowOrganizationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'ownerId': instance.ownerId,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };
