// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_organization_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowOrganizationMemberModel _$WorkflowOrganizationMemberModelFromJson(
        Map<String, dynamic> json) =>
    _WorkflowOrganizationMemberModel(
      role: $enumDecode(_$WorkflowRoleEnumMap, json['role']),
      userId: json['userId'] as String?,
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowOrganizationMemberModelToJson(
        _WorkflowOrganizationMemberModel instance) =>
    <String, dynamic>{
      'role': _$WorkflowRoleEnumMap[instance.role]!,
      'userId': instance.userId,
      'organization': instance.organization,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };

const _$WorkflowRoleEnumMap = {
  WorkflowRole.admin: 'admin',
  WorkflowRole.editor: 'editor',
  WorkflowRole.viewer: 'viewer',
};
