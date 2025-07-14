part of "/masamune_model_github.dart";

extension on Organization {
  GithubOrganizationModel toGithubOrganizationModel() {
    final organization = this;
    return GithubOrganizationModel(
      id: organization.id,
      name: organization.name,
      login: organization.login,
      company: organization.company,
      blog: organization.blog,
      location: organization.location,
      email: organization.email,
      publicReposCount: organization.publicReposCount ?? 0,
      publicGistsCount: organization.publicGistsCount ?? 0,
      followersCount: organization.followersCount ?? 0,
      followingCount: organization.followingCount ?? 0,
      htmlUrl: ModelUri.tryParse(organization.htmlUrl),
      avatarUrl: ModelImageUri.tryParse(organization.avatarUrl),
      createdAt: organization.createdAt != null
          ? ModelTimestamp(organization.createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: organization.updatedAt != null
          ? ModelTimestamp(organization.updatedAt!)
          : const ModelTimestamp.now(),
    );
  }
}

extension on User {
  GithubUserModel toGithubUserModel() {
    final user = this;
    return GithubUserModel(
      id: user.id,
      name: user.name,
      company: user.company,
      blog: user.blog,
      location: user.location,
      email: user.email,
      xUsername: user.twitterUsername,
      nodeId: user.nodeId,
      login: user.login,
      avatarUrl: ModelImageUri.tryParse(user.avatarUrl),
      htmlUrl: ModelUri.tryParse(user.htmlUrl),
      userUrl: ModelUri.tryParse(user.url),
      eventsUrl: ModelUri.tryParse(user.eventsUrl),
      followersUrl: ModelUri.tryParse(user.followersUrl),
      followingUrl: ModelUri.tryParse(user.followingUrl),
      gistsUrl: ModelUri.tryParse(user.gistsUrl),
      organizationsUrl: ModelUri.tryParse(user.organizationsUrl),
      receivedEventsUrl: ModelUri.tryParse(user.receivedEventsUrl),
      reposUrl: ModelUri.tryParse(user.reposUrl),
      starredUrl: ModelUri.tryParse(user.starredUrl),
      subscriptionsUrl: ModelUri.tryParse(user.subscriptionsUrl),
      starredAt:
          user.starredAt != null ? ModelTimestamp(user.starredAt!) : null,
      siteAdmin: user.siteAdmin ?? false,
      hirable: user.hirable ?? false,
      publicReposCount: user.publicReposCount ?? 0,
      publicGistsCount: user.publicGistsCount ?? 0,
      followersCount: user.followersCount ?? 0,
      followingCount: user.followingCount ?? 0,
      gravatarId: user.gravatarId,
      createdAt: user.createdAt != null
          ? ModelTimestamp(user.createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: user.updatedAt != null
          ? ModelTimestamp(user.updatedAt!)
          : const ModelTimestamp.now(),
    );
  }
}

extension on Repository {
  GithubRepositoryModel toGithubRepositoryModel(String organizationId) {
    final repository = this;
    return GithubRepositoryModel(
      id: repository.id,
      name: repository.name,
      fullName: repository.fullName,
      owner: repository.owner != null
          ? GithubUserModelRefPath(repository.owner!.id.toString())
          : null,
      organization: GithubOrganizationModelRefPath(organizationId),
      language: ModelLocale.tryParse(repository.language),
      isPrivate: repository.isPrivate,
      isFork: repository.isFork,
      isTemplate: repository.isTemplate ?? false,
      description: repository.description,
      masterBranch: repository.defaultBranch,
      nodeId: repository.nodeId,
      visibility: repository.visibility,
      topics: repository.topics ?? [],
      archived: repository.archived,
      disabled: repository.disabled,
      hasIssues: repository.hasIssues,
      hasWiki: repository.hasWiki,
      hasDownloads: repository.hasDownloads,
      hasPages: repository.hasPages,
      hasDiscussions: repository.hasDiscussions ?? false,
      hasProjects: repository.hasProjects ?? false,
      allowAutoMerge: repository.allowAutoMerge ?? false,
      allowForking: repository.allowForking ?? false,
      allowMergeCommit: repository.allowMergeCommit ?? false,
      allowRebaseMerge: repository.allowRebaseMerge ?? false,
      allowSquashMerge: repository.allowSquashMerge ?? false,
      allowUpdateBranch: repository.allowUpdateBranch ?? false,
      deleteBranchOnMerge: repository.deleteBranchOnMerge ?? false,
      webCommitSignoffRequired: repository.webCommitSignoffRequired ?? false,
      size: repository.size,
      stargazersCount: repository.stargazersCount,
      watchersCount: repository.watchersCount,
      forksCount: repository.forksCount,
      openIssuesCount: repository.openIssuesCount,
      subscribersCount: repository.subscribersCount,
      networkCount: repository.networkCount,
      htmlUrl: ModelUri.tryParse(repository.htmlUrl),
      cloneUrl: ModelUri.tryParse(repository.cloneUrl),
      sshUrl: ModelUri.tryParse(repository.sshUrl),
      svnUrl: ModelUri.tryParse(repository.svnUrl),
      gitUrl: ModelUri.tryParse(repository.gitUrl),
      homepageUrl: ModelUri.tryParse(repository.homepage),
      pushedAt: repository.pushedAt != null
          ? ModelTimestamp(repository.pushedAt!)
          : null,
      starredAt: repository.starredAt != null
          ? ModelTimestamp(repository.starredAt!)
          : null,
      createdAt: repository.createdAt != null
          ? ModelTimestamp(repository.createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: repository.updatedAt != null
          ? ModelTimestamp(repository.updatedAt!)
          : const ModelTimestamp.now(),
    );
  }
}

extension on IssueLabel {
  GithubLabelValue toGithubLabelValue() {
    return GithubLabelValue(
      name: name,
      color: color,
      description: description,
    );
  }
}

extension on ReactionRollup {
  GithubReactionValue toGithubReactionValue() {
    return GithubReactionValue(
      plusOne: plusOne,
      minusOne: minusOne,
      confused: confused,
      eyes: eyes,
      heart: heart,
      hooray: hooray,
      laugh: laugh,
      rocket: rocket,
      totalCount: totalCount ?? 0,
      url: url != null ? ModelUri.tryParse(url) : null,
    );
  }
}

extension on Issue {
  GithubIssueModel toGithubIssueModel() {
    final issue = this;
    return GithubIssueModel(
      id: issue.id,
      number: issue.number,
      title: issue.title,
      body: issue.body,
      state: issue.state,
      user: issue.user != null
          ? GithubUserModelRefPath(issue.user!.id.toString())
          : null,
      labels: issue.labels.map((e) => e.toGithubLabelValue()).toList(),
      reactions: issue.reactions?.toGithubReactionValue(),
      createdAt: issue.createdAt != null
          ? ModelTimestamp(issue.createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: issue.updatedAt != null
          ? ModelTimestamp(issue.updatedAt!)
          : const ModelTimestamp.now(),
      closedAt: issue.closedAt != null ? ModelTimestamp(issue.closedAt!) : null,
      closedBy: issue.closedBy != null
          ? GithubUserModelRefPath(issue.closedBy!.id.toString())
          : null,
      activeLockReason: issue.activeLockReason,
      authorAssociation: issue.authorAssociation,
      bodyHtml: issue.bodyHtml,
      bodyText: issue.bodyText,
      commentsUrl: ModelUri.tryParse(issue.commentsUrl),
      eventsUrl: ModelUri.tryParse(issue.eventsUrl),
      labelsUrl: ModelUri.tryParse(issue.labelsUrl),
      locked: issue.locked ?? false,
      nodeId: issue.nodeId,
      repository: issue.repository != null
          ? GithubRepositoryModelRefPath(
              issue.repository?.id.toString() ?? "",
              organizationId:
                  issue.repository?.organization?.id.toString() ?? "",
            )
          : null,
      repositoryUrl: ModelUri.tryParse(issue.repositoryUrl),
      stateReason: issue.stateReason,
      timelineUrl: ModelUri.tryParse(issue.timelineUrl),
      url: ModelUri.tryParse(issue.url),
      htmlUrl: ModelUri.tryParse(issue.htmlUrl),
    );
  }
}

extension on IssueComment {
  GithubIssueCommentModel toGithubIssueCommentModel() {
    return GithubIssueCommentModel(
      id: id,
      body: body,
      user: user != null ? GithubUserModelRefPath(user!.id.toString()) : null,
      url: ModelUri.tryParse(url),
      htmlUrl: ModelUri.tryParse(htmlUrl),
      issueUrl: ModelUri.tryParse(issueUrl),
      authorAssociation: authorAssociation,
      createdAt: createdAt != null
          ? ModelTimestamp(createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: updatedAt != null
          ? ModelTimestamp(updatedAt!)
          : const ModelTimestamp.now(),
    );
  }
}

extension on PullRequestHead {
  GithubPullRequestHeadValue toGithubPullRequestHeadValue() {
    return GithubPullRequestHeadValue(
      label: label,
      ref: ref,
      sha: sha,
      user: user != null ? GithubUserModelRefPath(user!.id.toString()) : null,
      repo: repo != null
          ? GithubRepositoryModelRefPath(
              repo!.id.toString(),
              organizationId: repo!.organization!.id.toString(),
            )
          : null,
    );
  }
}

extension on Milestone {
  GithubMilestoneValue toGithubMilestoneValue() {
    return GithubMilestoneValue(
      id: id,
      number: number,
      state: state,
      title: title,
      description: description,
      nodeId: nodeId,
      creator: creator != null
          ? GithubUserModelRefPath(creator!.id.toString())
          : null,
      openIssuesCount: openIssuesCount ?? 0,
      closedIssuesCount: closedIssuesCount ?? 0,
      url: ModelUri.tryParse(url),
      htmlUrl: ModelUri.tryParse(htmlUrl),
      labelsUrl: ModelUri.tryParse(labelsUrl),
      dueOn: dueOn != null ? ModelTimestamp(dueOn!) : null,
      closedAt: closedAt != null ? ModelTimestamp(closedAt!) : null,
      createdAt: createdAt != null
          ? ModelTimestamp(createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: updatedAt != null
          ? ModelTimestamp(updatedAt!)
          : const ModelTimestamp.now(),
    );
  }
}

extension on PullRequest {
  GithubPullRequestModel toGithubPullRequestModel() {
    final pullRequest = this;
    return GithubPullRequestModel(
      id: pullRequest.id,
      number: pullRequest.number,
      title: pullRequest.title,
      body: pullRequest.body,
      state: pullRequest.state,
      user: pullRequest.user != null
          ? GithubUserModelRefPath(pullRequest.user!.id.toString())
          : null,
      labels:
          pullRequest.labels?.map((e) => e.toGithubLabelValue()).toList() ?? [],
      head: pullRequest.head?.toGithubPullRequestHeadValue(),
      base: pullRequest.base?.toGithubPullRequestHeadValue(),
      milestone: pullRequest.milestone?.toGithubMilestoneValue(),
      repository: pullRequest.repo != null
          ? GithubRepositoryModelRefPath(
              pullRequest.repo!.id.toString(),
              organizationId: pullRequest.repo!.organization!.id.toString(),
            )
          : null,
      htmlUrl: ModelUri.tryParse(pullRequest.htmlUrl),
      diffUrl: ModelUri.tryParse(pullRequest.diffUrl),
      patchUrl: ModelUri.tryParse(pullRequest.patchUrl),
      closedAt: pullRequest.closedAt != null
          ? ModelTimestamp(pullRequest.closedAt!)
          : null,
      mergedAt: pullRequest.mergedAt != null
          ? ModelTimestamp(pullRequest.mergedAt!)
          : null,
      createdAt: pullRequest.createdAt != null
          ? ModelTimestamp(pullRequest.createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: pullRequest.updatedAt != null
          ? ModelTimestamp(pullRequest.updatedAt!)
          : const ModelTimestamp.now(),
    );
  }
}

extension on PullRequestComment {
  GithubPullRequestCommentModel toGithubPullRequestCommentModel() {
    return GithubPullRequestCommentModel(
      id: id,
      body: body,
      user: user != null ? GithubUserModelRefPath(user!.id.toString()) : null,
      url: ModelUri.tryParse(url),
      pullRequestUrl: ModelUri.tryParse(pullRequestUrl),
      createdAt: createdAt != null
          ? ModelTimestamp(createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: updatedAt != null
          ? ModelTimestamp(updatedAt!)
          : const ModelTimestamp.now(),
      diffHunk: diffHunk,
      path: path,
      position: position,
      originalPosition: originalPosition,
      commitId: commitId,
      originalCommitId: originalCommitId,
      links:
          ModelUri.tryParse(links?.html?.toString() ?? links?.git?.toString() ?? links?.self?.toString()),
    );
  }
}

/// Model adapter with GitHub available.
///
/// Obtain [token] from the GitHub API token and provide it.
///
/// All CRUD operations are available.
///
/// GitHubを利用できるようにしたモデルアダプター。
///
/// GitHubのAPIトークンから[token]を取得して与えてください。
///
/// すべてのCRUD操作が利用できます。
@immutable
class GithubModelAdapter extends ModelAdapter {
  /// Model adapter with GitHub available.
  ///
  /// Obtain [token] from the GitHub API token and provide it.
  ///
  /// All CRUD operations are available.
  ///
  /// GitHubを利用できるようにしたモデルアダプター。
  ///
  /// GitHubのAPIトークンから[token]を取得して与えてください。
  ///
  /// すべてのCRUD操作が利用できます。
  const GithubModelAdapter({
    required this.onRetrieveToken,
    GitHub? github,
  }) : _github = github;

  /// GitHub API token.
  ///
  /// GitHubのAPIトークンを取得します。
  final Future<String> Function() onRetrieveToken;

  Future<GitHub> _getInstance() async {
    if (_github != null) {
      return _github!;
    }
    if (_githubInstance != null) {
      return _githubInstance!;
    }
    final token = await onRetrieveToken();
    return _githubInstance =
        GitHub(auth: git_hub.Authentication.withToken(token));
  }

  final GitHub? _github;
  static GitHub? _githubInstance;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final github = await _getInstance();

    if (GithubOrganizationModel.document.hasMatchPath(query.query.path)) {
      final organizationId = query.query.path.split("/").last;
      final organization = await github.organizations.get(organizationId);
      return organization.toGithubOrganizationModel().toJson().toEntireJson();
    } else if (GithubUserModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubUserModel.document.regExp.firstMatch(query.query.path);
      final ownerId = match?.group(1);
      if (ownerId == null) {
        throw Exception("Invalid path for owner document load");
      }
      final owner = await github.users.getUser(ownerId);
      return owner.toGithubUserModel().toJson().toEntireJson();
    } else if (GithubRepositoryModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubRepositoryModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = query.query.path.split("/").last;
      if (organizationId == null) {
        throw Exception("Invalid path for repository document load");
      }
      final repository = await github.repositories
          .getRepository(RepositorySlug(organizationId, repositoryId));
      return repository
          .toGithubRepositoryModel(organizationId)
          .toJson()
          .toEntireJson();
    } else if (GithubIssueModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubIssueModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final issueId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null || repositoryId == null || issueId == null) {
        throw Exception("Invalid path for issue document load");
      }
      final issue = await github.issues.get(
        RepositorySlug(organizationId, repositoryId),
        issueId,
      );
      return issue.toGithubIssueModel().toJson().toEntireJson();
    } else if (GithubIssueCommentModel.document
        .hasMatchPath(query.query.path)) {
      final match =
          GithubIssueCommentModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final issueId = match?.group(3);
      final commentId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          issueId == null ||
          commentId == null) {
        throw Exception("Invalid path for issue comment document load");
      }
      final issue = await github.issues.getComment(
        RepositorySlug(organizationId, repositoryId),
        commentId,
      );
      return issue.toGithubIssueCommentModel().toJson().toEntireJson();
    } else if (GithubPullRequestModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubPullRequestModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final pullRequestId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          pullRequestId == null) {
        throw Exception("Invalid path for pull request document load");
      }
      final pullRequest = await github.pullRequests
          .get(
            RepositorySlug(organizationId, repositoryId),
            pullRequestId,
          )
          .then((value) => value.toGithubPullRequestModel());
      return pullRequest.toJson().toEntireJson();
    } else if (GithubPullRequestCommentModel.document
        .hasMatchPath(query.query.path)) {
      throw UnsupportedError(
          "Pull request comment document load is not supported");
    }
    throw UnsupportedError("Unsupported collection: ${query.query.path}");
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final github = await _getInstance();

    if (GithubOrganizationModel.document.hasMatchPath(query.query.path)) {
      throw UnsupportedError("Organization deletion is not supported");
    } else if (GithubUserModel.document.hasMatchPath(query.query.path)) {
      throw UnsupportedError("Owner deletion is not supported");
    } else if (GithubRepositoryModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubRepositoryModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = query.query.path.split("/").last;
      if (organizationId == null) {
        throw Exception("Invalid path for repository document deletion");
      }
      await github.repositories
          .deleteRepository(RepositorySlug(organizationId, repositoryId));
    } else if (GithubIssueModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubIssueModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final issueId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null || repositoryId == null || issueId == null) {
        throw Exception("Invalid path for issue document deletion");
      }
      await github.issues.edit(
        RepositorySlug(organizationId, repositoryId),
        issueId,
        IssueRequest(state: "closed"),
      );
    } else if (GithubPullRequestModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubPullRequestModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final pullRequestId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          pullRequestId == null) {
        throw Exception("Invalid path for pull request document deletion");
      }
      await github.pullRequests.edit(
        RepositorySlug(organizationId, repositoryId),
        pullRequestId,
        state: "closed",
      );
    }
    throw UnsupportedError("Unsupported collection: ${query.query.path}");
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {}

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final path = _parsePath(query.query.path);
    final Map<String, DynamicMap> result = {};

    switch (path.collection) {
      case "issue":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for issue collection");
        }
        final issues = await _github.issues
            .listByRepo(
              RepositorySlug(path.owner!, path.repository!),
              state: "all",
            )
            .toList();
        for (final issue in issues) {
          result[issue.number.toString()] = _convertIssueToMap(issue);
        }
        break;
      case "pull_request":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for pull request collection");
        }
        final prs = await _github.pullRequests
            .list(
              RepositorySlug(path.owner!, path.repository!),
              state: "all",
            )
            .toList();
        for (final pr in prs) {
          result[pr.number.toString()] = _convertPullRequestToMap(pr);
        }
        break;
      case "repository":
        if (path.owner == null) {
          throw ArgumentError("Invalid path for repository collection");
        }
        final repos = await _github.repositories
            .listUserRepositories(path.owner!)
            .toList();
        for (final repo in repos) {
          result[repo.name] = _convertRepositoryToMap(repo);
        }
        break;
      default:
        throw UnsupportedError("Unsupported collection: ${path.collection}");
    }

    return result;
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  ) async {
    switch (aggregateQuery.type) {
      case ModelAggregateQueryType.count:
        final collection = await loadCollection(query);
        final val = collection.length;
        if (val is! T) {
          return null;
        }
        return val as T;
      default:
        throw UnsupportedError("This aggregation function is not available.");
    }
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    final path = _parsePath(query.query.path);

    switch (path.collection) {
      case "issue":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for issue document save");
        }
        if (path.documentId == null) {
          // Create new issue
          await _github.issues.create(
            RepositorySlug(path.owner!, path.repository!),
            IssueRequest(
              title: value["title"] ?? "",
              body: value["body"] ?? "",
              labels: (value["labels"] as List?)?.cast<String>(),
            ),
          );
        } else {
          // Update existing issue
          await _github.issues.edit(
            RepositorySlug(path.owner!, path.repository!),
            int.parse(path.documentId!),
            IssueRequest(
              title: value["title"],
              body: value["body"],
              state: value["state"],
              labels: (value["labels"] as List?)?.cast<String>(),
            ),
          );
        }
        break;
      case "pull_request":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for pull request document save");
        }
        if (path.documentId == null) {
          // Create new pull request
          await _github.pullRequests.create(
            RepositorySlug(path.owner!, path.repository!),
            CreatePullRequest(
              value["title"] ?? "",
              value["head"] ?? "",
              value["base"] ?? "",
              body: value["body"],
            ),
          );
        } else {
          // Update existing pull request
          await _github.pullRequests.edit(
            RepositorySlug(path.owner!, path.repository!),
            int.parse(path.documentId!),
            title: value["title"],
            body: value["body"],
            state: value["state"],
          );
        }
        break;
      case "repository":
        // Repository creation/update is limited in GitHub API
        throw UnsupportedError("Repository save operation is not supported");
      default:
        throw UnsupportedError("Unsupported collection: ${path.collection}");
    }
  }

  @override
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("Batch operations are not supported.");
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) {
    throw UnsupportedError("Batch operations are not supported.");
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("Batch operations are not supported.");
  }

  @override
  Future<void> clearAll() {
    // GitHub doesn't support clearing all data
    throw UnsupportedError("Clear all operation is not supported.");
  }

  @override
  Future<void> clearCache() async {
    // No cache to clear
  }

  _GitHubPath _parsePath(String path) {
    final trimmedPath = path.trimQuery().trimString("/");
    final parts = trimmedPath.split("/");

    if (parts.isEmpty) {
      throw ArgumentError("Invalid path format");
    }

    final collection = parts[0];
    String? pathOwner = owner;
    String? pathRepository = repository;
    String? documentId;

    // Parse path based on collection type
    switch (collection) {
      case "issue":
      case "pull_request":
        if (parts.length >= 3) {
          pathOwner = parts[1];
          pathRepository = parts[2];
          if (parts.length >= 4) {
            documentId = parts[3];
          }
        } else if (parts.length == 2) {
          documentId = parts[1];
        }
        break;
      case "repository":
        if (parts.length >= 2) {
          pathOwner = parts[1];
          if (parts.length >= 3) {
            documentId = parts[2];
          }
        }
        break;
    }

    return _GitHubPath(
      collection: collection,
      owner: pathOwner,
      repository: pathRepository,
      documentId: documentId,
    );
  }

  DynamicMap _convertIssueToMap(Issue issue) {
    return {
      kUidFieldKey: issue.number.toString(),
      "id": issue.id,
      "number": issue.number,
      "title": issue.title,
      "body": issue.body,
      "state": issue.state,
      "user": {
        "id": issue.user?.id,
        "login": issue.user?.login,
        "avatar_url": issue.user?.avatarUrl,
      },
      "labels": issue.labels
          .map((label) => {
                "name": label.name,
                "color": label.color,
              })
          .toList(),
      "created_at": issue.createdAt?.toIso8601String(),
      "updated_at": issue.updatedAt?.toIso8601String(),
      "closed_at": issue.closedAt?.toIso8601String(),
    };
  }

  DynamicMap _convertPullRequestToMap(PullRequest pr) {
    return {
      kUidFieldKey: pr.number.toString(),
      "id": pr.id,
      "number": pr.number,
      "title": pr.title,
      "body": pr.body,
      "state": pr.state,
      "user": {
        "id": pr.user?.id,
        "login": pr.user?.login,
        "avatar_url": pr.user?.avatarUrl,
      },
      "head": {
        "ref": pr.head?.ref,
        "sha": pr.head?.sha,
      },
      "base": {
        "ref": pr.base?.ref,
        "sha": pr.base?.sha,
      },
      "created_at": pr.createdAt?.toIso8601String(),
      "updated_at": pr.updatedAt?.toIso8601String(),
      "merged_at": pr.mergedAt?.toIso8601String(),
    };
  }

  DynamicMap _convertRepositoryToMap(Repository repo) {
    return {
      kUidFieldKey: repo.name,
      "id": repo.id,
      "name": repo.name,
      "full_name": repo.fullName,
      "description": repo.description,
      "private": repo.isPrivate,
      "html_url": repo.htmlUrl,
      "clone_url": repo.cloneUrl,
      "ssh_url": repo.sshUrl,
      "owner": {
        "id": repo.owner?.id,
        "login": repo.owner?.login,
        "avatar_url": repo.owner?.avatarUrl,
      },
      "default_branch": repo.defaultBranch,
      "language": repo.language,
      "stargazers_count": repo.stargazersCount,
      "forks_count": repo.forksCount,
      "open_issues_count": repo.openIssuesCount,
      "created_at": repo.createdAt?.toIso8601String(),
      "updated_at": repo.updatedAt?.toIso8601String(),
      "pushed_at": repo.pushedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return onRetrieveToken.hashCode;
  }
}

@immutable
class _GitHubPath {
  const _GitHubPath({
    required this.collection,
    this.owner,
    this.repository,
    this.documentId,
  });

  final String collection;
  final String? owner;
  final String? repository;
  final String? documentId;
}
