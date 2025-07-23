// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubRepositoryModel {
  int? get id;
  @searchParam
  String? get name;
  @searchParam
  String? get fullName;
  @refParam
  GithubUserModelRef get owner;
  @refParam
  GithubOrganizationModelRef get organization;
  @searchParam
  String? get language;
  @jsonParam
  GithubLicenseValue? get license;
  @jsonParam
  GithubRepositoryPermissionValue? get permissions;
  bool get isPrivate;
  bool get isFork;
  bool get isTemplate;
  @searchParam
  String? get description;
  String? get masterBranch;
  String? get mergeCommitMessage;
  String? get mergeCommitTitle;
  String? get squashMergeCommitMessage;
  String? get squashMergeCommitTitle;
  String? get nodeId;
  String? get tempCloneToken;
  String? get visibility;
  List<String> get topics;
  bool get archived;
  bool get disabled;
  bool get hasIssues;
  bool get hasWiki;
  bool get hasDownloads;
  bool get hasPages;
  bool get hasDiscussions;
  bool get hasProjects;
  bool get allowAutoMerge;
  bool get allowForking;
  bool get allowMergeCommit;
  bool get allowRebaseMerge;
  bool get allowSquashMerge;
  bool get allowUpdateBranch;
  bool get anonymousAccessEnabled;
  bool get deleteBranchOnMerge;
  bool get webCommitSignoffRequired;
  int get size;
  int get stargazersCount;
  int get watchersCount;
  int get forksCount;
  int get openIssuesCount;
  int get subscribersCount;
  int get networkCount;
  ModelUri? get htmlUrl;
  ModelUri? get cloneUrl;
  ModelUri? get sshUrl;
  ModelUri? get svnUrl;
  ModelUri? get gitUrl;
  ModelUri? get homepageUrl;
  ModelUri? get archiveUrl;
  ModelUri? get assigneesUrl;
  ModelUri? get blobsUrl;
  ModelUri? get branchesUrl;
  ModelUri? get collaboratorsUrl;
  ModelUri? get commentsUrl;
  ModelUri? get commitsUrl;
  ModelUri? get compareUrl;
  ModelUri? get contentsUrl;
  ModelUri? get contributorsUrl;
  ModelUri? get deploymentsUrl;
  ModelUri? get downloadsUrl;
  ModelUri? get eventsUrl;
  ModelUri? get forksUrl;
  ModelUri? get gitCommitsUrl;
  ModelUri? get gitRefsUrl;
  ModelUri? get gitTagsUrl;
  ModelUri? get hooksUrl;
  ModelUri? get issueCommentUrl;
  ModelUri? get issueEventsUrl;
  ModelUri? get issuesUrl;
  ModelUri? get keysUrl;
  ModelUri? get labelsUrl;
  ModelUri? get languagesUrl;
  ModelUri? get mergesUrl;
  ModelUri? get milestonesUrl;
  ModelUri? get mirrorUrl;
  ModelUri? get notificationsUrl;
  ModelUri? get pullsUrl;
  ModelUri? get releasesUrl;
  ModelUri? get stargazersUrl;
  ModelUri? get statusesUrl;
  ModelUri? get subscribersUrl;
  ModelUri? get subscriptionUrl;
  ModelUri? get tagsUrl;
  ModelUri? get teamsUrl;
  ModelUri? get treesUrl;
  @refParam
  GithubRepositoryModelRef? get templateRepository;
  ModelTimestamp? get starredAt;
  ModelTimestamp? get pushedAt;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;
  bool get fromServer;

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubRepositoryModelCopyWith<GithubRepositoryModel> get copyWith =>
      _$GithubRepositoryModelCopyWithImpl<GithubRepositoryModel>(
          this as GithubRepositoryModel, _$identity);

  /// Serializes this GithubRepositoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubRepositoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.license, license) || other.license == license) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.isFork, isFork) || other.isFork == isFork) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.masterBranch, masterBranch) ||
                other.masterBranch == masterBranch) &&
            (identical(other.mergeCommitMessage, mergeCommitMessage) ||
                other.mergeCommitMessage == mergeCommitMessage) &&
            (identical(other.mergeCommitTitle, mergeCommitTitle) ||
                other.mergeCommitTitle == mergeCommitTitle) &&
            (identical(other.squashMergeCommitMessage, squashMergeCommitMessage) ||
                other.squashMergeCommitMessage == squashMergeCommitMessage) &&
            (identical(other.squashMergeCommitTitle, squashMergeCommitTitle) ||
                other.squashMergeCommitTitle == squashMergeCommitTitle) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.tempCloneToken, tempCloneToken) ||
                other.tempCloneToken == tempCloneToken) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality().equals(other.topics, topics) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.hasIssues, hasIssues) ||
                other.hasIssues == hasIssues) &&
            (identical(other.hasWiki, hasWiki) || other.hasWiki == hasWiki) &&
            (identical(other.hasDownloads, hasDownloads) ||
                other.hasDownloads == hasDownloads) &&
            (identical(other.hasPages, hasPages) ||
                other.hasPages == hasPages) &&
            (identical(other.hasDiscussions, hasDiscussions) ||
                other.hasDiscussions == hasDiscussions) &&
            (identical(other.hasProjects, hasProjects) ||
                other.hasProjects == hasProjects) &&
            (identical(other.allowAutoMerge, allowAutoMerge) ||
                other.allowAutoMerge == allowAutoMerge) &&
            (identical(other.allowForking, allowForking) ||
                other.allowForking == allowForking) &&
            (identical(other.allowMergeCommit, allowMergeCommit) ||
                other.allowMergeCommit == allowMergeCommit) &&
            (identical(other.allowRebaseMerge, allowRebaseMerge) ||
                other.allowRebaseMerge == allowRebaseMerge) &&
            (identical(other.allowSquashMerge, allowSquashMerge) ||
                other.allowSquashMerge == allowSquashMerge) &&
            (identical(other.allowUpdateBranch, allowUpdateBranch) ||
                other.allowUpdateBranch == allowUpdateBranch) &&
            (identical(other.anonymousAccessEnabled, anonymousAccessEnabled) ||
                other.anonymousAccessEnabled == anonymousAccessEnabled) &&
            (identical(other.deleteBranchOnMerge, deleteBranchOnMerge) ||
                other.deleteBranchOnMerge == deleteBranchOnMerge) &&
            (identical(other.webCommitSignoffRequired, webCommitSignoffRequired) ||
                other.webCommitSignoffRequired == webCommitSignoffRequired) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.stargazersCount, stargazersCount) ||
                other.stargazersCount == stargazersCount) &&
            (identical(other.watchersCount, watchersCount) ||
                other.watchersCount == watchersCount) &&
            (identical(other.forksCount, forksCount) ||
                other.forksCount == forksCount) &&
            (identical(other.openIssuesCount, openIssuesCount) ||
                other.openIssuesCount == openIssuesCount) &&
            (identical(other.subscribersCount, subscribersCount) ||
                other.subscribersCount == subscribersCount) &&
            (identical(other.networkCount, networkCount) || other.networkCount == networkCount) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.cloneUrl, cloneUrl) || other.cloneUrl == cloneUrl) &&
            (identical(other.sshUrl, sshUrl) || other.sshUrl == sshUrl) &&
            (identical(other.svnUrl, svnUrl) || other.svnUrl == svnUrl) &&
            (identical(other.gitUrl, gitUrl) || other.gitUrl == gitUrl) &&
            (identical(other.homepageUrl, homepageUrl) || other.homepageUrl == homepageUrl) &&
            (identical(other.archiveUrl, archiveUrl) || other.archiveUrl == archiveUrl) &&
            (identical(other.assigneesUrl, assigneesUrl) || other.assigneesUrl == assigneesUrl) &&
            (identical(other.blobsUrl, blobsUrl) || other.blobsUrl == blobsUrl) &&
            (identical(other.branchesUrl, branchesUrl) || other.branchesUrl == branchesUrl) &&
            (identical(other.collaboratorsUrl, collaboratorsUrl) || other.collaboratorsUrl == collaboratorsUrl) &&
            (identical(other.commentsUrl, commentsUrl) || other.commentsUrl == commentsUrl) &&
            (identical(other.commitsUrl, commitsUrl) || other.commitsUrl == commitsUrl) &&
            (identical(other.compareUrl, compareUrl) || other.compareUrl == compareUrl) &&
            (identical(other.contentsUrl, contentsUrl) || other.contentsUrl == contentsUrl) &&
            (identical(other.contributorsUrl, contributorsUrl) || other.contributorsUrl == contributorsUrl) &&
            (identical(other.deploymentsUrl, deploymentsUrl) || other.deploymentsUrl == deploymentsUrl) &&
            (identical(other.downloadsUrl, downloadsUrl) || other.downloadsUrl == downloadsUrl) &&
            (identical(other.eventsUrl, eventsUrl) || other.eventsUrl == eventsUrl) &&
            (identical(other.forksUrl, forksUrl) || other.forksUrl == forksUrl) &&
            (identical(other.gitCommitsUrl, gitCommitsUrl) || other.gitCommitsUrl == gitCommitsUrl) &&
            (identical(other.gitRefsUrl, gitRefsUrl) || other.gitRefsUrl == gitRefsUrl) &&
            (identical(other.gitTagsUrl, gitTagsUrl) || other.gitTagsUrl == gitTagsUrl) &&
            (identical(other.hooksUrl, hooksUrl) || other.hooksUrl == hooksUrl) &&
            (identical(other.issueCommentUrl, issueCommentUrl) || other.issueCommentUrl == issueCommentUrl) &&
            (identical(other.issueEventsUrl, issueEventsUrl) || other.issueEventsUrl == issueEventsUrl) &&
            (identical(other.issuesUrl, issuesUrl) || other.issuesUrl == issuesUrl) &&
            (identical(other.keysUrl, keysUrl) || other.keysUrl == keysUrl) &&
            (identical(other.labelsUrl, labelsUrl) || other.labelsUrl == labelsUrl) &&
            (identical(other.languagesUrl, languagesUrl) || other.languagesUrl == languagesUrl) &&
            (identical(other.mergesUrl, mergesUrl) || other.mergesUrl == mergesUrl) &&
            (identical(other.milestonesUrl, milestonesUrl) || other.milestonesUrl == milestonesUrl) &&
            (identical(other.mirrorUrl, mirrorUrl) || other.mirrorUrl == mirrorUrl) &&
            (identical(other.notificationsUrl, notificationsUrl) || other.notificationsUrl == notificationsUrl) &&
            (identical(other.pullsUrl, pullsUrl) || other.pullsUrl == pullsUrl) &&
            (identical(other.releasesUrl, releasesUrl) || other.releasesUrl == releasesUrl) &&
            (identical(other.stargazersUrl, stargazersUrl) || other.stargazersUrl == stargazersUrl) &&
            (identical(other.statusesUrl, statusesUrl) || other.statusesUrl == statusesUrl) &&
            (identical(other.subscribersUrl, subscribersUrl) || other.subscribersUrl == subscribersUrl) &&
            (identical(other.subscriptionUrl, subscriptionUrl) || other.subscriptionUrl == subscriptionUrl) &&
            (identical(other.tagsUrl, tagsUrl) || other.tagsUrl == tagsUrl) &&
            (identical(other.teamsUrl, teamsUrl) || other.teamsUrl == teamsUrl) &&
            (identical(other.treesUrl, treesUrl) || other.treesUrl == treesUrl) &&
            (identical(other.templateRepository, templateRepository) || other.templateRepository == templateRepository) &&
            (identical(other.starredAt, starredAt) || other.starredAt == starredAt) &&
            (identical(other.pushedAt, pushedAt) || other.pushedAt == pushedAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) || other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        fullName,
        owner,
        organization,
        language,
        license,
        permissions,
        isPrivate,
        isFork,
        isTemplate,
        description,
        masterBranch,
        mergeCommitMessage,
        mergeCommitTitle,
        squashMergeCommitMessage,
        squashMergeCommitTitle,
        nodeId,
        tempCloneToken,
        visibility,
        const DeepCollectionEquality().hash(topics),
        archived,
        disabled,
        hasIssues,
        hasWiki,
        hasDownloads,
        hasPages,
        hasDiscussions,
        hasProjects,
        allowAutoMerge,
        allowForking,
        allowMergeCommit,
        allowRebaseMerge,
        allowSquashMerge,
        allowUpdateBranch,
        anonymousAccessEnabled,
        deleteBranchOnMerge,
        webCommitSignoffRequired,
        size,
        stargazersCount,
        watchersCount,
        forksCount,
        openIssuesCount,
        subscribersCount,
        networkCount,
        htmlUrl,
        cloneUrl,
        sshUrl,
        svnUrl,
        gitUrl,
        homepageUrl,
        archiveUrl,
        assigneesUrl,
        blobsUrl,
        branchesUrl,
        collaboratorsUrl,
        commentsUrl,
        commitsUrl,
        compareUrl,
        contentsUrl,
        contributorsUrl,
        deploymentsUrl,
        downloadsUrl,
        eventsUrl,
        forksUrl,
        gitCommitsUrl,
        gitRefsUrl,
        gitTagsUrl,
        hooksUrl,
        issueCommentUrl,
        issueEventsUrl,
        issuesUrl,
        keysUrl,
        labelsUrl,
        languagesUrl,
        mergesUrl,
        milestonesUrl,
        mirrorUrl,
        notificationsUrl,
        pullsUrl,
        releasesUrl,
        stargazersUrl,
        statusesUrl,
        subscribersUrl,
        subscriptionUrl,
        tagsUrl,
        teamsUrl,
        treesUrl,
        templateRepository,
        starredAt,
        pushedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubRepositoryModel(id: $id, name: $name, fullName: $fullName, owner: $owner, organization: $organization, language: $language, license: $license, permissions: $permissions, isPrivate: $isPrivate, isFork: $isFork, isTemplate: $isTemplate, description: $description, masterBranch: $masterBranch, mergeCommitMessage: $mergeCommitMessage, mergeCommitTitle: $mergeCommitTitle, squashMergeCommitMessage: $squashMergeCommitMessage, squashMergeCommitTitle: $squashMergeCommitTitle, nodeId: $nodeId, tempCloneToken: $tempCloneToken, visibility: $visibility, topics: $topics, archived: $archived, disabled: $disabled, hasIssues: $hasIssues, hasWiki: $hasWiki, hasDownloads: $hasDownloads, hasPages: $hasPages, hasDiscussions: $hasDiscussions, hasProjects: $hasProjects, allowAutoMerge: $allowAutoMerge, allowForking: $allowForking, allowMergeCommit: $allowMergeCommit, allowRebaseMerge: $allowRebaseMerge, allowSquashMerge: $allowSquashMerge, allowUpdateBranch: $allowUpdateBranch, anonymousAccessEnabled: $anonymousAccessEnabled, deleteBranchOnMerge: $deleteBranchOnMerge, webCommitSignoffRequired: $webCommitSignoffRequired, size: $size, stargazersCount: $stargazersCount, watchersCount: $watchersCount, forksCount: $forksCount, openIssuesCount: $openIssuesCount, subscribersCount: $subscribersCount, networkCount: $networkCount, htmlUrl: $htmlUrl, cloneUrl: $cloneUrl, sshUrl: $sshUrl, svnUrl: $svnUrl, gitUrl: $gitUrl, homepageUrl: $homepageUrl, archiveUrl: $archiveUrl, assigneesUrl: $assigneesUrl, blobsUrl: $blobsUrl, branchesUrl: $branchesUrl, collaboratorsUrl: $collaboratorsUrl, commentsUrl: $commentsUrl, commitsUrl: $commitsUrl, compareUrl: $compareUrl, contentsUrl: $contentsUrl, contributorsUrl: $contributorsUrl, deploymentsUrl: $deploymentsUrl, downloadsUrl: $downloadsUrl, eventsUrl: $eventsUrl, forksUrl: $forksUrl, gitCommitsUrl: $gitCommitsUrl, gitRefsUrl: $gitRefsUrl, gitTagsUrl: $gitTagsUrl, hooksUrl: $hooksUrl, issueCommentUrl: $issueCommentUrl, issueEventsUrl: $issueEventsUrl, issuesUrl: $issuesUrl, keysUrl: $keysUrl, labelsUrl: $labelsUrl, languagesUrl: $languagesUrl, mergesUrl: $mergesUrl, milestonesUrl: $milestonesUrl, mirrorUrl: $mirrorUrl, notificationsUrl: $notificationsUrl, pullsUrl: $pullsUrl, releasesUrl: $releasesUrl, stargazersUrl: $stargazersUrl, statusesUrl: $statusesUrl, subscribersUrl: $subscribersUrl, subscriptionUrl: $subscriptionUrl, tagsUrl: $tagsUrl, teamsUrl: $teamsUrl, treesUrl: $treesUrl, templateRepository: $templateRepository, starredAt: $starredAt, pushedAt: $pushedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubRepositoryModelCopyWith<$Res> {
  factory $GithubRepositoryModelCopyWith(GithubRepositoryModel value,
          $Res Function(GithubRepositoryModel) _then) =
      _$GithubRepositoryModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      @searchParam String? name,
      @searchParam String? fullName,
      @refParam GithubUserModelRef owner,
      @refParam GithubOrganizationModelRef organization,
      @searchParam String? language,
      @jsonParam GithubLicenseValue? license,
      @jsonParam GithubRepositoryPermissionValue? permissions,
      bool isPrivate,
      bool isFork,
      bool isTemplate,
      @searchParam String? description,
      String? masterBranch,
      String? mergeCommitMessage,
      String? mergeCommitTitle,
      String? squashMergeCommitMessage,
      String? squashMergeCommitTitle,
      String? nodeId,
      String? tempCloneToken,
      String? visibility,
      List<String> topics,
      bool archived,
      bool disabled,
      bool hasIssues,
      bool hasWiki,
      bool hasDownloads,
      bool hasPages,
      bool hasDiscussions,
      bool hasProjects,
      bool allowAutoMerge,
      bool allowForking,
      bool allowMergeCommit,
      bool allowRebaseMerge,
      bool allowSquashMerge,
      bool allowUpdateBranch,
      bool anonymousAccessEnabled,
      bool deleteBranchOnMerge,
      bool webCommitSignoffRequired,
      int size,
      int stargazersCount,
      int watchersCount,
      int forksCount,
      int openIssuesCount,
      int subscribersCount,
      int networkCount,
      ModelUri? htmlUrl,
      ModelUri? cloneUrl,
      ModelUri? sshUrl,
      ModelUri? svnUrl,
      ModelUri? gitUrl,
      ModelUri? homepageUrl,
      ModelUri? archiveUrl,
      ModelUri? assigneesUrl,
      ModelUri? blobsUrl,
      ModelUri? branchesUrl,
      ModelUri? collaboratorsUrl,
      ModelUri? commentsUrl,
      ModelUri? commitsUrl,
      ModelUri? compareUrl,
      ModelUri? contentsUrl,
      ModelUri? contributorsUrl,
      ModelUri? deploymentsUrl,
      ModelUri? downloadsUrl,
      ModelUri? eventsUrl,
      ModelUri? forksUrl,
      ModelUri? gitCommitsUrl,
      ModelUri? gitRefsUrl,
      ModelUri? gitTagsUrl,
      ModelUri? hooksUrl,
      ModelUri? issueCommentUrl,
      ModelUri? issueEventsUrl,
      ModelUri? issuesUrl,
      ModelUri? keysUrl,
      ModelUri? labelsUrl,
      ModelUri? languagesUrl,
      ModelUri? mergesUrl,
      ModelUri? milestonesUrl,
      ModelUri? mirrorUrl,
      ModelUri? notificationsUrl,
      ModelUri? pullsUrl,
      ModelUri? releasesUrl,
      ModelUri? stargazersUrl,
      ModelUri? statusesUrl,
      ModelUri? subscribersUrl,
      ModelUri? subscriptionUrl,
      ModelUri? tagsUrl,
      ModelUri? teamsUrl,
      ModelUri? treesUrl,
      @refParam GithubRepositoryModelRef? templateRepository,
      ModelTimestamp? starredAt,
      ModelTimestamp? pushedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  $GithubLicenseValueCopyWith<$Res>? get license;
  $GithubRepositoryPermissionValueCopyWith<$Res>? get permissions;
}

/// @nodoc
class _$GithubRepositoryModelCopyWithImpl<$Res>
    implements $GithubRepositoryModelCopyWith<$Res> {
  _$GithubRepositoryModelCopyWithImpl(this._self, this._then);

  final GithubRepositoryModel _self;
  final $Res Function(GithubRepositoryModel) _then;

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? fullName = freezed,
    Object? owner = freezed,
    Object? organization = freezed,
    Object? language = freezed,
    Object? license = freezed,
    Object? permissions = freezed,
    Object? isPrivate = null,
    Object? isFork = null,
    Object? isTemplate = null,
    Object? description = freezed,
    Object? masterBranch = freezed,
    Object? mergeCommitMessage = freezed,
    Object? mergeCommitTitle = freezed,
    Object? squashMergeCommitMessage = freezed,
    Object? squashMergeCommitTitle = freezed,
    Object? nodeId = freezed,
    Object? tempCloneToken = freezed,
    Object? visibility = freezed,
    Object? topics = null,
    Object? archived = null,
    Object? disabled = null,
    Object? hasIssues = null,
    Object? hasWiki = null,
    Object? hasDownloads = null,
    Object? hasPages = null,
    Object? hasDiscussions = null,
    Object? hasProjects = null,
    Object? allowAutoMerge = null,
    Object? allowForking = null,
    Object? allowMergeCommit = null,
    Object? allowRebaseMerge = null,
    Object? allowSquashMerge = null,
    Object? allowUpdateBranch = null,
    Object? anonymousAccessEnabled = null,
    Object? deleteBranchOnMerge = null,
    Object? webCommitSignoffRequired = null,
    Object? size = null,
    Object? stargazersCount = null,
    Object? watchersCount = null,
    Object? forksCount = null,
    Object? openIssuesCount = null,
    Object? subscribersCount = null,
    Object? networkCount = null,
    Object? htmlUrl = freezed,
    Object? cloneUrl = freezed,
    Object? sshUrl = freezed,
    Object? svnUrl = freezed,
    Object? gitUrl = freezed,
    Object? homepageUrl = freezed,
    Object? archiveUrl = freezed,
    Object? assigneesUrl = freezed,
    Object? blobsUrl = freezed,
    Object? branchesUrl = freezed,
    Object? collaboratorsUrl = freezed,
    Object? commentsUrl = freezed,
    Object? commitsUrl = freezed,
    Object? compareUrl = freezed,
    Object? contentsUrl = freezed,
    Object? contributorsUrl = freezed,
    Object? deploymentsUrl = freezed,
    Object? downloadsUrl = freezed,
    Object? eventsUrl = freezed,
    Object? forksUrl = freezed,
    Object? gitCommitsUrl = freezed,
    Object? gitRefsUrl = freezed,
    Object? gitTagsUrl = freezed,
    Object? hooksUrl = freezed,
    Object? issueCommentUrl = freezed,
    Object? issueEventsUrl = freezed,
    Object? issuesUrl = freezed,
    Object? keysUrl = freezed,
    Object? labelsUrl = freezed,
    Object? languagesUrl = freezed,
    Object? mergesUrl = freezed,
    Object? milestonesUrl = freezed,
    Object? mirrorUrl = freezed,
    Object? notificationsUrl = freezed,
    Object? pullsUrl = freezed,
    Object? releasesUrl = freezed,
    Object? stargazersUrl = freezed,
    Object? statusesUrl = freezed,
    Object? subscribersUrl = freezed,
    Object? subscriptionUrl = freezed,
    Object? tagsUrl = freezed,
    Object? teamsUrl = freezed,
    Object? treesUrl = freezed,
    Object? templateRepository = freezed,
    Object? starredAt = freezed,
    Object? pushedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: freezed == owner
          ? _self.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as GithubOrganizationModelRef,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      license: freezed == license
          ? _self.license
          : license // ignore: cast_nullable_to_non_nullable
              as GithubLicenseValue?,
      permissions: freezed == permissions
          ? _self.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryPermissionValue?,
      isPrivate: null == isPrivate
          ? _self.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isFork: null == isFork
          ? _self.isFork
          : isFork // ignore: cast_nullable_to_non_nullable
              as bool,
      isTemplate: null == isTemplate
          ? _self.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      masterBranch: freezed == masterBranch
          ? _self.masterBranch
          : masterBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeCommitMessage: freezed == mergeCommitMessage
          ? _self.mergeCommitMessage
          : mergeCommitMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeCommitTitle: freezed == mergeCommitTitle
          ? _self.mergeCommitTitle
          : mergeCommitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      squashMergeCommitMessage: freezed == squashMergeCommitMessage
          ? _self.squashMergeCommitMessage
          : squashMergeCommitMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      squashMergeCommitTitle: freezed == squashMergeCommitTitle
          ? _self.squashMergeCommitTitle
          : squashMergeCommitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      tempCloneToken: freezed == tempCloneToken
          ? _self.tempCloneToken
          : tempCloneToken // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _self.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      topics: null == topics
          ? _self.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      archived: null == archived
          ? _self.archived
          : archived // ignore: cast_nullable_to_non_nullable
              as bool,
      disabled: null == disabled
          ? _self.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasIssues: null == hasIssues
          ? _self.hasIssues
          : hasIssues // ignore: cast_nullable_to_non_nullable
              as bool,
      hasWiki: null == hasWiki
          ? _self.hasWiki
          : hasWiki // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDownloads: null == hasDownloads
          ? _self.hasDownloads
          : hasDownloads // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPages: null == hasPages
          ? _self.hasPages
          : hasPages // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDiscussions: null == hasDiscussions
          ? _self.hasDiscussions
          : hasDiscussions // ignore: cast_nullable_to_non_nullable
              as bool,
      hasProjects: null == hasProjects
          ? _self.hasProjects
          : hasProjects // ignore: cast_nullable_to_non_nullable
              as bool,
      allowAutoMerge: null == allowAutoMerge
          ? _self.allowAutoMerge
          : allowAutoMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      allowForking: null == allowForking
          ? _self.allowForking
          : allowForking // ignore: cast_nullable_to_non_nullable
              as bool,
      allowMergeCommit: null == allowMergeCommit
          ? _self.allowMergeCommit
          : allowMergeCommit // ignore: cast_nullable_to_non_nullable
              as bool,
      allowRebaseMerge: null == allowRebaseMerge
          ? _self.allowRebaseMerge
          : allowRebaseMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSquashMerge: null == allowSquashMerge
          ? _self.allowSquashMerge
          : allowSquashMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      allowUpdateBranch: null == allowUpdateBranch
          ? _self.allowUpdateBranch
          : allowUpdateBranch // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymousAccessEnabled: null == anonymousAccessEnabled
          ? _self.anonymousAccessEnabled
          : anonymousAccessEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteBranchOnMerge: null == deleteBranchOnMerge
          ? _self.deleteBranchOnMerge
          : deleteBranchOnMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      webCommitSignoffRequired: null == webCommitSignoffRequired
          ? _self.webCommitSignoffRequired
          : webCommitSignoffRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      stargazersCount: null == stargazersCount
          ? _self.stargazersCount
          : stargazersCount // ignore: cast_nullable_to_non_nullable
              as int,
      watchersCount: null == watchersCount
          ? _self.watchersCount
          : watchersCount // ignore: cast_nullable_to_non_nullable
              as int,
      forksCount: null == forksCount
          ? _self.forksCount
          : forksCount // ignore: cast_nullable_to_non_nullable
              as int,
      openIssuesCount: null == openIssuesCount
          ? _self.openIssuesCount
          : openIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      subscribersCount: null == subscribersCount
          ? _self.subscribersCount
          : subscribersCount // ignore: cast_nullable_to_non_nullable
              as int,
      networkCount: null == networkCount
          ? _self.networkCount
          : networkCount // ignore: cast_nullable_to_non_nullable
              as int,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      cloneUrl: freezed == cloneUrl
          ? _self.cloneUrl
          : cloneUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      sshUrl: freezed == sshUrl
          ? _self.sshUrl
          : sshUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      svnUrl: freezed == svnUrl
          ? _self.svnUrl
          : svnUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitUrl: freezed == gitUrl
          ? _self.gitUrl
          : gitUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      homepageUrl: freezed == homepageUrl
          ? _self.homepageUrl
          : homepageUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      archiveUrl: freezed == archiveUrl
          ? _self.archiveUrl
          : archiveUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      assigneesUrl: freezed == assigneesUrl
          ? _self.assigneesUrl
          : assigneesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      blobsUrl: freezed == blobsUrl
          ? _self.blobsUrl
          : blobsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      branchesUrl: freezed == branchesUrl
          ? _self.branchesUrl
          : branchesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      collaboratorsUrl: freezed == collaboratorsUrl
          ? _self.collaboratorsUrl
          : collaboratorsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commentsUrl: freezed == commentsUrl
          ? _self.commentsUrl
          : commentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commitsUrl: freezed == commitsUrl
          ? _self.commitsUrl
          : commitsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      compareUrl: freezed == compareUrl
          ? _self.compareUrl
          : compareUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      contentsUrl: freezed == contentsUrl
          ? _self.contentsUrl
          : contentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      contributorsUrl: freezed == contributorsUrl
          ? _self.contributorsUrl
          : contributorsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      deploymentsUrl: freezed == deploymentsUrl
          ? _self.deploymentsUrl
          : deploymentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      downloadsUrl: freezed == downloadsUrl
          ? _self.downloadsUrl
          : downloadsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      eventsUrl: freezed == eventsUrl
          ? _self.eventsUrl
          : eventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      forksUrl: freezed == forksUrl
          ? _self.forksUrl
          : forksUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitCommitsUrl: freezed == gitCommitsUrl
          ? _self.gitCommitsUrl
          : gitCommitsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitRefsUrl: freezed == gitRefsUrl
          ? _self.gitRefsUrl
          : gitRefsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitTagsUrl: freezed == gitTagsUrl
          ? _self.gitTagsUrl
          : gitTagsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      hooksUrl: freezed == hooksUrl
          ? _self.hooksUrl
          : hooksUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueCommentUrl: freezed == issueCommentUrl
          ? _self.issueCommentUrl
          : issueCommentUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueEventsUrl: freezed == issueEventsUrl
          ? _self.issueEventsUrl
          : issueEventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issuesUrl: freezed == issuesUrl
          ? _self.issuesUrl
          : issuesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      keysUrl: freezed == keysUrl
          ? _self.keysUrl
          : keysUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      labelsUrl: freezed == labelsUrl
          ? _self.labelsUrl
          : labelsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      languagesUrl: freezed == languagesUrl
          ? _self.languagesUrl
          : languagesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      mergesUrl: freezed == mergesUrl
          ? _self.mergesUrl
          : mergesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      milestonesUrl: freezed == milestonesUrl
          ? _self.milestonesUrl
          : milestonesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      mirrorUrl: freezed == mirrorUrl
          ? _self.mirrorUrl
          : mirrorUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      notificationsUrl: freezed == notificationsUrl
          ? _self.notificationsUrl
          : notificationsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      pullsUrl: freezed == pullsUrl
          ? _self.pullsUrl
          : pullsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      releasesUrl: freezed == releasesUrl
          ? _self.releasesUrl
          : releasesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      stargazersUrl: freezed == stargazersUrl
          ? _self.stargazersUrl
          : stargazersUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      statusesUrl: freezed == statusesUrl
          ? _self.statusesUrl
          : statusesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      subscribersUrl: freezed == subscribersUrl
          ? _self.subscribersUrl
          : subscribersUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      subscriptionUrl: freezed == subscriptionUrl
          ? _self.subscriptionUrl
          : subscriptionUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      tagsUrl: freezed == tagsUrl
          ? _self.tagsUrl
          : tagsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      teamsUrl: freezed == teamsUrl
          ? _self.teamsUrl
          : teamsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      treesUrl: freezed == treesUrl
          ? _self.treesUrl
          : treesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      templateRepository: freezed == templateRepository
          ? _self.templateRepository
          : templateRepository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      starredAt: freezed == starredAt
          ? _self.starredAt
          : starredAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      pushedAt: freezed == pushedAt
          ? _self.pushedAt
          : pushedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubLicenseValueCopyWith<$Res>? get license {
    if (_self.license == null) {
      return null;
    }

    return $GithubLicenseValueCopyWith<$Res>(_self.license!, (value) {
      return _then(_self.copyWith(license: value));
    });
  }

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubRepositoryPermissionValueCopyWith<$Res>? get permissions {
    if (_self.permissions == null) {
      return null;
    }

    return $GithubRepositoryPermissionValueCopyWith<$Res>(_self.permissions!,
        (value) {
      return _then(_self.copyWith(permissions: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GithubRepositoryModel].
extension GithubRepositoryModelPatterns on GithubRepositoryModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GithubRepositoryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GithubRepositoryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GithubRepositoryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int? id,
            @searchParam String? name,
            @searchParam String? fullName,
            @refParam GithubUserModelRef owner,
            @refParam GithubOrganizationModelRef organization,
            @searchParam String? language,
            @jsonParam GithubLicenseValue? license,
            @jsonParam GithubRepositoryPermissionValue? permissions,
            bool isPrivate,
            bool isFork,
            bool isTemplate,
            @searchParam String? description,
            String? masterBranch,
            String? mergeCommitMessage,
            String? mergeCommitTitle,
            String? squashMergeCommitMessage,
            String? squashMergeCommitTitle,
            String? nodeId,
            String? tempCloneToken,
            String? visibility,
            List<String> topics,
            bool archived,
            bool disabled,
            bool hasIssues,
            bool hasWiki,
            bool hasDownloads,
            bool hasPages,
            bool hasDiscussions,
            bool hasProjects,
            bool allowAutoMerge,
            bool allowForking,
            bool allowMergeCommit,
            bool allowRebaseMerge,
            bool allowSquashMerge,
            bool allowUpdateBranch,
            bool anonymousAccessEnabled,
            bool deleteBranchOnMerge,
            bool webCommitSignoffRequired,
            int size,
            int stargazersCount,
            int watchersCount,
            int forksCount,
            int openIssuesCount,
            int subscribersCount,
            int networkCount,
            ModelUri? htmlUrl,
            ModelUri? cloneUrl,
            ModelUri? sshUrl,
            ModelUri? svnUrl,
            ModelUri? gitUrl,
            ModelUri? homepageUrl,
            ModelUri? archiveUrl,
            ModelUri? assigneesUrl,
            ModelUri? blobsUrl,
            ModelUri? branchesUrl,
            ModelUri? collaboratorsUrl,
            ModelUri? commentsUrl,
            ModelUri? commitsUrl,
            ModelUri? compareUrl,
            ModelUri? contentsUrl,
            ModelUri? contributorsUrl,
            ModelUri? deploymentsUrl,
            ModelUri? downloadsUrl,
            ModelUri? eventsUrl,
            ModelUri? forksUrl,
            ModelUri? gitCommitsUrl,
            ModelUri? gitRefsUrl,
            ModelUri? gitTagsUrl,
            ModelUri? hooksUrl,
            ModelUri? issueCommentUrl,
            ModelUri? issueEventsUrl,
            ModelUri? issuesUrl,
            ModelUri? keysUrl,
            ModelUri? labelsUrl,
            ModelUri? languagesUrl,
            ModelUri? mergesUrl,
            ModelUri? milestonesUrl,
            ModelUri? mirrorUrl,
            ModelUri? notificationsUrl,
            ModelUri? pullsUrl,
            ModelUri? releasesUrl,
            ModelUri? stargazersUrl,
            ModelUri? statusesUrl,
            ModelUri? subscribersUrl,
            ModelUri? subscriptionUrl,
            ModelUri? tagsUrl,
            ModelUri? teamsUrl,
            ModelUri? treesUrl,
            @refParam GithubRepositoryModelRef? templateRepository,
            ModelTimestamp? starredAt,
            ModelTimestamp? pushedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.fullName,
            _that.owner,
            _that.organization,
            _that.language,
            _that.license,
            _that.permissions,
            _that.isPrivate,
            _that.isFork,
            _that.isTemplate,
            _that.description,
            _that.masterBranch,
            _that.mergeCommitMessage,
            _that.mergeCommitTitle,
            _that.squashMergeCommitMessage,
            _that.squashMergeCommitTitle,
            _that.nodeId,
            _that.tempCloneToken,
            _that.visibility,
            _that.topics,
            _that.archived,
            _that.disabled,
            _that.hasIssues,
            _that.hasWiki,
            _that.hasDownloads,
            _that.hasPages,
            _that.hasDiscussions,
            _that.hasProjects,
            _that.allowAutoMerge,
            _that.allowForking,
            _that.allowMergeCommit,
            _that.allowRebaseMerge,
            _that.allowSquashMerge,
            _that.allowUpdateBranch,
            _that.anonymousAccessEnabled,
            _that.deleteBranchOnMerge,
            _that.webCommitSignoffRequired,
            _that.size,
            _that.stargazersCount,
            _that.watchersCount,
            _that.forksCount,
            _that.openIssuesCount,
            _that.subscribersCount,
            _that.networkCount,
            _that.htmlUrl,
            _that.cloneUrl,
            _that.sshUrl,
            _that.svnUrl,
            _that.gitUrl,
            _that.homepageUrl,
            _that.archiveUrl,
            _that.assigneesUrl,
            _that.blobsUrl,
            _that.branchesUrl,
            _that.collaboratorsUrl,
            _that.commentsUrl,
            _that.commitsUrl,
            _that.compareUrl,
            _that.contentsUrl,
            _that.contributorsUrl,
            _that.deploymentsUrl,
            _that.downloadsUrl,
            _that.eventsUrl,
            _that.forksUrl,
            _that.gitCommitsUrl,
            _that.gitRefsUrl,
            _that.gitTagsUrl,
            _that.hooksUrl,
            _that.issueCommentUrl,
            _that.issueEventsUrl,
            _that.issuesUrl,
            _that.keysUrl,
            _that.labelsUrl,
            _that.languagesUrl,
            _that.mergesUrl,
            _that.milestonesUrl,
            _that.mirrorUrl,
            _that.notificationsUrl,
            _that.pullsUrl,
            _that.releasesUrl,
            _that.stargazersUrl,
            _that.statusesUrl,
            _that.subscribersUrl,
            _that.subscriptionUrl,
            _that.tagsUrl,
            _that.teamsUrl,
            _that.treesUrl,
            _that.templateRepository,
            _that.starredAt,
            _that.pushedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.fromServer);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int? id,
            @searchParam String? name,
            @searchParam String? fullName,
            @refParam GithubUserModelRef owner,
            @refParam GithubOrganizationModelRef organization,
            @searchParam String? language,
            @jsonParam GithubLicenseValue? license,
            @jsonParam GithubRepositoryPermissionValue? permissions,
            bool isPrivate,
            bool isFork,
            bool isTemplate,
            @searchParam String? description,
            String? masterBranch,
            String? mergeCommitMessage,
            String? mergeCommitTitle,
            String? squashMergeCommitMessage,
            String? squashMergeCommitTitle,
            String? nodeId,
            String? tempCloneToken,
            String? visibility,
            List<String> topics,
            bool archived,
            bool disabled,
            bool hasIssues,
            bool hasWiki,
            bool hasDownloads,
            bool hasPages,
            bool hasDiscussions,
            bool hasProjects,
            bool allowAutoMerge,
            bool allowForking,
            bool allowMergeCommit,
            bool allowRebaseMerge,
            bool allowSquashMerge,
            bool allowUpdateBranch,
            bool anonymousAccessEnabled,
            bool deleteBranchOnMerge,
            bool webCommitSignoffRequired,
            int size,
            int stargazersCount,
            int watchersCount,
            int forksCount,
            int openIssuesCount,
            int subscribersCount,
            int networkCount,
            ModelUri? htmlUrl,
            ModelUri? cloneUrl,
            ModelUri? sshUrl,
            ModelUri? svnUrl,
            ModelUri? gitUrl,
            ModelUri? homepageUrl,
            ModelUri? archiveUrl,
            ModelUri? assigneesUrl,
            ModelUri? blobsUrl,
            ModelUri? branchesUrl,
            ModelUri? collaboratorsUrl,
            ModelUri? commentsUrl,
            ModelUri? commitsUrl,
            ModelUri? compareUrl,
            ModelUri? contentsUrl,
            ModelUri? contributorsUrl,
            ModelUri? deploymentsUrl,
            ModelUri? downloadsUrl,
            ModelUri? eventsUrl,
            ModelUri? forksUrl,
            ModelUri? gitCommitsUrl,
            ModelUri? gitRefsUrl,
            ModelUri? gitTagsUrl,
            ModelUri? hooksUrl,
            ModelUri? issueCommentUrl,
            ModelUri? issueEventsUrl,
            ModelUri? issuesUrl,
            ModelUri? keysUrl,
            ModelUri? labelsUrl,
            ModelUri? languagesUrl,
            ModelUri? mergesUrl,
            ModelUri? milestonesUrl,
            ModelUri? mirrorUrl,
            ModelUri? notificationsUrl,
            ModelUri? pullsUrl,
            ModelUri? releasesUrl,
            ModelUri? stargazersUrl,
            ModelUri? statusesUrl,
            ModelUri? subscribersUrl,
            ModelUri? subscriptionUrl,
            ModelUri? tagsUrl,
            ModelUri? teamsUrl,
            ModelUri? treesUrl,
            @refParam GithubRepositoryModelRef? templateRepository,
            ModelTimestamp? starredAt,
            ModelTimestamp? pushedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryModel():
        return $default(
            _that.id,
            _that.name,
            _that.fullName,
            _that.owner,
            _that.organization,
            _that.language,
            _that.license,
            _that.permissions,
            _that.isPrivate,
            _that.isFork,
            _that.isTemplate,
            _that.description,
            _that.masterBranch,
            _that.mergeCommitMessage,
            _that.mergeCommitTitle,
            _that.squashMergeCommitMessage,
            _that.squashMergeCommitTitle,
            _that.nodeId,
            _that.tempCloneToken,
            _that.visibility,
            _that.topics,
            _that.archived,
            _that.disabled,
            _that.hasIssues,
            _that.hasWiki,
            _that.hasDownloads,
            _that.hasPages,
            _that.hasDiscussions,
            _that.hasProjects,
            _that.allowAutoMerge,
            _that.allowForking,
            _that.allowMergeCommit,
            _that.allowRebaseMerge,
            _that.allowSquashMerge,
            _that.allowUpdateBranch,
            _that.anonymousAccessEnabled,
            _that.deleteBranchOnMerge,
            _that.webCommitSignoffRequired,
            _that.size,
            _that.stargazersCount,
            _that.watchersCount,
            _that.forksCount,
            _that.openIssuesCount,
            _that.subscribersCount,
            _that.networkCount,
            _that.htmlUrl,
            _that.cloneUrl,
            _that.sshUrl,
            _that.svnUrl,
            _that.gitUrl,
            _that.homepageUrl,
            _that.archiveUrl,
            _that.assigneesUrl,
            _that.blobsUrl,
            _that.branchesUrl,
            _that.collaboratorsUrl,
            _that.commentsUrl,
            _that.commitsUrl,
            _that.compareUrl,
            _that.contentsUrl,
            _that.contributorsUrl,
            _that.deploymentsUrl,
            _that.downloadsUrl,
            _that.eventsUrl,
            _that.forksUrl,
            _that.gitCommitsUrl,
            _that.gitRefsUrl,
            _that.gitTagsUrl,
            _that.hooksUrl,
            _that.issueCommentUrl,
            _that.issueEventsUrl,
            _that.issuesUrl,
            _that.keysUrl,
            _that.labelsUrl,
            _that.languagesUrl,
            _that.mergesUrl,
            _that.milestonesUrl,
            _that.mirrorUrl,
            _that.notificationsUrl,
            _that.pullsUrl,
            _that.releasesUrl,
            _that.stargazersUrl,
            _that.statusesUrl,
            _that.subscribersUrl,
            _that.subscriptionUrl,
            _that.tagsUrl,
            _that.teamsUrl,
            _that.treesUrl,
            _that.templateRepository,
            _that.starredAt,
            _that.pushedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.fromServer);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int? id,
            @searchParam String? name,
            @searchParam String? fullName,
            @refParam GithubUserModelRef owner,
            @refParam GithubOrganizationModelRef organization,
            @searchParam String? language,
            @jsonParam GithubLicenseValue? license,
            @jsonParam GithubRepositoryPermissionValue? permissions,
            bool isPrivate,
            bool isFork,
            bool isTemplate,
            @searchParam String? description,
            String? masterBranch,
            String? mergeCommitMessage,
            String? mergeCommitTitle,
            String? squashMergeCommitMessage,
            String? squashMergeCommitTitle,
            String? nodeId,
            String? tempCloneToken,
            String? visibility,
            List<String> topics,
            bool archived,
            bool disabled,
            bool hasIssues,
            bool hasWiki,
            bool hasDownloads,
            bool hasPages,
            bool hasDiscussions,
            bool hasProjects,
            bool allowAutoMerge,
            bool allowForking,
            bool allowMergeCommit,
            bool allowRebaseMerge,
            bool allowSquashMerge,
            bool allowUpdateBranch,
            bool anonymousAccessEnabled,
            bool deleteBranchOnMerge,
            bool webCommitSignoffRequired,
            int size,
            int stargazersCount,
            int watchersCount,
            int forksCount,
            int openIssuesCount,
            int subscribersCount,
            int networkCount,
            ModelUri? htmlUrl,
            ModelUri? cloneUrl,
            ModelUri? sshUrl,
            ModelUri? svnUrl,
            ModelUri? gitUrl,
            ModelUri? homepageUrl,
            ModelUri? archiveUrl,
            ModelUri? assigneesUrl,
            ModelUri? blobsUrl,
            ModelUri? branchesUrl,
            ModelUri? collaboratorsUrl,
            ModelUri? commentsUrl,
            ModelUri? commitsUrl,
            ModelUri? compareUrl,
            ModelUri? contentsUrl,
            ModelUri? contributorsUrl,
            ModelUri? deploymentsUrl,
            ModelUri? downloadsUrl,
            ModelUri? eventsUrl,
            ModelUri? forksUrl,
            ModelUri? gitCommitsUrl,
            ModelUri? gitRefsUrl,
            ModelUri? gitTagsUrl,
            ModelUri? hooksUrl,
            ModelUri? issueCommentUrl,
            ModelUri? issueEventsUrl,
            ModelUri? issuesUrl,
            ModelUri? keysUrl,
            ModelUri? labelsUrl,
            ModelUri? languagesUrl,
            ModelUri? mergesUrl,
            ModelUri? milestonesUrl,
            ModelUri? mirrorUrl,
            ModelUri? notificationsUrl,
            ModelUri? pullsUrl,
            ModelUri? releasesUrl,
            ModelUri? stargazersUrl,
            ModelUri? statusesUrl,
            ModelUri? subscribersUrl,
            ModelUri? subscriptionUrl,
            ModelUri? tagsUrl,
            ModelUri? teamsUrl,
            ModelUri? treesUrl,
            @refParam GithubRepositoryModelRef? templateRepository,
            ModelTimestamp? starredAt,
            ModelTimestamp? pushedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubRepositoryModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.fullName,
            _that.owner,
            _that.organization,
            _that.language,
            _that.license,
            _that.permissions,
            _that.isPrivate,
            _that.isFork,
            _that.isTemplate,
            _that.description,
            _that.masterBranch,
            _that.mergeCommitMessage,
            _that.mergeCommitTitle,
            _that.squashMergeCommitMessage,
            _that.squashMergeCommitTitle,
            _that.nodeId,
            _that.tempCloneToken,
            _that.visibility,
            _that.topics,
            _that.archived,
            _that.disabled,
            _that.hasIssues,
            _that.hasWiki,
            _that.hasDownloads,
            _that.hasPages,
            _that.hasDiscussions,
            _that.hasProjects,
            _that.allowAutoMerge,
            _that.allowForking,
            _that.allowMergeCommit,
            _that.allowRebaseMerge,
            _that.allowSquashMerge,
            _that.allowUpdateBranch,
            _that.anonymousAccessEnabled,
            _that.deleteBranchOnMerge,
            _that.webCommitSignoffRequired,
            _that.size,
            _that.stargazersCount,
            _that.watchersCount,
            _that.forksCount,
            _that.openIssuesCount,
            _that.subscribersCount,
            _that.networkCount,
            _that.htmlUrl,
            _that.cloneUrl,
            _that.sshUrl,
            _that.svnUrl,
            _that.gitUrl,
            _that.homepageUrl,
            _that.archiveUrl,
            _that.assigneesUrl,
            _that.blobsUrl,
            _that.branchesUrl,
            _that.collaboratorsUrl,
            _that.commentsUrl,
            _that.commitsUrl,
            _that.compareUrl,
            _that.contentsUrl,
            _that.contributorsUrl,
            _that.deploymentsUrl,
            _that.downloadsUrl,
            _that.eventsUrl,
            _that.forksUrl,
            _that.gitCommitsUrl,
            _that.gitRefsUrl,
            _that.gitTagsUrl,
            _that.hooksUrl,
            _that.issueCommentUrl,
            _that.issueEventsUrl,
            _that.issuesUrl,
            _that.keysUrl,
            _that.labelsUrl,
            _that.languagesUrl,
            _that.mergesUrl,
            _that.milestonesUrl,
            _that.mirrorUrl,
            _that.notificationsUrl,
            _that.pullsUrl,
            _that.releasesUrl,
            _that.stargazersUrl,
            _that.statusesUrl,
            _that.subscribersUrl,
            _that.subscriptionUrl,
            _that.tagsUrl,
            _that.teamsUrl,
            _that.treesUrl,
            _that.templateRepository,
            _that.starredAt,
            _that.pushedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubRepositoryModel extends GithubRepositoryModel {
  const _GithubRepositoryModel(
      {this.id,
      @searchParam this.name,
      @searchParam this.fullName,
      @refParam this.owner,
      @refParam this.organization,
      @searchParam this.language,
      @jsonParam this.license,
      @jsonParam this.permissions,
      this.isPrivate = false,
      this.isFork = false,
      this.isTemplate = false,
      @searchParam this.description,
      this.masterBranch,
      this.mergeCommitMessage,
      this.mergeCommitTitle,
      this.squashMergeCommitMessage,
      this.squashMergeCommitTitle,
      this.nodeId,
      this.tempCloneToken,
      this.visibility,
      final List<String> topics = const [],
      this.archived = false,
      this.disabled = false,
      this.hasIssues = false,
      this.hasWiki = false,
      this.hasDownloads = false,
      this.hasPages = false,
      this.hasDiscussions = false,
      this.hasProjects = false,
      this.allowAutoMerge = false,
      this.allowForking = false,
      this.allowMergeCommit = false,
      this.allowRebaseMerge = false,
      this.allowSquashMerge = false,
      this.allowUpdateBranch = false,
      this.anonymousAccessEnabled = false,
      this.deleteBranchOnMerge = false,
      this.webCommitSignoffRequired = false,
      this.size = 0,
      this.stargazersCount = 0,
      this.watchersCount = 0,
      this.forksCount = 0,
      this.openIssuesCount = 0,
      this.subscribersCount = 0,
      this.networkCount = 0,
      this.htmlUrl,
      this.cloneUrl,
      this.sshUrl,
      this.svnUrl,
      this.gitUrl,
      this.homepageUrl,
      this.archiveUrl,
      this.assigneesUrl,
      this.blobsUrl,
      this.branchesUrl,
      this.collaboratorsUrl,
      this.commentsUrl,
      this.commitsUrl,
      this.compareUrl,
      this.contentsUrl,
      this.contributorsUrl,
      this.deploymentsUrl,
      this.downloadsUrl,
      this.eventsUrl,
      this.forksUrl,
      this.gitCommitsUrl,
      this.gitRefsUrl,
      this.gitTagsUrl,
      this.hooksUrl,
      this.issueCommentUrl,
      this.issueEventsUrl,
      this.issuesUrl,
      this.keysUrl,
      this.labelsUrl,
      this.languagesUrl,
      this.mergesUrl,
      this.milestonesUrl,
      this.mirrorUrl,
      this.notificationsUrl,
      this.pullsUrl,
      this.releasesUrl,
      this.stargazersUrl,
      this.statusesUrl,
      this.subscribersUrl,
      this.subscriptionUrl,
      this.tagsUrl,
      this.teamsUrl,
      this.treesUrl,
      @refParam this.templateRepository,
      this.starredAt,
      this.pushedAt,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now(),
      this.fromServer = false})
      : _topics = topics,
        super._();
  factory _GithubRepositoryModel.fromJson(Map<String, dynamic> json) =>
      _$GithubRepositoryModelFromJson(json);

  @override
  final int? id;
  @override
  @searchParam
  final String? name;
  @override
  @searchParam
  final String? fullName;
  @override
  @refParam
  final GithubUserModelRef owner;
  @override
  @refParam
  final GithubOrganizationModelRef organization;
  @override
  @searchParam
  final String? language;
  @override
  @jsonParam
  final GithubLicenseValue? license;
  @override
  @jsonParam
  final GithubRepositoryPermissionValue? permissions;
  @override
  @JsonKey()
  final bool isPrivate;
  @override
  @JsonKey()
  final bool isFork;
  @override
  @JsonKey()
  final bool isTemplate;
  @override
  @searchParam
  final String? description;
  @override
  final String? masterBranch;
  @override
  final String? mergeCommitMessage;
  @override
  final String? mergeCommitTitle;
  @override
  final String? squashMergeCommitMessage;
  @override
  final String? squashMergeCommitTitle;
  @override
  final String? nodeId;
  @override
  final String? tempCloneToken;
  @override
  final String? visibility;
  final List<String> _topics;
  @override
  @JsonKey()
  List<String> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  @JsonKey()
  final bool archived;
  @override
  @JsonKey()
  final bool disabled;
  @override
  @JsonKey()
  final bool hasIssues;
  @override
  @JsonKey()
  final bool hasWiki;
  @override
  @JsonKey()
  final bool hasDownloads;
  @override
  @JsonKey()
  final bool hasPages;
  @override
  @JsonKey()
  final bool hasDiscussions;
  @override
  @JsonKey()
  final bool hasProjects;
  @override
  @JsonKey()
  final bool allowAutoMerge;
  @override
  @JsonKey()
  final bool allowForking;
  @override
  @JsonKey()
  final bool allowMergeCommit;
  @override
  @JsonKey()
  final bool allowRebaseMerge;
  @override
  @JsonKey()
  final bool allowSquashMerge;
  @override
  @JsonKey()
  final bool allowUpdateBranch;
  @override
  @JsonKey()
  final bool anonymousAccessEnabled;
  @override
  @JsonKey()
  final bool deleteBranchOnMerge;
  @override
  @JsonKey()
  final bool webCommitSignoffRequired;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final int stargazersCount;
  @override
  @JsonKey()
  final int watchersCount;
  @override
  @JsonKey()
  final int forksCount;
  @override
  @JsonKey()
  final int openIssuesCount;
  @override
  @JsonKey()
  final int subscribersCount;
  @override
  @JsonKey()
  final int networkCount;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? cloneUrl;
  @override
  final ModelUri? sshUrl;
  @override
  final ModelUri? svnUrl;
  @override
  final ModelUri? gitUrl;
  @override
  final ModelUri? homepageUrl;
  @override
  final ModelUri? archiveUrl;
  @override
  final ModelUri? assigneesUrl;
  @override
  final ModelUri? blobsUrl;
  @override
  final ModelUri? branchesUrl;
  @override
  final ModelUri? collaboratorsUrl;
  @override
  final ModelUri? commentsUrl;
  @override
  final ModelUri? commitsUrl;
  @override
  final ModelUri? compareUrl;
  @override
  final ModelUri? contentsUrl;
  @override
  final ModelUri? contributorsUrl;
  @override
  final ModelUri? deploymentsUrl;
  @override
  final ModelUri? downloadsUrl;
  @override
  final ModelUri? eventsUrl;
  @override
  final ModelUri? forksUrl;
  @override
  final ModelUri? gitCommitsUrl;
  @override
  final ModelUri? gitRefsUrl;
  @override
  final ModelUri? gitTagsUrl;
  @override
  final ModelUri? hooksUrl;
  @override
  final ModelUri? issueCommentUrl;
  @override
  final ModelUri? issueEventsUrl;
  @override
  final ModelUri? issuesUrl;
  @override
  final ModelUri? keysUrl;
  @override
  final ModelUri? labelsUrl;
  @override
  final ModelUri? languagesUrl;
  @override
  final ModelUri? mergesUrl;
  @override
  final ModelUri? milestonesUrl;
  @override
  final ModelUri? mirrorUrl;
  @override
  final ModelUri? notificationsUrl;
  @override
  final ModelUri? pullsUrl;
  @override
  final ModelUri? releasesUrl;
  @override
  final ModelUri? stargazersUrl;
  @override
  final ModelUri? statusesUrl;
  @override
  final ModelUri? subscribersUrl;
  @override
  final ModelUri? subscriptionUrl;
  @override
  final ModelUri? tagsUrl;
  @override
  final ModelUri? teamsUrl;
  @override
  final ModelUri? treesUrl;
  @override
  @refParam
  final GithubRepositoryModelRef? templateRepository;
  @override
  final ModelTimestamp? starredAt;
  @override
  final ModelTimestamp? pushedAt;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubRepositoryModelCopyWith<_GithubRepositoryModel> get copyWith =>
      __$GithubRepositoryModelCopyWithImpl<_GithubRepositoryModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubRepositoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubRepositoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.license, license) || other.license == license) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.isFork, isFork) || other.isFork == isFork) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.masterBranch, masterBranch) ||
                other.masterBranch == masterBranch) &&
            (identical(other.mergeCommitMessage, mergeCommitMessage) ||
                other.mergeCommitMessage == mergeCommitMessage) &&
            (identical(other.mergeCommitTitle, mergeCommitTitle) ||
                other.mergeCommitTitle == mergeCommitTitle) &&
            (identical(other.squashMergeCommitMessage, squashMergeCommitMessage) ||
                other.squashMergeCommitMessage == squashMergeCommitMessage) &&
            (identical(other.squashMergeCommitTitle, squashMergeCommitTitle) ||
                other.squashMergeCommitTitle == squashMergeCommitTitle) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.tempCloneToken, tempCloneToken) ||
                other.tempCloneToken == tempCloneToken) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.hasIssues, hasIssues) ||
                other.hasIssues == hasIssues) &&
            (identical(other.hasWiki, hasWiki) || other.hasWiki == hasWiki) &&
            (identical(other.hasDownloads, hasDownloads) ||
                other.hasDownloads == hasDownloads) &&
            (identical(other.hasPages, hasPages) ||
                other.hasPages == hasPages) &&
            (identical(other.hasDiscussions, hasDiscussions) ||
                other.hasDiscussions == hasDiscussions) &&
            (identical(other.hasProjects, hasProjects) ||
                other.hasProjects == hasProjects) &&
            (identical(other.allowAutoMerge, allowAutoMerge) ||
                other.allowAutoMerge == allowAutoMerge) &&
            (identical(other.allowForking, allowForking) ||
                other.allowForking == allowForking) &&
            (identical(other.allowMergeCommit, allowMergeCommit) ||
                other.allowMergeCommit == allowMergeCommit) &&
            (identical(other.allowRebaseMerge, allowRebaseMerge) ||
                other.allowRebaseMerge == allowRebaseMerge) &&
            (identical(other.allowSquashMerge, allowSquashMerge) ||
                other.allowSquashMerge == allowSquashMerge) &&
            (identical(other.allowUpdateBranch, allowUpdateBranch) ||
                other.allowUpdateBranch == allowUpdateBranch) &&
            (identical(other.anonymousAccessEnabled, anonymousAccessEnabled) ||
                other.anonymousAccessEnabled == anonymousAccessEnabled) &&
            (identical(other.deleteBranchOnMerge, deleteBranchOnMerge) ||
                other.deleteBranchOnMerge == deleteBranchOnMerge) &&
            (identical(other.webCommitSignoffRequired, webCommitSignoffRequired) ||
                other.webCommitSignoffRequired == webCommitSignoffRequired) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.stargazersCount, stargazersCount) ||
                other.stargazersCount == stargazersCount) &&
            (identical(other.watchersCount, watchersCount) ||
                other.watchersCount == watchersCount) &&
            (identical(other.forksCount, forksCount) ||
                other.forksCount == forksCount) &&
            (identical(other.openIssuesCount, openIssuesCount) ||
                other.openIssuesCount == openIssuesCount) &&
            (identical(other.subscribersCount, subscribersCount) ||
                other.subscribersCount == subscribersCount) &&
            (identical(other.networkCount, networkCount) || other.networkCount == networkCount) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.cloneUrl, cloneUrl) || other.cloneUrl == cloneUrl) &&
            (identical(other.sshUrl, sshUrl) || other.sshUrl == sshUrl) &&
            (identical(other.svnUrl, svnUrl) || other.svnUrl == svnUrl) &&
            (identical(other.gitUrl, gitUrl) || other.gitUrl == gitUrl) &&
            (identical(other.homepageUrl, homepageUrl) || other.homepageUrl == homepageUrl) &&
            (identical(other.archiveUrl, archiveUrl) || other.archiveUrl == archiveUrl) &&
            (identical(other.assigneesUrl, assigneesUrl) || other.assigneesUrl == assigneesUrl) &&
            (identical(other.blobsUrl, blobsUrl) || other.blobsUrl == blobsUrl) &&
            (identical(other.branchesUrl, branchesUrl) || other.branchesUrl == branchesUrl) &&
            (identical(other.collaboratorsUrl, collaboratorsUrl) || other.collaboratorsUrl == collaboratorsUrl) &&
            (identical(other.commentsUrl, commentsUrl) || other.commentsUrl == commentsUrl) &&
            (identical(other.commitsUrl, commitsUrl) || other.commitsUrl == commitsUrl) &&
            (identical(other.compareUrl, compareUrl) || other.compareUrl == compareUrl) &&
            (identical(other.contentsUrl, contentsUrl) || other.contentsUrl == contentsUrl) &&
            (identical(other.contributorsUrl, contributorsUrl) || other.contributorsUrl == contributorsUrl) &&
            (identical(other.deploymentsUrl, deploymentsUrl) || other.deploymentsUrl == deploymentsUrl) &&
            (identical(other.downloadsUrl, downloadsUrl) || other.downloadsUrl == downloadsUrl) &&
            (identical(other.eventsUrl, eventsUrl) || other.eventsUrl == eventsUrl) &&
            (identical(other.forksUrl, forksUrl) || other.forksUrl == forksUrl) &&
            (identical(other.gitCommitsUrl, gitCommitsUrl) || other.gitCommitsUrl == gitCommitsUrl) &&
            (identical(other.gitRefsUrl, gitRefsUrl) || other.gitRefsUrl == gitRefsUrl) &&
            (identical(other.gitTagsUrl, gitTagsUrl) || other.gitTagsUrl == gitTagsUrl) &&
            (identical(other.hooksUrl, hooksUrl) || other.hooksUrl == hooksUrl) &&
            (identical(other.issueCommentUrl, issueCommentUrl) || other.issueCommentUrl == issueCommentUrl) &&
            (identical(other.issueEventsUrl, issueEventsUrl) || other.issueEventsUrl == issueEventsUrl) &&
            (identical(other.issuesUrl, issuesUrl) || other.issuesUrl == issuesUrl) &&
            (identical(other.keysUrl, keysUrl) || other.keysUrl == keysUrl) &&
            (identical(other.labelsUrl, labelsUrl) || other.labelsUrl == labelsUrl) &&
            (identical(other.languagesUrl, languagesUrl) || other.languagesUrl == languagesUrl) &&
            (identical(other.mergesUrl, mergesUrl) || other.mergesUrl == mergesUrl) &&
            (identical(other.milestonesUrl, milestonesUrl) || other.milestonesUrl == milestonesUrl) &&
            (identical(other.mirrorUrl, mirrorUrl) || other.mirrorUrl == mirrorUrl) &&
            (identical(other.notificationsUrl, notificationsUrl) || other.notificationsUrl == notificationsUrl) &&
            (identical(other.pullsUrl, pullsUrl) || other.pullsUrl == pullsUrl) &&
            (identical(other.releasesUrl, releasesUrl) || other.releasesUrl == releasesUrl) &&
            (identical(other.stargazersUrl, stargazersUrl) || other.stargazersUrl == stargazersUrl) &&
            (identical(other.statusesUrl, statusesUrl) || other.statusesUrl == statusesUrl) &&
            (identical(other.subscribersUrl, subscribersUrl) || other.subscribersUrl == subscribersUrl) &&
            (identical(other.subscriptionUrl, subscriptionUrl) || other.subscriptionUrl == subscriptionUrl) &&
            (identical(other.tagsUrl, tagsUrl) || other.tagsUrl == tagsUrl) &&
            (identical(other.teamsUrl, teamsUrl) || other.teamsUrl == teamsUrl) &&
            (identical(other.treesUrl, treesUrl) || other.treesUrl == treesUrl) &&
            (identical(other.templateRepository, templateRepository) || other.templateRepository == templateRepository) &&
            (identical(other.starredAt, starredAt) || other.starredAt == starredAt) &&
            (identical(other.pushedAt, pushedAt) || other.pushedAt == pushedAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) || other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        fullName,
        owner,
        organization,
        language,
        license,
        permissions,
        isPrivate,
        isFork,
        isTemplate,
        description,
        masterBranch,
        mergeCommitMessage,
        mergeCommitTitle,
        squashMergeCommitMessage,
        squashMergeCommitTitle,
        nodeId,
        tempCloneToken,
        visibility,
        const DeepCollectionEquality().hash(_topics),
        archived,
        disabled,
        hasIssues,
        hasWiki,
        hasDownloads,
        hasPages,
        hasDiscussions,
        hasProjects,
        allowAutoMerge,
        allowForking,
        allowMergeCommit,
        allowRebaseMerge,
        allowSquashMerge,
        allowUpdateBranch,
        anonymousAccessEnabled,
        deleteBranchOnMerge,
        webCommitSignoffRequired,
        size,
        stargazersCount,
        watchersCount,
        forksCount,
        openIssuesCount,
        subscribersCount,
        networkCount,
        htmlUrl,
        cloneUrl,
        sshUrl,
        svnUrl,
        gitUrl,
        homepageUrl,
        archiveUrl,
        assigneesUrl,
        blobsUrl,
        branchesUrl,
        collaboratorsUrl,
        commentsUrl,
        commitsUrl,
        compareUrl,
        contentsUrl,
        contributorsUrl,
        deploymentsUrl,
        downloadsUrl,
        eventsUrl,
        forksUrl,
        gitCommitsUrl,
        gitRefsUrl,
        gitTagsUrl,
        hooksUrl,
        issueCommentUrl,
        issueEventsUrl,
        issuesUrl,
        keysUrl,
        labelsUrl,
        languagesUrl,
        mergesUrl,
        milestonesUrl,
        mirrorUrl,
        notificationsUrl,
        pullsUrl,
        releasesUrl,
        stargazersUrl,
        statusesUrl,
        subscribersUrl,
        subscriptionUrl,
        tagsUrl,
        teamsUrl,
        treesUrl,
        templateRepository,
        starredAt,
        pushedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubRepositoryModel(id: $id, name: $name, fullName: $fullName, owner: $owner, organization: $organization, language: $language, license: $license, permissions: $permissions, isPrivate: $isPrivate, isFork: $isFork, isTemplate: $isTemplate, description: $description, masterBranch: $masterBranch, mergeCommitMessage: $mergeCommitMessage, mergeCommitTitle: $mergeCommitTitle, squashMergeCommitMessage: $squashMergeCommitMessage, squashMergeCommitTitle: $squashMergeCommitTitle, nodeId: $nodeId, tempCloneToken: $tempCloneToken, visibility: $visibility, topics: $topics, archived: $archived, disabled: $disabled, hasIssues: $hasIssues, hasWiki: $hasWiki, hasDownloads: $hasDownloads, hasPages: $hasPages, hasDiscussions: $hasDiscussions, hasProjects: $hasProjects, allowAutoMerge: $allowAutoMerge, allowForking: $allowForking, allowMergeCommit: $allowMergeCommit, allowRebaseMerge: $allowRebaseMerge, allowSquashMerge: $allowSquashMerge, allowUpdateBranch: $allowUpdateBranch, anonymousAccessEnabled: $anonymousAccessEnabled, deleteBranchOnMerge: $deleteBranchOnMerge, webCommitSignoffRequired: $webCommitSignoffRequired, size: $size, stargazersCount: $stargazersCount, watchersCount: $watchersCount, forksCount: $forksCount, openIssuesCount: $openIssuesCount, subscribersCount: $subscribersCount, networkCount: $networkCount, htmlUrl: $htmlUrl, cloneUrl: $cloneUrl, sshUrl: $sshUrl, svnUrl: $svnUrl, gitUrl: $gitUrl, homepageUrl: $homepageUrl, archiveUrl: $archiveUrl, assigneesUrl: $assigneesUrl, blobsUrl: $blobsUrl, branchesUrl: $branchesUrl, collaboratorsUrl: $collaboratorsUrl, commentsUrl: $commentsUrl, commitsUrl: $commitsUrl, compareUrl: $compareUrl, contentsUrl: $contentsUrl, contributorsUrl: $contributorsUrl, deploymentsUrl: $deploymentsUrl, downloadsUrl: $downloadsUrl, eventsUrl: $eventsUrl, forksUrl: $forksUrl, gitCommitsUrl: $gitCommitsUrl, gitRefsUrl: $gitRefsUrl, gitTagsUrl: $gitTagsUrl, hooksUrl: $hooksUrl, issueCommentUrl: $issueCommentUrl, issueEventsUrl: $issueEventsUrl, issuesUrl: $issuesUrl, keysUrl: $keysUrl, labelsUrl: $labelsUrl, languagesUrl: $languagesUrl, mergesUrl: $mergesUrl, milestonesUrl: $milestonesUrl, mirrorUrl: $mirrorUrl, notificationsUrl: $notificationsUrl, pullsUrl: $pullsUrl, releasesUrl: $releasesUrl, stargazersUrl: $stargazersUrl, statusesUrl: $statusesUrl, subscribersUrl: $subscribersUrl, subscriptionUrl: $subscriptionUrl, tagsUrl: $tagsUrl, teamsUrl: $teamsUrl, treesUrl: $treesUrl, templateRepository: $templateRepository, starredAt: $starredAt, pushedAt: $pushedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubRepositoryModelCopyWith<$Res>
    implements $GithubRepositoryModelCopyWith<$Res> {
  factory _$GithubRepositoryModelCopyWith(_GithubRepositoryModel value,
          $Res Function(_GithubRepositoryModel) _then) =
      __$GithubRepositoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      @searchParam String? name,
      @searchParam String? fullName,
      @refParam GithubUserModelRef owner,
      @refParam GithubOrganizationModelRef organization,
      @searchParam String? language,
      @jsonParam GithubLicenseValue? license,
      @jsonParam GithubRepositoryPermissionValue? permissions,
      bool isPrivate,
      bool isFork,
      bool isTemplate,
      @searchParam String? description,
      String? masterBranch,
      String? mergeCommitMessage,
      String? mergeCommitTitle,
      String? squashMergeCommitMessage,
      String? squashMergeCommitTitle,
      String? nodeId,
      String? tempCloneToken,
      String? visibility,
      List<String> topics,
      bool archived,
      bool disabled,
      bool hasIssues,
      bool hasWiki,
      bool hasDownloads,
      bool hasPages,
      bool hasDiscussions,
      bool hasProjects,
      bool allowAutoMerge,
      bool allowForking,
      bool allowMergeCommit,
      bool allowRebaseMerge,
      bool allowSquashMerge,
      bool allowUpdateBranch,
      bool anonymousAccessEnabled,
      bool deleteBranchOnMerge,
      bool webCommitSignoffRequired,
      int size,
      int stargazersCount,
      int watchersCount,
      int forksCount,
      int openIssuesCount,
      int subscribersCount,
      int networkCount,
      ModelUri? htmlUrl,
      ModelUri? cloneUrl,
      ModelUri? sshUrl,
      ModelUri? svnUrl,
      ModelUri? gitUrl,
      ModelUri? homepageUrl,
      ModelUri? archiveUrl,
      ModelUri? assigneesUrl,
      ModelUri? blobsUrl,
      ModelUri? branchesUrl,
      ModelUri? collaboratorsUrl,
      ModelUri? commentsUrl,
      ModelUri? commitsUrl,
      ModelUri? compareUrl,
      ModelUri? contentsUrl,
      ModelUri? contributorsUrl,
      ModelUri? deploymentsUrl,
      ModelUri? downloadsUrl,
      ModelUri? eventsUrl,
      ModelUri? forksUrl,
      ModelUri? gitCommitsUrl,
      ModelUri? gitRefsUrl,
      ModelUri? gitTagsUrl,
      ModelUri? hooksUrl,
      ModelUri? issueCommentUrl,
      ModelUri? issueEventsUrl,
      ModelUri? issuesUrl,
      ModelUri? keysUrl,
      ModelUri? labelsUrl,
      ModelUri? languagesUrl,
      ModelUri? mergesUrl,
      ModelUri? milestonesUrl,
      ModelUri? mirrorUrl,
      ModelUri? notificationsUrl,
      ModelUri? pullsUrl,
      ModelUri? releasesUrl,
      ModelUri? stargazersUrl,
      ModelUri? statusesUrl,
      ModelUri? subscribersUrl,
      ModelUri? subscriptionUrl,
      ModelUri? tagsUrl,
      ModelUri? teamsUrl,
      ModelUri? treesUrl,
      @refParam GithubRepositoryModelRef? templateRepository,
      ModelTimestamp? starredAt,
      ModelTimestamp? pushedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  @override
  $GithubLicenseValueCopyWith<$Res>? get license;
  @override
  $GithubRepositoryPermissionValueCopyWith<$Res>? get permissions;
}

/// @nodoc
class __$GithubRepositoryModelCopyWithImpl<$Res>
    implements _$GithubRepositoryModelCopyWith<$Res> {
  __$GithubRepositoryModelCopyWithImpl(this._self, this._then);

  final _GithubRepositoryModel _self;
  final $Res Function(_GithubRepositoryModel) _then;

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? fullName = freezed,
    Object? owner = freezed,
    Object? organization = freezed,
    Object? language = freezed,
    Object? license = freezed,
    Object? permissions = freezed,
    Object? isPrivate = null,
    Object? isFork = null,
    Object? isTemplate = null,
    Object? description = freezed,
    Object? masterBranch = freezed,
    Object? mergeCommitMessage = freezed,
    Object? mergeCommitTitle = freezed,
    Object? squashMergeCommitMessage = freezed,
    Object? squashMergeCommitTitle = freezed,
    Object? nodeId = freezed,
    Object? tempCloneToken = freezed,
    Object? visibility = freezed,
    Object? topics = null,
    Object? archived = null,
    Object? disabled = null,
    Object? hasIssues = null,
    Object? hasWiki = null,
    Object? hasDownloads = null,
    Object? hasPages = null,
    Object? hasDiscussions = null,
    Object? hasProjects = null,
    Object? allowAutoMerge = null,
    Object? allowForking = null,
    Object? allowMergeCommit = null,
    Object? allowRebaseMerge = null,
    Object? allowSquashMerge = null,
    Object? allowUpdateBranch = null,
    Object? anonymousAccessEnabled = null,
    Object? deleteBranchOnMerge = null,
    Object? webCommitSignoffRequired = null,
    Object? size = null,
    Object? stargazersCount = null,
    Object? watchersCount = null,
    Object? forksCount = null,
    Object? openIssuesCount = null,
    Object? subscribersCount = null,
    Object? networkCount = null,
    Object? htmlUrl = freezed,
    Object? cloneUrl = freezed,
    Object? sshUrl = freezed,
    Object? svnUrl = freezed,
    Object? gitUrl = freezed,
    Object? homepageUrl = freezed,
    Object? archiveUrl = freezed,
    Object? assigneesUrl = freezed,
    Object? blobsUrl = freezed,
    Object? branchesUrl = freezed,
    Object? collaboratorsUrl = freezed,
    Object? commentsUrl = freezed,
    Object? commitsUrl = freezed,
    Object? compareUrl = freezed,
    Object? contentsUrl = freezed,
    Object? contributorsUrl = freezed,
    Object? deploymentsUrl = freezed,
    Object? downloadsUrl = freezed,
    Object? eventsUrl = freezed,
    Object? forksUrl = freezed,
    Object? gitCommitsUrl = freezed,
    Object? gitRefsUrl = freezed,
    Object? gitTagsUrl = freezed,
    Object? hooksUrl = freezed,
    Object? issueCommentUrl = freezed,
    Object? issueEventsUrl = freezed,
    Object? issuesUrl = freezed,
    Object? keysUrl = freezed,
    Object? labelsUrl = freezed,
    Object? languagesUrl = freezed,
    Object? mergesUrl = freezed,
    Object? milestonesUrl = freezed,
    Object? mirrorUrl = freezed,
    Object? notificationsUrl = freezed,
    Object? pullsUrl = freezed,
    Object? releasesUrl = freezed,
    Object? stargazersUrl = freezed,
    Object? statusesUrl = freezed,
    Object? subscribersUrl = freezed,
    Object? subscriptionUrl = freezed,
    Object? tagsUrl = freezed,
    Object? teamsUrl = freezed,
    Object? treesUrl = freezed,
    Object? templateRepository = freezed,
    Object? starredAt = freezed,
    Object? pushedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubRepositoryModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: freezed == owner
          ? _self.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as GithubOrganizationModelRef,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      license: freezed == license
          ? _self.license
          : license // ignore: cast_nullable_to_non_nullable
              as GithubLicenseValue?,
      permissions: freezed == permissions
          ? _self.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryPermissionValue?,
      isPrivate: null == isPrivate
          ? _self.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isFork: null == isFork
          ? _self.isFork
          : isFork // ignore: cast_nullable_to_non_nullable
              as bool,
      isTemplate: null == isTemplate
          ? _self.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      masterBranch: freezed == masterBranch
          ? _self.masterBranch
          : masterBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeCommitMessage: freezed == mergeCommitMessage
          ? _self.mergeCommitMessage
          : mergeCommitMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeCommitTitle: freezed == mergeCommitTitle
          ? _self.mergeCommitTitle
          : mergeCommitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      squashMergeCommitMessage: freezed == squashMergeCommitMessage
          ? _self.squashMergeCommitMessage
          : squashMergeCommitMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      squashMergeCommitTitle: freezed == squashMergeCommitTitle
          ? _self.squashMergeCommitTitle
          : squashMergeCommitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      tempCloneToken: freezed == tempCloneToken
          ? _self.tempCloneToken
          : tempCloneToken // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _self.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      topics: null == topics
          ? _self._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      archived: null == archived
          ? _self.archived
          : archived // ignore: cast_nullable_to_non_nullable
              as bool,
      disabled: null == disabled
          ? _self.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasIssues: null == hasIssues
          ? _self.hasIssues
          : hasIssues // ignore: cast_nullable_to_non_nullable
              as bool,
      hasWiki: null == hasWiki
          ? _self.hasWiki
          : hasWiki // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDownloads: null == hasDownloads
          ? _self.hasDownloads
          : hasDownloads // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPages: null == hasPages
          ? _self.hasPages
          : hasPages // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDiscussions: null == hasDiscussions
          ? _self.hasDiscussions
          : hasDiscussions // ignore: cast_nullable_to_non_nullable
              as bool,
      hasProjects: null == hasProjects
          ? _self.hasProjects
          : hasProjects // ignore: cast_nullable_to_non_nullable
              as bool,
      allowAutoMerge: null == allowAutoMerge
          ? _self.allowAutoMerge
          : allowAutoMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      allowForking: null == allowForking
          ? _self.allowForking
          : allowForking // ignore: cast_nullable_to_non_nullable
              as bool,
      allowMergeCommit: null == allowMergeCommit
          ? _self.allowMergeCommit
          : allowMergeCommit // ignore: cast_nullable_to_non_nullable
              as bool,
      allowRebaseMerge: null == allowRebaseMerge
          ? _self.allowRebaseMerge
          : allowRebaseMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSquashMerge: null == allowSquashMerge
          ? _self.allowSquashMerge
          : allowSquashMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      allowUpdateBranch: null == allowUpdateBranch
          ? _self.allowUpdateBranch
          : allowUpdateBranch // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymousAccessEnabled: null == anonymousAccessEnabled
          ? _self.anonymousAccessEnabled
          : anonymousAccessEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteBranchOnMerge: null == deleteBranchOnMerge
          ? _self.deleteBranchOnMerge
          : deleteBranchOnMerge // ignore: cast_nullable_to_non_nullable
              as bool,
      webCommitSignoffRequired: null == webCommitSignoffRequired
          ? _self.webCommitSignoffRequired
          : webCommitSignoffRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      stargazersCount: null == stargazersCount
          ? _self.stargazersCount
          : stargazersCount // ignore: cast_nullable_to_non_nullable
              as int,
      watchersCount: null == watchersCount
          ? _self.watchersCount
          : watchersCount // ignore: cast_nullable_to_non_nullable
              as int,
      forksCount: null == forksCount
          ? _self.forksCount
          : forksCount // ignore: cast_nullable_to_non_nullable
              as int,
      openIssuesCount: null == openIssuesCount
          ? _self.openIssuesCount
          : openIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      subscribersCount: null == subscribersCount
          ? _self.subscribersCount
          : subscribersCount // ignore: cast_nullable_to_non_nullable
              as int,
      networkCount: null == networkCount
          ? _self.networkCount
          : networkCount // ignore: cast_nullable_to_non_nullable
              as int,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      cloneUrl: freezed == cloneUrl
          ? _self.cloneUrl
          : cloneUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      sshUrl: freezed == sshUrl
          ? _self.sshUrl
          : sshUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      svnUrl: freezed == svnUrl
          ? _self.svnUrl
          : svnUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitUrl: freezed == gitUrl
          ? _self.gitUrl
          : gitUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      homepageUrl: freezed == homepageUrl
          ? _self.homepageUrl
          : homepageUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      archiveUrl: freezed == archiveUrl
          ? _self.archiveUrl
          : archiveUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      assigneesUrl: freezed == assigneesUrl
          ? _self.assigneesUrl
          : assigneesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      blobsUrl: freezed == blobsUrl
          ? _self.blobsUrl
          : blobsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      branchesUrl: freezed == branchesUrl
          ? _self.branchesUrl
          : branchesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      collaboratorsUrl: freezed == collaboratorsUrl
          ? _self.collaboratorsUrl
          : collaboratorsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commentsUrl: freezed == commentsUrl
          ? _self.commentsUrl
          : commentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commitsUrl: freezed == commitsUrl
          ? _self.commitsUrl
          : commitsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      compareUrl: freezed == compareUrl
          ? _self.compareUrl
          : compareUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      contentsUrl: freezed == contentsUrl
          ? _self.contentsUrl
          : contentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      contributorsUrl: freezed == contributorsUrl
          ? _self.contributorsUrl
          : contributorsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      deploymentsUrl: freezed == deploymentsUrl
          ? _self.deploymentsUrl
          : deploymentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      downloadsUrl: freezed == downloadsUrl
          ? _self.downloadsUrl
          : downloadsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      eventsUrl: freezed == eventsUrl
          ? _self.eventsUrl
          : eventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      forksUrl: freezed == forksUrl
          ? _self.forksUrl
          : forksUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitCommitsUrl: freezed == gitCommitsUrl
          ? _self.gitCommitsUrl
          : gitCommitsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitRefsUrl: freezed == gitRefsUrl
          ? _self.gitRefsUrl
          : gitRefsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      gitTagsUrl: freezed == gitTagsUrl
          ? _self.gitTagsUrl
          : gitTagsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      hooksUrl: freezed == hooksUrl
          ? _self.hooksUrl
          : hooksUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueCommentUrl: freezed == issueCommentUrl
          ? _self.issueCommentUrl
          : issueCommentUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueEventsUrl: freezed == issueEventsUrl
          ? _self.issueEventsUrl
          : issueEventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issuesUrl: freezed == issuesUrl
          ? _self.issuesUrl
          : issuesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      keysUrl: freezed == keysUrl
          ? _self.keysUrl
          : keysUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      labelsUrl: freezed == labelsUrl
          ? _self.labelsUrl
          : labelsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      languagesUrl: freezed == languagesUrl
          ? _self.languagesUrl
          : languagesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      mergesUrl: freezed == mergesUrl
          ? _self.mergesUrl
          : mergesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      milestonesUrl: freezed == milestonesUrl
          ? _self.milestonesUrl
          : milestonesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      mirrorUrl: freezed == mirrorUrl
          ? _self.mirrorUrl
          : mirrorUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      notificationsUrl: freezed == notificationsUrl
          ? _self.notificationsUrl
          : notificationsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      pullsUrl: freezed == pullsUrl
          ? _self.pullsUrl
          : pullsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      releasesUrl: freezed == releasesUrl
          ? _self.releasesUrl
          : releasesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      stargazersUrl: freezed == stargazersUrl
          ? _self.stargazersUrl
          : stargazersUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      statusesUrl: freezed == statusesUrl
          ? _self.statusesUrl
          : statusesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      subscribersUrl: freezed == subscribersUrl
          ? _self.subscribersUrl
          : subscribersUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      subscriptionUrl: freezed == subscriptionUrl
          ? _self.subscriptionUrl
          : subscriptionUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      tagsUrl: freezed == tagsUrl
          ? _self.tagsUrl
          : tagsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      teamsUrl: freezed == teamsUrl
          ? _self.teamsUrl
          : teamsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      treesUrl: freezed == treesUrl
          ? _self.treesUrl
          : treesUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      templateRepository: freezed == templateRepository
          ? _self.templateRepository
          : templateRepository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      starredAt: freezed == starredAt
          ? _self.starredAt
          : starredAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      pushedAt: freezed == pushedAt
          ? _self.pushedAt
          : pushedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubLicenseValueCopyWith<$Res>? get license {
    if (_self.license == null) {
      return null;
    }

    return $GithubLicenseValueCopyWith<$Res>(_self.license!, (value) {
      return _then(_self.copyWith(license: value));
    });
  }

  /// Create a copy of GithubRepositoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubRepositoryPermissionValueCopyWith<$Res>? get permissions {
    if (_self.permissions == null) {
      return null;
    }

    return $GithubRepositoryPermissionValueCopyWith<$Res>(_self.permissions!,
        (value) {
      return _then(_self.copyWith(permissions: value));
    });
  }
}

// dart format on
