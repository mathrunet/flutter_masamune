// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_pull_request_timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubPullRequestTimelineModel _$GithubPullRequestTimelineModelFromJson(
        Map<String, dynamic> json) =>
    _GithubPullRequestTimelineModel(
      id: (json['id'] as num?)?.toInt(),
      body: json['body'] as String?,
      previousBody: json['previousBody'] as String?,
      diffHunk: json['diffHunk'] as String?,
      path: json['path'] as String?,
      position: (json['position'] as num?)?.toInt(),
      originalPosition: (json['originalPosition'] as num?)?.toInt(),
      commitId: json['commitId'] as String?,
      originalCommitId: json['originalCommitId'] as String?,
      sha: json['sha'] as String?,
      state: json['state'] as String?,
      reviewId: (json['reviewId'] as num?)?.toInt(),
      event: $enumDecodeNullable(_$GithubTimelineEventEnumMap, json['event']) ??
          GithubTimelineEvent.unknown,
      user: json['user'] == null
          ? null
          : GithubUserModel.fromJson(json['user'] as Map<String, dynamic>),
      from: json['from'] == null
          ? null
          : GithubUserModel.fromJson(json['from'] as Map<String, dynamic>),
      to: json['to'] == null
          ? null
          : GithubUserModel.fromJson(json['to'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : GithubProjectModel.fromJson(
              json['project'] as Map<String, dynamic>),
      milestone: json['milestone'] == null
          ? null
          : GithubMilestoneValue.fromJson(
              json['milestone'] as Map<String, dynamic>),
      reaction: json['reaction'] == null
          ? null
          : GithubReactionValue.fromJson(
              json['reaction'] as Map<String, dynamic>),
      issue: json['issue'] == null
          ? null
          : GithubIssueModel.fromJson(json['issue'] as Map<String, dynamic>),
      pullRequest: json['pullRequest'] == null
          ? null
          : GithubPullRequestModel.fromJson(
              json['pullRequest'] as Map<String, dynamic>),
      label: json['label'] == null
          ? null
          : GithubLabelValue.fromJson(json['label'] as Map<String, dynamic>),
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
      pullRequestUrl: json['pullRequestUrl'] == null
          ? null
          : ModelUri.fromJson(json['pullRequestUrl'] as Map<String, dynamic>),
      commitUrl: json['commitUrl'] == null
          ? null
          : ModelUri.fromJson(json['commitUrl'] as Map<String, dynamic>),
      links: json['links'] == null
          ? null
          : ModelUri.fromJson(json['links'] as Map<String, dynamic>),
      issueUrl: json['issueUrl'] == null
          ? null
          : ModelUri.fromJson(json['issueUrl'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubPullRequestTimelineModelToJson(
        _GithubPullRequestTimelineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'previousBody': instance.previousBody,
      'diffHunk': instance.diffHunk,
      'path': instance.path,
      'position': instance.position,
      'originalPosition': instance.originalPosition,
      'commitId': instance.commitId,
      'originalCommitId': instance.originalCommitId,
      'sha': instance.sha,
      'state': instance.state,
      'reviewId': instance.reviewId,
      'event': _$GithubTimelineEventEnumMap[instance.event]!,
      'user': instance.user?.toJson(),
      'from': instance.from?.toJson(),
      'to': instance.to?.toJson(),
      'project': instance.project?.toJson(),
      'milestone': instance.milestone?.toJson(),
      'reaction': instance.reaction?.toJson(),
      'issue': instance.issue?.toJson(),
      'pullRequest': instance.pullRequest?.toJson(),
      'label': instance.label?.toJson(),
      'url': instance.url?.toJson(),
      'pullRequestUrl': instance.pullRequestUrl?.toJson(),
      'commitUrl': instance.commitUrl?.toJson(),
      'links': instance.links?.toJson(),
      'issueUrl': instance.issueUrl?.toJson(),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'fromServer': instance.fromServer,
    };

const _$GithubTimelineEventEnumMap = {
  GithubTimelineEvent.addedToProject: 'addedToProject',
  GithubTimelineEvent.assigned: 'assigned',
  GithubTimelineEvent.commented: 'commented',
  GithubTimelineEvent.committed: 'committed',
  GithubTimelineEvent.crossReferenced: 'crossReferenced',
  GithubTimelineEvent.demilestoned: 'demilestoned',
  GithubTimelineEvent.labeled: 'labeled',
  GithubTimelineEvent.locked: 'locked',
  GithubTimelineEvent.milestoned: 'milestoned',
  GithubTimelineEvent.movedColumnsAcrossProjects: 'movedColumnsAcrossProjects',
  GithubTimelineEvent.removedFromProject: 'removedFromProject',
  GithubTimelineEvent.renamed: 'renamed',
  GithubTimelineEvent.reviewDismissed: 'reviewDismissed',
  GithubTimelineEvent.reviewRequested: 'reviewRequested',
  GithubTimelineEvent.reviewRequestRemoved: 'reviewRequestRemoved',
  GithubTimelineEvent.reviewed: 'reviewed',
  GithubTimelineEvent.unassigned: 'unassigned',
  GithubTimelineEvent.unlabeled: 'unlabeled',
  GithubTimelineEvent.unknown: 'unknown',
};
