// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowCertificateModel _$WorkflowCertificateModelFromJson(
        Map<String, dynamic> json) =>
    _WorkflowCertificateModel(
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      token: json['token'] as String?,
      scope:
          (json['scope'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      expiredTime: json['expiredTime'] == null
          ? null
          : ModelTimestamp.fromJson(
              json['expiredTime'] as Map<String, dynamic>),
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowCertificateModelToJson(
        _WorkflowCertificateModel instance) =>
    <String, dynamic>{
      'organization': instance.organization,
      'token': instance.token,
      'scope': instance.scope,
      'expiredTime': instance.expiredTime,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };
