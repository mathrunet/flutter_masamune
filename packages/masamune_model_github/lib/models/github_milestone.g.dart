// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubMilestoneValue _$GithubMilestoneValueFromJson(
        Map<String, dynamic> json) =>
    _GithubMilestoneValue(
      id: (json['id'] as num?)?.toInt(),
      number: (json['number'] as num?)?.toInt(),
      state: json['state'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      nodeId: json['nodeId'] as String?,
      creator: json['creator'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['creator'] as Map<String, dynamic>),
      openIssuesCount: (json['openIssuesCount'] as num?)?.toInt() ?? 0,
      closedIssuesCount: (json['closedIssuesCount'] as num?)?.toInt() ?? 0,
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      labelsUrl: json['labelsUrl'] == null
          ? null
          : ModelUri.fromJson(json['labelsUrl'] as Map<String, dynamic>),
      dueOn: json['dueOn'] == null
          ? null
          : ModelTimestamp.fromJson(json['dueOn'] as Map<String, dynamic>),
      closedAt: json['closedAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['closedAt'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubMilestoneValueToJson(
        _GithubMilestoneValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'state': instance.state,
      'title': instance.title,
      'description': instance.description,
      'nodeId': instance.nodeId,
      'creator': instance.creator,
      'openIssuesCount': instance.openIssuesCount,
      'closedIssuesCount': instance.closedIssuesCount,
      'url': instance.url,
      'htmlUrl': instance.htmlUrl,
      'labelsUrl': instance.labelsUrl,
      'dueOn': instance.dueOn,
      'closedAt': instance.closedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
