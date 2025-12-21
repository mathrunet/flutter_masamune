// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowCampaignModel _$WorkflowCampaignModelFromJson(
        Map<String, dynamic> json) =>
    _WorkflowCampaignModel(
      organization: json['organization'] == null
          ? null
          : ModelRefBase<WorkflowOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      limit: (json['limit'] as num?)?.toDouble() ?? 0,
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

Map<String, dynamic> _$WorkflowCampaignModelToJson(
        _WorkflowCampaignModel instance) =>
    <String, dynamic>{
      'organization': instance.organization,
      'limit': instance.limit,
      'expiredTime': instance.expiredTime,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
    };
