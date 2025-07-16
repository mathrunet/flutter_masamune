// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubIssueModel _$GithubIssueModelFromJson(Map<String, dynamic> json) =>
    _GithubIssueModel(
      id: (json['id'] as num?)?.toInt(),
      number: (json['number'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      bodyHtml: json['bodyHtml'] as String?,
      bodyText: json['bodyText'] as String?,
      state: json['state'] as String?,
      stateReason: json['stateReason'] as String?,
      activeLockReason: json['activeLockReason'] as String?,
      authorAssociation: json['authorAssociation'] as String?,
      nodeId: json['nodeId'] as String?,
      draft: json['draft'] as bool? ?? false,
      locked: json['locked'] as bool? ?? false,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      repository: json['repository'] == null
          ? null
          : ModelRefBase<GithubRepositoryModel>.fromJson(
              json['repository'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['user'] as Map<String, dynamic>),
      assignee: json['assignee'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['assignee'] as Map<String, dynamic>),
      assignees: (json['assignees'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : ModelRefBase<GithubUserModel>.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      closedBy: json['closedBy'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['closedBy'] as Map<String, dynamic>),
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => GithubLabelValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GithubLabelValue>[],
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      commentsUrl: json['commentsUrl'] == null
          ? null
          : ModelUri.fromJson(json['commentsUrl'] as Map<String, dynamic>),
      eventsUrl: json['eventsUrl'] == null
          ? null
          : ModelUri.fromJson(json['eventsUrl'] as Map<String, dynamic>),
      labelsUrl: json['labelsUrl'] == null
          ? null
          : ModelUri.fromJson(json['labelsUrl'] as Map<String, dynamic>),
      repositoryUrl: json['repositoryUrl'] == null
          ? null
          : ModelUri.fromJson(json['repositoryUrl'] as Map<String, dynamic>),
      timelineUrl: json['timelineUrl'] == null
          ? null
          : ModelUri.fromJson(json['timelineUrl'] as Map<String, dynamic>),
      reactions: json['reactions'] == null
          ? null
          : GithubReactionValue.fromJson(
              json['reactions'] as Map<String, dynamic>),
      closedAt: json['closedAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['closedAt'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubIssueModelToJson(_GithubIssueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'title': instance.title,
      'body': instance.body,
      'bodyHtml': instance.bodyHtml,
      'bodyText': instance.bodyText,
      'state': instance.state,
      'stateReason': instance.stateReason,
      'activeLockReason': instance.activeLockReason,
      'authorAssociation': instance.authorAssociation,
      'nodeId': instance.nodeId,
      'draft': instance.draft,
      'locked': instance.locked,
      'commentsCount': instance.commentsCount,
      'repository': instance.repository,
      'user': instance.user,
      'assignee': instance.assignee,
      'assignees': instance.assignees,
      'closedBy': instance.closedBy,
      'labels': instance.labels,
      'url': instance.url,
      'htmlUrl': instance.htmlUrl,
      'commentsUrl': instance.commentsUrl,
      'eventsUrl': instance.eventsUrl,
      'labelsUrl': instance.labelsUrl,
      'repositoryUrl': instance.repositoryUrl,
      'timelineUrl': instance.timelineUrl,
      'reactions': instance.reactions,
      'closedAt': instance.closedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'fromServer': instance.fromServer,
    };
