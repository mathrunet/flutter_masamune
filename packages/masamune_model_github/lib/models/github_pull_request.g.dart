// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_pull_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubPullRequestModel _$GithubPullRequestModelFromJson(
        Map<String, dynamic> json) =>
    _GithubPullRequestModel(
      id: (json['id'] as num?)?.toInt(),
      nodeId: json['nodeId'] as String?,
      number: (json['number'] as num?)?.toInt(),
      state: json['state'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      mergeCommitSha: json['mergeCommitSha'] as String?,
      mergeableState: json['mergeableState'] as String?,
      authorAssociation: json['authorAssociation'] as String?,
      draft: json['draft'] as bool? ?? false,
      merged: json['merged'] as bool? ?? false,
      mergeable: json['mergeable'] as bool? ?? false,
      rebaseable: json['rebaseable'] as bool? ?? false,
      maintainerCanModify: json['maintainerCanModify'] as bool? ?? false,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      commitsCount: (json['commitsCount'] as num?)?.toInt() ?? 0,
      additionsCount: (json['additionsCount'] as num?)?.toInt() ?? 0,
      deletionsCount: (json['deletionsCount'] as num?)?.toInt() ?? 0,
      changedFilesCount: (json['changedFilesCount'] as num?)?.toInt() ?? 0,
      reviewCommentCount: (json['reviewCommentCount'] as num?)?.toInt() ?? 0,
      repository: json['repository'] == null
          ? null
          : ModelRefBase<GithubRepositoryModel>.fromJson(
              json['repository'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['user'] as Map<String, dynamic>),
      mergedBy: json['mergedBy'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['mergedBy'] as Map<String, dynamic>),
      requestedReviewers: (json['requestedReviewers'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : ModelRefBase<GithubUserModel>.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => GithubLabelValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GithubLabelValue>[],
      head: json['head'] == null
          ? null
          : GithubPullRequestHeadValue.fromJson(
              json['head'] as Map<String, dynamic>),
      base: json['base'] == null
          ? null
          : GithubPullRequestHeadValue.fromJson(
              json['base'] as Map<String, dynamic>),
      milestone: json['milestone'] == null
          ? null
          : GithubMilestoneValue.fromJson(
              json['milestone'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      diffUrl: json['diffUrl'] == null
          ? null
          : ModelUri.fromJson(json['diffUrl'] as Map<String, dynamic>),
      patchUrl: json['patchUrl'] == null
          ? null
          : ModelUri.fromJson(json['patchUrl'] as Map<String, dynamic>),
      closedAt: json['closedAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['closedAt'] as Map<String, dynamic>),
      mergedAt: json['mergedAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['mergedAt'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubPullRequestModelToJson(
        _GithubPullRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nodeId': instance.nodeId,
      'number': instance.number,
      'state': instance.state,
      'title': instance.title,
      'body': instance.body,
      'mergeCommitSha': instance.mergeCommitSha,
      'mergeableState': instance.mergeableState,
      'authorAssociation': instance.authorAssociation,
      'draft': instance.draft,
      'merged': instance.merged,
      'mergeable': instance.mergeable,
      'rebaseable': instance.rebaseable,
      'maintainerCanModify': instance.maintainerCanModify,
      'commentsCount': instance.commentsCount,
      'commitsCount': instance.commitsCount,
      'additionsCount': instance.additionsCount,
      'deletionsCount': instance.deletionsCount,
      'changedFilesCount': instance.changedFilesCount,
      'reviewCommentCount': instance.reviewCommentCount,
      'repository': instance.repository,
      'user': instance.user,
      'mergedBy': instance.mergedBy,
      'requestedReviewers': instance.requestedReviewers,
      'labels': instance.labels,
      'head': instance.head,
      'base': instance.base,
      'milestone': instance.milestone,
      'htmlUrl': instance.htmlUrl,
      'diffUrl': instance.diffUrl,
      'patchUrl': instance.patchUrl,
      'closedAt': instance.closedAt,
      'mergedAt': instance.mergedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
