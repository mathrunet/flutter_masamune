// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowProjectModel _$WorkflowProjectModelFromJson(
        Map<String, dynamic> json) =>
    _WorkflowProjectModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      concept: json['concept'] as String?,
      goal: json['goal'] as String?,
      target: json['target'] as String?,
      locale: json['locale'] == null
          ? null
          : ModelLocale.fromJson(json['locale'] as Map<String, dynamic>),
      kpi: json['kpi'] as Map<String, dynamic>?,
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      icon: json['icon'] as String?,
      googleAccessToken: json['googleAccessToken'] as String?,
      googleRefreshToken: json['googleRefreshToken'] as String?,
      googleServiceAccount: json['googleServiceAccount'] as String?,
      githubPersonalAccessToken: json['githubPersonalAccessToken'] as String?,
      appstoreIssuerId: json['appstoreIssuerId'] as String?,
      appstoreAuthKeyId: json['appstoreAuthKeyId'] as String?,
      appstoreAuthKey: json['appstoreAuthKey'] as String?,
      createdTime: json['createdTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['createdTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkflowProjectModelToJson(
        _WorkflowProjectModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'concept': instance.concept,
      'goal': instance.goal,
      'target': instance.target,
      'locale': instance.locale,
      'kpi': instance.kpi,
      'organization': instance.organization,
      'icon': instance.icon,
      'googleAccessToken': instance.googleAccessToken,
      'googleRefreshToken': instance.googleRefreshToken,
      'googleServiceAccount': instance.googleServiceAccount,
      'githubPersonalAccessToken': instance.githubPersonalAccessToken,
      'appstoreIssuerId': instance.appstoreIssuerId,
      'appstoreAuthKeyId': instance.appstoreAuthKeyId,
      'appstoreAuthKey': instance.appstoreAuthKey,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };
