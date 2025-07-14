// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubRepositoryModel _$GithubRepositoryModelFromJson(
        Map<String, dynamic> json) =>
    _GithubRepositoryModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fullName: json['fullName'] as String?,
      owner: json['owner'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['owner'] as Map<String, dynamic>),
      organization: json['organization'] == null
          ? null
          : ModelRefBase<GithubOrganizationModel>.fromJson(
              json['organization'] as Map<String, dynamic>),
      language: json['language'] == null
          ? null
          : ModelLocale.fromJson(json['language'] as Map<String, dynamic>),
      license: json['license'] == null
          ? null
          : GithubLicenseValue.fromJson(
              json['license'] as Map<String, dynamic>),
      permissions: json['permissions'] == null
          ? null
          : GithubRepositoryPermissionValue.fromJson(
              json['permissions'] as Map<String, dynamic>),
      isPrivate: json['isPrivate'] as bool? ?? false,
      isFork: json['isFork'] as bool? ?? false,
      isTemplate: json['isTemplate'] as bool? ?? false,
      description: json['description'] as String?,
      masterBranch: json['masterBranch'] as String?,
      mergeCommitMessage: json['mergeCommitMessage'] as String?,
      mergeCommitTitle: json['mergeCommitTitle'] as String?,
      squashMergeCommitMessage: json['squashMergeCommitMessage'] as String?,
      squashMergeCommitTitle: json['squashMergeCommitTitle'] as String?,
      nodeId: json['nodeId'] as String?,
      tempCloneToken: json['tempCloneToken'] as String?,
      visibility: json['visibility'] as String?,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      archived: json['archived'] as bool? ?? false,
      disabled: json['disabled'] as bool? ?? false,
      hasIssues: json['hasIssues'] as bool? ?? false,
      hasWiki: json['hasWiki'] as bool? ?? false,
      hasDownloads: json['hasDownloads'] as bool? ?? false,
      hasPages: json['hasPages'] as bool? ?? false,
      hasDiscussions: json['hasDiscussions'] as bool? ?? false,
      hasProjects: json['hasProjects'] as bool? ?? false,
      allowAutoMerge: json['allowAutoMerge'] as bool? ?? false,
      allowForking: json['allowForking'] as bool? ?? false,
      allowMergeCommit: json['allowMergeCommit'] as bool? ?? false,
      allowRebaseMerge: json['allowRebaseMerge'] as bool? ?? false,
      allowSquashMerge: json['allowSquashMerge'] as bool? ?? false,
      allowUpdateBranch: json['allowUpdateBranch'] as bool? ?? false,
      anonymousAccessEnabled: json['anonymousAccessEnabled'] as bool? ?? false,
      deleteBranchOnMerge: json['deleteBranchOnMerge'] as bool? ?? false,
      webCommitSignoffRequired:
          json['webCommitSignoffRequired'] as bool? ?? false,
      size: (json['size'] as num?)?.toInt() ?? 0,
      stargazersCount: (json['stargazersCount'] as num?)?.toInt() ?? 0,
      watchersCount: (json['watchersCount'] as num?)?.toInt() ?? 0,
      forksCount: (json['forksCount'] as num?)?.toInt() ?? 0,
      openIssuesCount: (json['openIssuesCount'] as num?)?.toInt() ?? 0,
      subscribersCount: (json['subscribersCount'] as num?)?.toInt() ?? 0,
      networkCount: (json['networkCount'] as num?)?.toInt() ?? 0,
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      cloneUrl: json['cloneUrl'] == null
          ? null
          : ModelUri.fromJson(json['cloneUrl'] as Map<String, dynamic>),
      sshUrl: json['sshUrl'] == null
          ? null
          : ModelUri.fromJson(json['sshUrl'] as Map<String, dynamic>),
      svnUrl: json['svnUrl'] == null
          ? null
          : ModelUri.fromJson(json['svnUrl'] as Map<String, dynamic>),
      gitUrl: json['gitUrl'] == null
          ? null
          : ModelUri.fromJson(json['gitUrl'] as Map<String, dynamic>),
      homepageUrl: json['homepageUrl'] == null
          ? null
          : ModelUri.fromJson(json['homepageUrl'] as Map<String, dynamic>),
      archiveUrl: json['archiveUrl'] == null
          ? null
          : ModelUri.fromJson(json['archiveUrl'] as Map<String, dynamic>),
      assigneesUrl: json['assigneesUrl'] == null
          ? null
          : ModelUri.fromJson(json['assigneesUrl'] as Map<String, dynamic>),
      blobsUrl: json['blobsUrl'] == null
          ? null
          : ModelUri.fromJson(json['blobsUrl'] as Map<String, dynamic>),
      branchesUrl: json['branchesUrl'] == null
          ? null
          : ModelUri.fromJson(json['branchesUrl'] as Map<String, dynamic>),
      collaboratorsUrl: json['collaboratorsUrl'] == null
          ? null
          : ModelUri.fromJson(json['collaboratorsUrl'] as Map<String, dynamic>),
      commentsUrl: json['commentsUrl'] == null
          ? null
          : ModelUri.fromJson(json['commentsUrl'] as Map<String, dynamic>),
      commitsUrl: json['commitsUrl'] == null
          ? null
          : ModelUri.fromJson(json['commitsUrl'] as Map<String, dynamic>),
      compareUrl: json['compareUrl'] == null
          ? null
          : ModelUri.fromJson(json['compareUrl'] as Map<String, dynamic>),
      contentsUrl: json['contentsUrl'] == null
          ? null
          : ModelUri.fromJson(json['contentsUrl'] as Map<String, dynamic>),
      contributorsUrl: json['contributorsUrl'] == null
          ? null
          : ModelUri.fromJson(json['contributorsUrl'] as Map<String, dynamic>),
      deploymentsUrl: json['deploymentsUrl'] == null
          ? null
          : ModelUri.fromJson(json['deploymentsUrl'] as Map<String, dynamic>),
      downloadsUrl: json['downloadsUrl'] == null
          ? null
          : ModelUri.fromJson(json['downloadsUrl'] as Map<String, dynamic>),
      eventsUrl: json['eventsUrl'] == null
          ? null
          : ModelUri.fromJson(json['eventsUrl'] as Map<String, dynamic>),
      forksUrl: json['forksUrl'] == null
          ? null
          : ModelUri.fromJson(json['forksUrl'] as Map<String, dynamic>),
      gitCommitsUrl: json['gitCommitsUrl'] == null
          ? null
          : ModelUri.fromJson(json['gitCommitsUrl'] as Map<String, dynamic>),
      gitRefsUrl: json['gitRefsUrl'] == null
          ? null
          : ModelUri.fromJson(json['gitRefsUrl'] as Map<String, dynamic>),
      gitTagsUrl: json['gitTagsUrl'] == null
          ? null
          : ModelUri.fromJson(json['gitTagsUrl'] as Map<String, dynamic>),
      hooksUrl: json['hooksUrl'] == null
          ? null
          : ModelUri.fromJson(json['hooksUrl'] as Map<String, dynamic>),
      issueCommentUrl: json['issueCommentUrl'] == null
          ? null
          : ModelUri.fromJson(json['issueCommentUrl'] as Map<String, dynamic>),
      issueEventsUrl: json['issueEventsUrl'] == null
          ? null
          : ModelUri.fromJson(json['issueEventsUrl'] as Map<String, dynamic>),
      issuesUrl: json['issuesUrl'] == null
          ? null
          : ModelUri.fromJson(json['issuesUrl'] as Map<String, dynamic>),
      keysUrl: json['keysUrl'] == null
          ? null
          : ModelUri.fromJson(json['keysUrl'] as Map<String, dynamic>),
      labelsUrl: json['labelsUrl'] == null
          ? null
          : ModelUri.fromJson(json['labelsUrl'] as Map<String, dynamic>),
      languagesUrl: json['languagesUrl'] == null
          ? null
          : ModelUri.fromJson(json['languagesUrl'] as Map<String, dynamic>),
      mergesUrl: json['mergesUrl'] == null
          ? null
          : ModelUri.fromJson(json['mergesUrl'] as Map<String, dynamic>),
      milestonesUrl: json['milestonesUrl'] == null
          ? null
          : ModelUri.fromJson(json['milestonesUrl'] as Map<String, dynamic>),
      mirrorUrl: json['mirrorUrl'] == null
          ? null
          : ModelUri.fromJson(json['mirrorUrl'] as Map<String, dynamic>),
      notificationsUrl: json['notificationsUrl'] == null
          ? null
          : ModelUri.fromJson(json['notificationsUrl'] as Map<String, dynamic>),
      pullsUrl: json['pullsUrl'] == null
          ? null
          : ModelUri.fromJson(json['pullsUrl'] as Map<String, dynamic>),
      releasesUrl: json['releasesUrl'] == null
          ? null
          : ModelUri.fromJson(json['releasesUrl'] as Map<String, dynamic>),
      stargazersUrl: json['stargazersUrl'] == null
          ? null
          : ModelUri.fromJson(json['stargazersUrl'] as Map<String, dynamic>),
      statusesUrl: json['statusesUrl'] == null
          ? null
          : ModelUri.fromJson(json['statusesUrl'] as Map<String, dynamic>),
      subscribersUrl: json['subscribersUrl'] == null
          ? null
          : ModelUri.fromJson(json['subscribersUrl'] as Map<String, dynamic>),
      subscriptionUrl: json['subscriptionUrl'] == null
          ? null
          : ModelUri.fromJson(json['subscriptionUrl'] as Map<String, dynamic>),
      tagsUrl: json['tagsUrl'] == null
          ? null
          : ModelUri.fromJson(json['tagsUrl'] as Map<String, dynamic>),
      teamsUrl: json['teamsUrl'] == null
          ? null
          : ModelUri.fromJson(json['teamsUrl'] as Map<String, dynamic>),
      treesUrl: json['treesUrl'] == null
          ? null
          : ModelUri.fromJson(json['treesUrl'] as Map<String, dynamic>),
      templateRepository: json['templateRepository'] == null
          ? null
          : ModelRefBase<GithubRepositoryModel>.fromJson(
              json['templateRepository'] as Map<String, dynamic>),
      starredAt: json['starredAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['starredAt'] as Map<String, dynamic>),
      pushedAt: json['pushedAt'] == null
          ? null
          : ModelTimestamp.fromJson(json['pushedAt'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubRepositoryModelToJson(
        _GithubRepositoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fullName': instance.fullName,
      'owner': instance.owner,
      'organization': instance.organization,
      'language': instance.language,
      'license': instance.license,
      'permissions': instance.permissions,
      'isPrivate': instance.isPrivate,
      'isFork': instance.isFork,
      'isTemplate': instance.isTemplate,
      'description': instance.description,
      'masterBranch': instance.masterBranch,
      'mergeCommitMessage': instance.mergeCommitMessage,
      'mergeCommitTitle': instance.mergeCommitTitle,
      'squashMergeCommitMessage': instance.squashMergeCommitMessage,
      'squashMergeCommitTitle': instance.squashMergeCommitTitle,
      'nodeId': instance.nodeId,
      'tempCloneToken': instance.tempCloneToken,
      'visibility': instance.visibility,
      'topics': instance.topics,
      'archived': instance.archived,
      'disabled': instance.disabled,
      'hasIssues': instance.hasIssues,
      'hasWiki': instance.hasWiki,
      'hasDownloads': instance.hasDownloads,
      'hasPages': instance.hasPages,
      'hasDiscussions': instance.hasDiscussions,
      'hasProjects': instance.hasProjects,
      'allowAutoMerge': instance.allowAutoMerge,
      'allowForking': instance.allowForking,
      'allowMergeCommit': instance.allowMergeCommit,
      'allowRebaseMerge': instance.allowRebaseMerge,
      'allowSquashMerge': instance.allowSquashMerge,
      'allowUpdateBranch': instance.allowUpdateBranch,
      'anonymousAccessEnabled': instance.anonymousAccessEnabled,
      'deleteBranchOnMerge': instance.deleteBranchOnMerge,
      'webCommitSignoffRequired': instance.webCommitSignoffRequired,
      'size': instance.size,
      'stargazersCount': instance.stargazersCount,
      'watchersCount': instance.watchersCount,
      'forksCount': instance.forksCount,
      'openIssuesCount': instance.openIssuesCount,
      'subscribersCount': instance.subscribersCount,
      'networkCount': instance.networkCount,
      'htmlUrl': instance.htmlUrl,
      'cloneUrl': instance.cloneUrl,
      'sshUrl': instance.sshUrl,
      'svnUrl': instance.svnUrl,
      'gitUrl': instance.gitUrl,
      'homepageUrl': instance.homepageUrl,
      'archiveUrl': instance.archiveUrl,
      'assigneesUrl': instance.assigneesUrl,
      'blobsUrl': instance.blobsUrl,
      'branchesUrl': instance.branchesUrl,
      'collaboratorsUrl': instance.collaboratorsUrl,
      'commentsUrl': instance.commentsUrl,
      'commitsUrl': instance.commitsUrl,
      'compareUrl': instance.compareUrl,
      'contentsUrl': instance.contentsUrl,
      'contributorsUrl': instance.contributorsUrl,
      'deploymentsUrl': instance.deploymentsUrl,
      'downloadsUrl': instance.downloadsUrl,
      'eventsUrl': instance.eventsUrl,
      'forksUrl': instance.forksUrl,
      'gitCommitsUrl': instance.gitCommitsUrl,
      'gitRefsUrl': instance.gitRefsUrl,
      'gitTagsUrl': instance.gitTagsUrl,
      'hooksUrl': instance.hooksUrl,
      'issueCommentUrl': instance.issueCommentUrl,
      'issueEventsUrl': instance.issueEventsUrl,
      'issuesUrl': instance.issuesUrl,
      'keysUrl': instance.keysUrl,
      'labelsUrl': instance.labelsUrl,
      'languagesUrl': instance.languagesUrl,
      'mergesUrl': instance.mergesUrl,
      'milestonesUrl': instance.milestonesUrl,
      'mirrorUrl': instance.mirrorUrl,
      'notificationsUrl': instance.notificationsUrl,
      'pullsUrl': instance.pullsUrl,
      'releasesUrl': instance.releasesUrl,
      'stargazersUrl': instance.stargazersUrl,
      'statusesUrl': instance.statusesUrl,
      'subscribersUrl': instance.subscribersUrl,
      'subscriptionUrl': instance.subscriptionUrl,
      'tagsUrl': instance.tagsUrl,
      'teamsUrl': instance.teamsUrl,
      'treesUrl': instance.treesUrl,
      'templateRepository': instance.templateRepository,
      'starredAt': instance.starredAt,
      'pushedAt': instance.pushedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
