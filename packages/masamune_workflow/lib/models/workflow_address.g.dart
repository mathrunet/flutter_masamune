// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowAddressModel _$WorkflowAddressModelFromJson(
        Map<String, dynamic> json) =>
    _WorkflowAddressModel(
      appCount: (json['appCount'] as num?)?.toInt() ?? 0,
      appNames: (json['appNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      appSummaries: (json['appSummaries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      collectedTime: json['collectedTime'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(
              json['collectedTime'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(
              json['updatedTime'] as Map<String, dynamic>),
      developerId: json['developerId'] as String?,
      developerName: json['developerName'] as String?,
      email: json['email'] as String?,
      privacyPolicyUrl: json['privacyPolicyUrl'] as String?,
      source: json['source'] as String?,
      contactPageUrls: (json['contactPageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WorkflowAddressModelToJson(
        _WorkflowAddressModel instance) =>
    <String, dynamic>{
      'appCount': instance.appCount,
      'appNames': instance.appNames,
      'appSummaries': instance.appSummaries,
      'collectedTime': instance.collectedTime,
      'updatedTime': instance.updatedTime,
      'developerId': instance.developerId,
      'developerName': instance.developerName,
      'email': instance.email,
      'privacyPolicyUrl': instance.privacyPolicyUrl,
      'source': instance.source,
      'contactPageUrls': instance.contactPageUrls,
    };
