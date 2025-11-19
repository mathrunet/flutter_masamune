part of "/masamune_model_github.dart";

const _kLocalDatabaseId = "github://";
const _kGitHubApiVersionHeader = "X-GitHub-Api-Version";
const _kGitHubApiVersion = "2022-11-28";
const _kGithubCopilotEndpoint = "https://api.githubcopilot.com";
const _kGithubEndpoint = "https://api.github.com";

extension on Organization {
  String? get uid {
    return login;
  }

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
      type: GithubOrganizationType.organization,
    );
  }
}

extension on GithubUserModel {
  GithubOrganizationModel toGithubOrganizationModel() {
    final user = this;
    return GithubOrganizationModel(
      id: user.id,
      name: user.name,
      login: user.login,
      company: user.company,
      blog: user.blog,
      location: user.location,
      email: user.email,
      publicReposCount: user.publicReposCount,
      publicGistsCount: user.publicGistsCount,
      followersCount: user.followersCount,
      followingCount: user.followingCount,
      htmlUrl: user.htmlUrl,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      type: GithubOrganizationType.user,
    );
  }
}

extension on UserInformation {
  String? get uid {
    return login;
  }
}

extension on User {
  String? get uid {
    return login;
  }

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
  String? get uid {
    return name;
  }

  GithubRepositoryModel toGithubRepositoryModel(String organizationId) {
    final repository = this;
    return GithubRepositoryModel(
      id: repository.id,
      name: repository.name,
      fullName: repository.fullName,
      owner: repository.owner != null
          ? GithubUserModelRefPath(repository.owner?.uid ?? "")
          : null,
      organization: GithubOrganizationModelRefPath(organizationId),
      language: repository.language,
      isPrivate: repository.isPrivate,
      isFork: repository.isFork,
      isTemplate: repository.isTemplate ?? false,
      description: repository.description,
      masterBranch: repository.defaultBranch.toUrlEncode(),
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
      fromServer: true,
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
  String? get uid {
    return number.toString();
  }

  GithubIssueModel toGithubIssueModel() {
    final issue = this;
    return GithubIssueModel(
      id: issue.id,
      number: issue.number,
      title: issue.title,
      body: issue.body,
      state: issue.state,
      assignee: issue.assignee?.toGithubUserModel(),
      assignees:
          issue.assignees?.mapAndRemoveEmpty((e) => e.toGithubUserModel()) ??
              [],
      user: issue.user?.toGithubUserModel(),
      labels: issue.labels.map((e) => e.toGithubLabelValue()).toList(),
      reactions: issue.reactions?.toGithubReactionValue(),
      createdAt: issue.createdAt != null
          ? ModelTimestamp(issue.createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: issue.updatedAt != null
          ? ModelTimestamp(issue.updatedAt!)
          : const ModelTimestamp.now(),
      closedAt: issue.closedAt != null ? ModelTimestamp(issue.closedAt!) : null,
      closedBy: issue.closedBy?.toGithubUserModel(),
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
              issue.repository?.uid ?? "",
              organizationId: issue.repository?.owner?.uid ?? "",
            )
          : null,
      repositoryUrl: ModelUri.tryParse(issue.repositoryUrl),
      stateReason: issue.stateReason,
      timelineUrl: ModelUri.tryParse(issue.timelineUrl),
      url: ModelUri.tryParse(issue.url),
      htmlUrl: ModelUri.tryParse(issue.htmlUrl),
      fromServer: true,
    );
  }
}

extension on IssueComment {
  String? get uid {
    return id?.toString();
  }

  GithubIssueTimelineModel toGithubIssueTimelineModel() {
    return GithubIssueTimelineModel(
      id: id,
      body: body,
      user: user?.toGithubUserModel(),
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
      fromServer: true,
    );
  }

  GithubPullRequestTimelineModel toGithubPullRequestTimelineModel() {
    return GithubPullRequestTimelineModel(
      id: id,
      body: body,
      user: user?.toGithubUserModel(),
      url: ModelUri.tryParse(url),
      createdAt: createdAt != null
          ? ModelTimestamp(createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: updatedAt != null
          ? ModelTimestamp(updatedAt!)
          : const ModelTimestamp.now(),
      fromServer: true,
    );
  }
}

extension on TimelineEvent {
  String? get uid {
    return id.toString();
  }

  GithubIssueTimelineModel toGithubIssueTimelineModel() {
    final timelineEvent = GithubTimelineEvent.fromString(event);
    return timelineEvent.toGithubIssueTimelineModelFromTimelineEvent(this);
  }
}

extension on ProjectCard {
  GithubProjectModel toGithubProjectEventValue() {
    return GithubProjectModel(
      id: projectId,
      name: columnName,
      previousName: previousColumnName,
      projectUrl: ModelUri.tryParse(projectUrl),
      url: ModelUri.tryParse(url),
    );
  }
}

extension on PullRequestHead {
  GithubPullRequestHeadValue toGithubPullRequestHeadValue() {
    return GithubPullRequestHeadValue(
      label: label,
      ref: ref,
      sha: sha,
      user: user != null ? GithubUserModelRefPath(user?.uid ?? "") : null,
      repo: repo != null
          ? GithubRepositoryModelRefPath(
              repo!.uid ?? "",
              organizationId: repo!.owner?.uid ?? "",
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
      creator:
          creator != null ? GithubUserModelRefPath(creator?.uid ?? "") : null,
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
  String? get uid {
    return number?.toString();
  }

  GithubPullRequestModel toGithubPullRequestModel() {
    final pullRequest = this;
    return GithubPullRequestModel(
      id: pullRequest.id,
      number: pullRequest.number,
      title: pullRequest.title,
      body: pullRequest.body,
      state: pullRequest.state,
      user: pullRequest.user != null
          ? GithubUserModelRefPath(pullRequest.user?.uid ?? "")
          : null,
      labels:
          pullRequest.labels?.map((e) => e.toGithubLabelValue()).toList() ?? [],
      head: pullRequest.head?.toGithubPullRequestHeadValue(),
      base: pullRequest.base?.toGithubPullRequestHeadValue(),
      milestone: pullRequest.milestone?.toGithubMilestoneValue(),
      repository: pullRequest.repo != null
          ? GithubRepositoryModelRefPath(
              pullRequest.repo!.uid ?? "",
              organizationId: pullRequest.repo!.owner?.uid ?? "",
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
      fromServer: true,
    );
  }
}

extension on CommitData {
  GithubCommitModel toGithubCommitModel() {
    return GithubCommitModel(
      sha: sha,
      message: commit?.message,
      commentCount: commit?.commentCount ?? 0,
      url: ModelUri.tryParse(url),
      htmlUrl: ModelUri.tryParse(htmlUrl),
      commentsUrl: ModelUri.tryParse(commentsUrl),
      author: author != null ? GithubUserModelRefPath(author?.uid ?? "") : null,
      committer: committer != null
          ? GithubUserModelRefPath(committer?.uid ?? "")
          : null,
      parents:
          commit?.parents?.mapAndRemoveEmpty((e) => e.toGithubCommitModel()) ??
              [],
      fromServer: true,
    );
  }
}

extension on CommitDataUser {
  String? get uid {
    return login;
  }
}

extension on GitCommit {
  GithubCommitModel toGithubCommitModel() {
    return GithubCommitModel(
      sha: sha,
      url: ModelUri.tryParse(url),
      message: message,
      commentCount: commentCount ?? 0,
      parents: parents?.mapAndRemoveEmpty((e) => e.toGithubCommitModel()) ?? [],
      fromServer: true,
    );
  }
}

extension on Branch {
  String? get uid {
    return name?.toUrlEncode();
  }

  GithubBranchModel toGithubBranchModel() {
    return GithubBranchModel(
      name: name,
      commit: commit?.toGithubCommitModel(),
      fromServer: true,
    );
  }
}

extension on CommitFile {
  GithubContentModel toGithubContentModel() {
    return GithubContentModel(
      name: name,
      status: status,
      patch: patch,
      additionsCount: additions ?? 0,
      deletionsCount: deletions ?? 0,
      changesCount: changes ?? 0,
      rawUrl: ModelUri.tryParse(rawUrl),
      blobUrl: ModelUri.tryParse(blobUrl),
      fromServer: true,
    );
  }
}

extension on RepositoryCommit {
  GithubCommitModel toGithubCommitModel() {
    return GithubCommitModel(
      sha: sha,
      url: ModelUri.tryParse(url),
      htmlUrl: ModelUri.tryParse(htmlUrl),
      commentsUrl: ModelUri.tryParse(commentsUrl),
      author: author != null ? GithubUserModelRefPath(author?.uid ?? "") : null,
      committer: committer != null
          ? GithubUserModelRefPath(committer?.uid ?? "")
          : null,
      authorDate: commit?.author?.date != null
          ? ModelTimestamp(commit!.author!.date!)
          : null,
      committerDate: commit?.committer?.date != null
          ? ModelTimestamp(commit!.committer!.date!)
          : null,
      additionsCount: stats?.additions ?? 0,
      deletionsCount: stats?.deletions ?? 0,
      totalCount: stats?.total ?? 0,
      parents: parents?.mapAndRemoveEmpty((e) => e.toGithubCommitModel()) ?? [],
      contents: files?.map((e) => e.toGithubContentModel()).toList() ?? [],
      message: commit?.message,
      fromServer: true,
    );
  }
}

extension on GitHubFile {
  String? get uid {
    return sha;
  }

  GithubContentModel toGithubContentModel() {
    return GithubContentModel(
      name: name,
      path: path,
      content: content,
      sha: sha,
      type: type,
      encoding: encoding,
      size: size ?? 0,
      htmlUrl: ModelUri.tryParse(htmlUrl),
      gitUrl: ModelUri.tryParse(gitUrl),
      downloadUrl: ModelUri.tryParse(downloadUrl),
      fromServer: true,
    );
  }
}

extension on RepositoryContents {
  GithubContentModel toGithubContentModel() {
    return GithubContentModel(
      name: file?.name,
      path: file?.path,
      content: file?.content,
      sha: file?.sha,
      type: file?.type,
      encoding: file?.encoding,
      size: file?.size ?? 0,
      htmlUrl: ModelUri.tryParse(file?.htmlUrl),
      gitUrl: ModelUri.tryParse(file?.gitUrl),
      downloadUrl: ModelUri.tryParse(file?.downloadUrl),
      children: tree?.map((e) => e.toGithubContentModel()).toList(),
      fromServer: true,
    );
  }
}

extension on DynamicMap {
  GithubCompareModel toGithubCompareModel() {
    // Parse merge_base_commit
    final mergeBaseCommitJson = getAsMap("merge_base_commit");
    final mergeBaseCommit = mergeBaseCommitJson.toGithubCommitModel();

    // Parse base_commit
    final baseCommitJson = getAsMap("base_commit");
    final baseCommit = baseCommitJson.toGithubCommitModel();

    // Parse commits array
    final commitsJson = getAsList<DynamicMap>("commits");
    final commits = commitsJson.map((e) => e.toGithubCommitModel()).toList();

    return GithubCompareModel(
      status: get("status", nullOfString),
      aheadBy: getAsInt("ahead_by", 0),
      behindBy: getAsInt("behind_by", 0),
      totalCommits: getAsInt("total_commits", 0),
      mergeBaseCommit: mergeBaseCommit,
      baseCommit: baseCommit,
      commits: commits,
      diffUrl: ModelUri.tryParse(get("diff_url", nullOfString)),
      patchUrl: ModelUri.tryParse(get("patch_url", nullOfString)),
      htmlUrl: ModelUri.tryParse(get("html_url", nullOfString)),
      permalinkUrl: ModelUri.tryParse(get("permalink_url", nullOfString)),
      fromServer: true,
    );
  }

  GithubActionsModel toGithubActionsModel({
    required String organizationId,
    required String repositoryId,
  }) {
    final actorJson = getAsMap("actor");
    final triggeringActorJson = getAsMap("triggering_actor");
    final actor = actorJson.isEmpty ? null : actorJson.toGithubUserModel();
    final triggeringActor = triggeringActorJson.isEmpty
        ? null
        : triggeringActorJson.toGithubUserModel();
    return GithubActionsModel(
      id: get("id", nullOfNum)?.toInt(),
      workflowId: get("workflow_id", nullOfNum)?.toInt(),
      runNumber: get("run_number", nullOfNum)?.toInt(),
      runAttempt: get("run_attempt", nullOfNum)?.toInt(),
      name: get("name", nullOfString),
      displayTitle: get("display_title", nullOfString),
      event: get("event", nullOfString),
      status: get("status", nullOfString),
      conclusion: get("conclusion", nullOfString),
      headBranch: get("head_branch", nullOfString),
      headSha: get("head_sha", nullOfString),
      path: get("path", nullOfString),
      actor: actor,
      triggeringActor: triggeringActor,
      repository: GithubRepositoryModelRefPath(
        repositoryId,
        organizationId: organizationId,
      ),
      url: ModelUri.tryParse(get("url", nullOfString)),
      htmlUrl: ModelUri.tryParse(get("html_url", nullOfString)),
      jobsUrl: ModelUri.tryParse(get("jobs_url", nullOfString)),
      logsUrl: ModelUri.tryParse(get("logs_url", nullOfString)),
      artifactsUrl: ModelUri.tryParse(get("artifacts_url", nullOfString)),
      cancelUrl: ModelUri.tryParse(get("cancel_url", nullOfString)),
      rerunUrl: ModelUri.tryParse(get("rerun_url", nullOfString)),
      workflowUrl: ModelUri.tryParse(get("workflow_url", nullOfString)),
      checkSuiteUrl: ModelUri.tryParse(get("check_suite_url", nullOfString)),
      previousAttemptUrl:
          ModelUri.tryParse(get("previous_attempt_url", nullOfString)),
      runStartedAt: ModelTimestamp.tryParse(get("run_started_at", "")),
      createdAt: ModelTimestamp.tryParse(get("created_at", "")) ??
          const ModelTimestamp.now(),
      updatedAt: ModelTimestamp.tryParse(get("updated_at", "")) ??
          const ModelTimestamp.now(),
      fromServer: true,
    );
  }

  GithubActionsJobModel toGithubActionsJobModel({
    required String organizationId,
    required String repositoryId,
  }) {
    final runnerJson = getAsMap("runner");
    final runner = runnerJson.isEmpty ? null : runnerJson.toGithubUserModel();
    final steps = getAsList<DynamicMap>("steps")
        .map((e) => e.toGithubActionsStepValue())
        .toList();
    return GithubActionsJobModel(
      id: get("id", nullOfNum)?.toInt(),
      runId: get("run_id", nullOfNum)?.toInt(),
      runAttempt: get("run_attempt", nullOfNum)?.toInt(),
      name: get("name", nullOfString),
      runnerName: get("runner_name", nullOfString),
      runnerId: get("runner_id", nullOfNum)?.toInt(),
      runnerGroupId: get("runner_group_id", nullOfNum)?.toInt(),
      status: get("status", nullOfString),
      conclusion: get("conclusion", nullOfString),
      labels: getAsList<String>("labels"),
      runner: runner,
      steps: steps,
      url: ModelUri.tryParse(get("url", nullOfString)),
      htmlUrl: ModelUri.tryParse(get("html_url", nullOfString)),
      logsUrl: ModelUri.tryParse(get("logs_url", nullOfString)),
      startedAt: ModelTimestamp.tryParse(get("started_at", "")),
      completedAt: ModelTimestamp.tryParse(get("completed_at", "")),
      fromServer: true,
    );
  }

  GithubUserModel toGithubUserModel() {
    return GithubUserModel(
      id: get("id", nullOfNum)?.toInt(),
      login: get("login", nullOfString),
      avatarUrl: ModelImageUri.tryParse(get("avatar_url", nullOfString)),
      htmlUrl: ModelUri.tryParse(get("html_url", nullOfString)),
      siteAdmin: get("site_admin", false),
      name: get("name", nullOfString),
      company: get("company", nullOfString),
      blog: get("blog", nullOfString),
      location: get("location", nullOfString),
      email: get("email", nullOfString),
      hirable: get("hirable", false),
      bio: get("bio", nullOfString),
      publicReposCount: getAsInt("public_repos", 0),
      publicGistsCount: getAsInt("public_gists", 0),
      followersCount: getAsInt("followers", 0),
      followingCount: getAsInt("following", 0),
      createdAt: ModelTimestamp.tryParse(get("created_at", "")) ??
          const ModelTimestamp.now(),
      updatedAt: ModelTimestamp.tryParse(get("updated_at", "")) ??
          const ModelTimestamp.now(),
      eventsUrl: ModelUri.tryParse(get("events_url", nullOfString)),
      followersUrl: ModelUri.tryParse(get("followers_url", nullOfString)),
      followingUrl: ModelUri.tryParse(get("following_url", nullOfString)),
      gistsUrl: ModelUri.tryParse(get("gists_url", nullOfString)),
      gravatarId: get("gravatar_id", nullOfString),
      nodeId: get("node_id", nullOfString),
      organizationsUrl:
          ModelUri.tryParse(get("organizations_url", nullOfString)),
      receivedEventsUrl:
          ModelUri.tryParse(get("received_events_url", nullOfString)),
      reposUrl: ModelUri.tryParse(get("repos_url", nullOfString)),
      starredAt: ModelTimestamp.tryParse(get("starred_at", "")),
      starredUrl: ModelUri.tryParse(get("starred_url", nullOfString)),
      subscriptionsUrl:
          ModelUri.tryParse(get("subscriptions_url", nullOfString)),
      type: get("type", nullOfString),
      userUrl: ModelUri.tryParse(get("url", nullOfString)),
      xUsername: get("twitter_username", nullOfString),
    );
  }

  GithubActionsStepValue toGithubActionsStepValue() {
    return GithubActionsStepValue(
      number: get("number", nullOfNum)?.toInt(),
      name: get("name", nullOfString),
      status: get("status", nullOfString),
      conclusion: get("conclusion", nullOfString),
      startedAt: ModelTimestamp.tryParse(get("started_at", "")),
      completedAt: ModelTimestamp.tryParse(get("completed_at", "")),
    );
  }

  GithubCommitModel toGithubCommitModel() {
    final commit = getAsMap("commit");
    final author = getAsMap("author");
    final committer = getAsMap("committer");
    final parents = getAsList<DynamicMap>("parents");
    final authorDate = commit.getAsMap("author").get("date", nullOfString);
    final committerDate =
        commit.getAsMap("committer").get("date", nullOfString);
    final stats = getAsMap("stats");
    final files = getAsList<DynamicMap>("files");
    return GithubCommitModel(
      sha: get("sha", nullOfString),
      message: commit.get("message", nullOfString),
      url: ModelUri.tryParse(get("url", nullOfString)),
      htmlUrl: ModelUri.tryParse(get("html_url", nullOfString)),
      commentsUrl: ModelUri.tryParse(get("comments_url", nullOfString)),
      author: author.isNotEmpty
          ? GithubUserModelRefPath(author.get("login", nullOfString) ?? "")
          : null,
      committer: committer.isNotEmpty
          ? GithubUserModelRefPath(committer.get("login", nullOfString) ?? "")
          : null,
      authorDate:
          authorDate != null ? ModelTimestamp.tryParse(authorDate) : null,
      committerDate:
          committerDate != null ? ModelTimestamp.tryParse(committerDate) : null,
      commentCount: commit.getAsInt("comment_count", 0),
      additionsCount: stats.getAsInt("additions", 0),
      deletionsCount: stats.getAsInt("deletions", 0),
      totalCount: stats.getAsInt("total", 0),
      parents: parents.mapAndRemoveEmpty((e) => e.toGithubCommitModel()),
      contents: files.map((e) => e.toGithubContentModel()).toList(),
      fromServer: true,
    );
  }

  GithubContentModel toGithubContentModel() {
    return GithubContentModel(
      name: get("filename", nullOfString),
      additionsCount: getAsInt("additions"),
      deletionsCount: getAsInt("deletions"),
      changesCount: getAsInt("changes"),
      status: get("status", nullOfString),
      rawUrl: ModelUri.tryParse(get("raw_url", nullOfString)),
      blobUrl: ModelUri.tryParse(get("blob_url", nullOfString)),
      patch: get("patch", nullOfString),
      sha: get("sha", nullOfString),
      type: get("type", nullOfString),
    );
  }

  GithubCopilotSessionModel toGithubCopilotSessionModel() {
    final createdAt = get("created_at", nullOfString);
    final updatedAt = get("updated_at", nullOfString);
    final completedAt = get("completed_at", nullOfString);
    final error = getAsMap("error");
    final pullRequest = getAsMap("pull_request");

    return GithubCopilotSessionModel(
      id: get("id", ""),
      status: GithubCopilotSessionStatus.fromString(get("state", "unknown")),
      name: get("name", nullOfString),
      resourceType: get("resource_type", nullOfString),
      resourceId: get("resource_id", nullOfString),
      userId: get("user_id", nullOfString),
      agentId: get("agent_id", nullOfString),
      createdAt: createdAt != null
          ? ModelTimestamp.tryParse(createdAt) ?? const ModelTimestamp.now()
          : const ModelTimestamp.now(),
      updatedAt: updatedAt != null
          ? ModelTimestamp.tryParse(updatedAt) ?? const ModelTimestamp.now()
          : const ModelTimestamp.now(),
      completedAt: completedAt != null
          ? ModelTimestamp.tryParse(completedAt) ?? const ModelTimestamp.now()
          : null,
      errorMessage: error.get("message", nullOfString),
      errorCode: error.get("code", nullOfString),
      pullRequestNumber: pullRequest.get("number", nullOfNum)?.toInt(),
      pullRequestUrl: pullRequest.get("url", nullOfString),
      pullRequestId: pullRequest.get("id", nullOfString),
      pullRequestBaseRef: pullRequest.get("base_ref", nullOfString),
    );
  }

  GithubCopilotSessionLogModel toGithubCopilotSessionLogModel(
      {required String sessionId}) {
    final timestamp = get("timestamp", nullOfString);
    return GithubCopilotSessionLogModel(
      id: get("id", ""),
      sessionId: sessionId,
      message: get("message", ""),
      level: GithubCopilotSessionLogLevel.fromString(get("level", "unknown")),
      timestamp: timestamp != null
          ? ModelTimestamp.tryParse(timestamp) ?? const ModelTimestamp.now()
          : const ModelTimestamp.now(),
      metadata: getAsMap("metadata"),
      toolName: get("tool_name", nullOfString),
      toolResult: get("tool_result", nullOfString),
    );
  }
}

extension on List<int> {
  List<GithubActionsLogModel> toGithubActionsLogModelList({
    required int runId,
    required int jobId,
    required String downloadUrl,
  }) {
    final logs = <GithubActionsLogModel>[];
    const timestamp = ModelTimestamp.now();
    if (_isZipArchive()) {
      final archive = ZipDecoder().decodeBytes(this, verify: false);
      var index = 0;
      for (final file in archive.files) {
        if (!file.isFile) {
          continue;
        }
        final content = file.content;
        final data = convert.utf8.decode(content, allowMalformed: true);
        logs.add(
          GithubActionsLogModel(
            runId: runId,
            jobId: jobId,
            chunk: index,
            name: file.name,
            downloadUrl: ModelUri.tryParse(downloadUrl),
            text: data,
            createdAt: timestamp,
            fromServer: true,
          ),
        );
        index++;
      }
      if (logs.isEmpty) {
        logs.add(
          GithubActionsLogModel(
            runId: runId,
            jobId: jobId,
            chunk: 0,
            downloadUrl: ModelUri.tryParse(downloadUrl),
            text: "",
            createdAt: timestamp,
            fromServer: true,
          ),
        );
      }
      return logs;
    }
    final decodedBytes =
        _isGzipCompressed() ? const GZipDecoder().decodeBytes(this) : this;
    final text = convert.utf8.decode(decodedBytes, allowMalformed: true);
    logs.add(
      GithubActionsLogModel(
        runId: runId,
        jobId: jobId,
        chunk: 0,
        downloadUrl: ModelUri.tryParse(downloadUrl),
        text: text,
        createdAt: timestamp,
        fromServer: true,
      ),
    );
    return logs;
  }

  bool _isZipArchive() {
    final bytes = this;
    return bytes.length >= 4 &&
        bytes[0] == 0x50 &&
        bytes[1] == 0x4B &&
        bytes[2] == 0x03 &&
        bytes[3] == 0x04;
  }

  bool _isGzipCompressed() {
    final bytes = this;
    return bytes.length >= 2 && bytes[0] == 0x1F && bytes[1] == 0x8B;
  }
}

/// Model adapter with GitHub available.
///
/// Please provide a GitHub API token using [onRetrieveToken].
///
/// GitHubを利用できるようにしたモデルアダプター。
///
/// [onRetrieveToken]を利用してGitHubのAPIトークンを与えてください。
@immutable
class GithubModelAdapter extends ModelAdapter {
  /// Model adapter with GitHub available.
  ///
  /// Please provide a GitHub API token using [onRetrieveToken].
  ///
  /// GitHubを利用できるようにしたモデルアダプター。
  ///
  /// [onRetrieveToken]を利用してGitHubのAPIトークンを与えてください。
  const GithubModelAdapter({
    required this.onRetrieveToken,
    NoSqlDatabase? database,
    GitHub? github,
    this.useLocalDatabase = true,
    this.commitsDuration = const Duration(days: 90),
  })  : _github = github,
        _database = database;

  /// GitHub API token.
  ///
  /// GitHubのAPIトークンを取得します。
  final Future<String?> Function() onRetrieveToken;

  /// Use local database.
  ///
  /// ローカルデータベースを使用します。
  final bool useLocalDatabase;

  /// Commits duration.
  ///
  /// 取得するコミットの期間。
  final Duration commitsDuration;

  @override
  VectorConverter get vectorConverter => const PassVectorConverter();

  /// Designated database. Please use for testing purposes, etc.
  ///
  /// 指定のデータベース。テスト用途などにご利用ください。
  NoSqlDatabase get database {
    final database = _database ??
        (useLocalDatabase ? sharedLocalDatabase : sharedRuntimeDatabase);
    return database;
  }

  final NoSqlDatabase? _database;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedRuntimeDatabase = NoSqlDatabase();

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedLocalDatabase = NoSqlDatabase(
    onInitialize: (database) async {
      try {
        database.data = await DatabaseExporter.import(
          "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        );
      } catch (e) {
        database.data = {};
      }
    },
    onSaved: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onDeleted: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onClear: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        {},
      );
    },
  );

  Future<GitHub> _getInstance() async {
    if (_github != null) {
      return _github!;
    }
    final token = await onRetrieveToken();
    if (_githubInstance != null && _accessToken == token) {
      return _githubInstance!;
    }
    _accessToken = token;
    return _githubInstance =
        GitHub(auth: git_hub.Authentication.withToken(token));
  }

  final GitHub? _github;
  static GitHub? _githubInstance;
  static String? _accessToken;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final res = await database.loadDocument(query);
    if (!query.reload && res != null) {
      return res;
    }
    final github = await _getInstance();

    if (GithubOrganizationModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final organizationId = query.query.path.split("/").last;
      final userQuery = ModelAdapterDocumentQuery(
          query: GithubUserModel.document(organizationId).modelQuery);
      final userRes = await database.loadDocument(userQuery);
      if (userRes != null) {
        final res = GithubUserModel.fromJson(userRes)
            .toGithubOrganizationModel()
            .toJson()
            .toEntireJson();
        await database.syncDocument(query, res);
        return res;
      } else {
        final currentUser = await github.users.getCurrentUser();
        if (currentUser.uid == organizationId) {
          final githubUser = currentUser.toGithubUserModel();
          await database.syncDocument(
            userQuery,
            githubUser.toJson().toEntireJson(),
          );
          final res =
              githubUser.toGithubOrganizationModel().toJson().toEntireJson();
          await database.syncDocument(query, res);
          return res;
        }
      }
      final organization = await github.organizations.get(organizationId);
      final res =
          organization.toGithubOrganizationModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubUserModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final ownerId = query.query.path.split("/").last;
      final owner = await github.users.getUser(ownerId);
      final res = owner.toGithubUserModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubRepositoryModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubRepositoryModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = query.query.path.split("/").last;
      if (organizationId == null) {
        throw Exception("Invalid path for repository document load");
      }
      final repository = await github.repositories
          .getRepository(RepositorySlug(organizationId, repositoryId));
      final res = repository
          .toGithubRepositoryModel(organizationId)
          .toJson()
          .toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubActionsModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubActionsModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final actionId = int.tryParse(match?.group(3) ?? "");
      if (organizationId == null || repositoryId == null || actionId == null) {
        throw Exception("Invalid path for actions document load");
      }
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Access token is not available");
      }
      final response = await Api.get(
        "$_kGithubEndpoint/repos/$organizationId/$repositoryId/actions/runs/$actionId",
        headers: {
          "Authorization": "Bearer $accessToken",
          _kGitHubApiVersionHeader: _kGitHubApiVersion,
          "Accept": "application/vnd.github+json",
        },
      );
      if (!response.statusCode.toString().startsWith("2")) {
        throw Exception(
            "Failed to load actions document: ${response.statusCode}");
      }
      final json = jsonDecodeAsMap(response.body);
      final res = json
          .toGithubActionsModel(
              organizationId: organizationId, repositoryId: repositoryId)
          .toJson()
          .toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubActionsJobModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubActionsJobModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final actionId = int.tryParse(match?.group(3) ?? "");
      final jobId = int.tryParse(match?.group(4) ?? "");
      if (organizationId == null ||
          repositoryId == null ||
          actionId == null ||
          jobId == null) {
        throw Exception("Invalid path for actions job document load");
      }
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Access token is not available");
      }
      final response = await Api.get(
        "$_kGithubEndpoint/repos/$organizationId/$repositoryId/actions/jobs/$jobId",
        headers: {
          "Authorization": "Bearer $accessToken",
          _kGitHubApiVersionHeader: _kGitHubApiVersion,
          "Accept": "application/vnd.github+json",
        },
      );
      if (!response.statusCode.toString().startsWith("2")) {
        throw Exception(
            "Failed to load actions job document: ${response.statusCode}");
      }
      final json = jsonDecodeAsMap(response.body);
      json["run_id"] ??= actionId;
      final res = json
          .toGithubActionsJobModel(
              organizationId: organizationId, repositoryId: repositoryId)
          .toJson()
          .toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubActionsLogModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubActionsLogModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final actionId = int.tryParse(match?.group(3) ?? "");
      final jobId = int.tryParse(match?.group(4) ?? "");
      final chunkId = match?.group(5);
      if (organizationId == null ||
          repositoryId == null ||
          actionId == null ||
          jobId == null ||
          chunkId == null) {
        throw Exception("Invalid path for actions log document load");
      }
      final logs = await _fetchGithubActionsLogs(
        organizationId: organizationId,
        repositoryId: repositoryId,
        runId: actionId,
        jobId: jobId,
      );
      final log = logs[chunkId];
      if (log == null) {
        throw Exception("Log chunk not found");
      }
      await database.syncDocument(query, log);
      return log;
    } else if (GithubIssueModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
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
      final res = issue.toGithubIssueModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubIssueTimelineModel.document
        .hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubIssueTimelineModel.document.regExp.firstMatch(query.query.path);
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
      final res = issue.toGithubIssueTimelineModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubPullRequestModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
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
      final pullRequest = await github.pullRequests.get(
        RepositorySlug(organizationId, repositoryId),
        pullRequestId,
      );
      final res =
          pullRequest.toGithubPullRequestModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubPullRequestTimelineModel.document
        .hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match = GithubPullRequestTimelineModel.document.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final pullRequestId = match?.group(3);
      final commentId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          pullRequestId == null ||
          commentId == null) {
        throw Exception("Invalid path for pull request comment document load");
      }
      final issue = await github.issues.getComment(
        RepositorySlug(organizationId, repositoryId),
        commentId,
      );
      final res =
          issue.toGithubPullRequestTimelineModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubBranchModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubBranchModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = query.query.path.split("/").last.fromUrlEncode();
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for branch document load");
      }
      final branch = await github.repositories.getBranch(
        RepositorySlug(organizationId, repositoryId),
        branchId,
      );
      final res = branch.toGithubBranchModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubCommitModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubCommitModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = match?.group(3)?.fromUrlEncode();
      final commitId = query.query.path.split("/").last;
      if (organizationId == null || repositoryId == null || branchId == null) {
        throw Exception("Invalid path for commit document load");
      }
      final commit = await github.repositories.getCommit(
        RepositorySlug(organizationId, repositoryId),
        commitId,
      );
      final res = commit.toGithubCommitModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubContentModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubContentModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = match?.group(3)?.fromUrlEncode();
      final commitId = match?.group(4);
      final pathId = match?.group(5);
      final contentId = query.query.path.split("/").last;
      if (organizationId == null ||
          repositoryId == null ||
          branchId == null ||
          commitId == null) {
        throw Exception("Invalid path for content document load");
      }
      final path = Uri.decodeComponent(pathId ?? "").trimString("/");
      final contentPath = Uri.decodeComponent(contentId).trimString("/");
      final contents = await github.repositories.getContents(
        RepositorySlug(organizationId, repositoryId),
        "$path/$contentPath",
      );
      final res = contents.toGithubContentModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    } else if (GithubCopilotSessionModel.document
        .hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match = GithubCopilotSessionModel.document.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final sessionId = query.query.path.split("/").last;
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for copilot session document load");
      }
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Failed to get access token");
      }
      final session = await Api.get(
        "$_kGithubCopilotEndpoint/agents/resource/repository/$repositoryId",
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
          "Copilot-Integration-Id": "copilot-4-cli",
        },
      );
      final json = jsonDecodeAsMap(session.body);
      final sessions = json.getAsList<DynamicMap>("sessions");
      final doc = sessions
          .firstWhereOrNull((e) => e.get("id", nullOfString) == sessionId);
      final res = doc?.toGithubCopilotSessionModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res ?? {};
    } else if (GithubCompareModel.document.hasMatchPath(query.query.path)) {
      final cachedRes = await database.loadDocument(query);
      if (cachedRes != null && !query.reload) {
        return cachedRes;
      }
      final match =
          GithubCompareModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final compareId = query.query.path.split("/").last;
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for compare document load");
      }
      // compareId is in the format "base...head"
      final compareParts = compareId.split("...");
      if (compareParts.length != 2) {
        throw Exception(
            "Invalid compare format. Expected 'base...head', got: $compareId");
      }
      final base = compareParts[0].fromUrlEncode();
      final head = compareParts[1].fromUrlEncode();

      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Failed to get access token");
      }

      final result = await Api.get(
        "$_kGithubEndpoint/repos/$organizationId/$repositoryId/compare/$base...$head",
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (!result.statusCode.toString().startsWith("2")) {
        throw Exception("Failed to compare branches: ${result.statusCode}");
      }

      final json = jsonDecodeAsMap(result.body);
      final res = json.toGithubCompareModel().toJson().toEntireJson();
      await database.syncDocument(query, res);
      return res;
    }
    throw UnsupportedError("Unsupported document: ${query.query.path}");
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final github = await _getInstance();

    if (GithubOrganizationModel.collection.hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final organizations = github.organizations.list();
      res = (await organizations.map((e) => e).toList()).toMap((e) {
        final id = e.uid;
        if (id == null) {
          return null;
        }
        return MapEntry(
          id,
          e.toGithubOrganizationModel().toJson().toEntireJson(),
        );
      });
      final currentUser = await github.users.getCurrentUser();
      res = {
        currentUser.uid ?? "": currentUser
            .toGithubUserModel()
            .toGithubOrganizationModel()
            .toJson()
            .toEntireJson(),
        ...res
      };
      await database.syncCollection(query, res);
      return res;
    } else if (GithubUserModel.collection.hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final users = github.users.listUsers();
      res = (await users.map((e) => e).toList()).toMap((e) {
        final id = e.uid;
        if (id == null) {
          return null;
        }
        return MapEntry(id, e.toGithubUserModel().toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubRepositoryModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubRepositoryModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      if (organizationId == null) {
        throw Exception("Invalid path for repository collection load");
      }
      final search = query.query.filters.get<String>(
        types: [ModelQueryFilterType.like],
      );
      if (search != null) {
        final repositories = github.search.repositories(
          "owner:$organizationId $search",
        );
        res = (await repositories.map((e) => e).toList()).toMap((e) {
          final id = e.uid;
          if (id == null) {
            return null;
          }
          return MapEntry(
              id,
              e
                  .toGithubRepositoryModel(organizationId)
                  .toJson()
                  .toEntireJson());
        });
        await database.syncCollection(query, res);
        return res;
      }
      // organizationIdが一致するか取得
      var isOrganization = false;
      final organizationRes = await database.loadDocument(
        ModelAdapterDocumentQuery(
            query: GithubOrganizationModel.document(organizationId).modelQuery),
      );
      if (organizationRes != null) {
        isOrganization = true;
      } else {
        final userQuery = ModelAdapterDocumentQuery(
            query: GithubUserModel.document(organizationId).modelQuery);
        final userRes = await database.loadDocument(userQuery);
        if (userRes != null) {
          isOrganization = false;
        } else {
          final currentUser = await github.users.getCurrentUser();
          await database.syncDocument(
            userQuery,
            currentUser.toGithubUserModel().toJson().toEntireJson(),
          );
          if (currentUser.uid == organizationId) {
            isOrganization = false;
          } else {
            isOrganization = true;
          }
        }
      }
      if (isOrganization) {
        final repositories = github.repositories.listOrganizationRepositories(
          organizationId,
        );
        res = (await repositories.map((e) => e).toList()).toMap((e) {
          final id = e.uid;
          if (id == null) {
            return null;
          }
          return MapEntry(
              id,
              e
                  .toGithubRepositoryModel(organizationId)
                  .toJson()
                  .toEntireJson());
        });
        await database.syncCollection(query, res);
        return res;
      } else {
        final repositories = github.repositories.listRepositories();
        res = (await repositories.map((e) => e).toList()).toMap((e) {
          final id = e.uid;
          if (id == null) {
            return null;
          }
          return MapEntry(
              id,
              e
                  .toGithubRepositoryModel(organizationId)
                  .toJson()
                  .toEntireJson());
        });
        await database.syncCollection(query, res);
        return res;
      }
    } else if (GithubActionsModel.collection.hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubActionsModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for actions collection load");
      }
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Access token is not available");
      }
      final response = await Api.get(
        "$_kGithubEndpoint/repos/$organizationId/$repositoryId/actions/runs",
        headers: {
          "Authorization": "Bearer $accessToken",
          _kGitHubApiVersionHeader: _kGitHubApiVersion,
          "Accept": "application/vnd.github+json",
        },
      );
      if (!response.statusCode.toString().startsWith("2")) {
        throw Exception(
            "Failed to load actions collection: ${response.statusCode}");
      }
      final json = jsonDecodeAsMap(response.body);
      final runs = json
          .getAsList<DynamicMap>("workflow_runs")
          .map((run) => run.toGithubActionsModel(
              organizationId: organizationId, repositoryId: repositoryId))
          .where((run) => run.id != null)
          .toList();
      res = runs.toMap((run) {
        final id = run.id?.toString();
        if (id == null) {
          return null;
        }
        return MapEntry(id, run.toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubActionsJobModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubActionsJobModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final actionId = int.tryParse(match?.group(3) ?? "");
      if (organizationId == null || repositoryId == null || actionId == null) {
        throw Exception("Invalid path for actions job collection load");
      }
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Access token is not available");
      }
      final response = await Api.get(
        "$_kGithubEndpoint/repos/$organizationId/$repositoryId/actions/runs/$actionId/jobs",
        headers: {
          "Authorization": "Bearer $accessToken",
          _kGitHubApiVersionHeader: _kGitHubApiVersion,
          "Accept": "application/vnd.github+json",
        },
      );
      if (!response.statusCode.toString().startsWith("2")) {
        throw Exception(
            "Failed to load actions job collection: ${response.statusCode}");
      }
      final json = jsonDecodeAsMap(response.body);
      final jobs = json
          .getAsList<DynamicMap>("jobs")
          .map((job) => job.toGithubActionsJobModel(
              organizationId: organizationId, repositoryId: repositoryId))
          .where((job) => job.id != null)
          .toList();
      res = jobs.toMap((job) {
        final id = job.id?.toString();
        if (id == null) {
          return null;
        }
        return MapEntry(id, job.toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubActionsLogModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubActionsLogModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final actionId = int.tryParse(match?.group(3) ?? "");
      final jobId = int.tryParse(match?.group(4) ?? "");
      if (organizationId == null ||
          repositoryId == null ||
          actionId == null ||
          jobId == null) {
        throw Exception("Invalid path for actions log collection load");
      }
      res = await _fetchGithubActionsLogs(
        organizationId: organizationId,
        repositoryId: repositoryId,
        runId: actionId,
        jobId: jobId,
      );
      await database.syncCollection(query, res);
      return res;
    } else if (GithubIssueModel.collection.hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubIssueModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for issue collection load");
      }
      final issues = github.issues.listByRepo(
        RepositorySlug(organizationId, repositoryId),
      );
      res = (await issues.map((e) => e).toList()).where((e) {
        // Pull Requestを除外する (htmlUrlに"/pull/"が含まれる場合はPull Request)
        return !e.htmlUrl.contains("/pull/");
      }).toMap((e) {
        final id = e.uid;
        if (id == null) {
          return null;
        }
        return MapEntry(id, e.toGithubIssueModel().toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubIssueTimelineModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match = GithubIssueTimelineModel.collection.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final issueId = match?.group(3);
      if (organizationId == null || repositoryId == null || issueId == null) {
        throw Exception("Invalid path for issue comment collection load");
      }
      final timelines = github.issues.listTimeline(
        RepositorySlug(organizationId, repositoryId),
        int.parse(issueId),
      );
      res = (await timelines.map((e) => e).toList()).toMap((e) {
        final id = e.uid;
        if (id == null) {
          return null;
        }
        return MapEntry(
            id, e.toGithubIssueTimelineModel().toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubPullRequestModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubPullRequestModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for pull request collection load");
      }
      final pullRequest = github.pullRequests.list(
        RepositorySlug(organizationId, repositoryId),
      );
      res = (await pullRequest.map((e) => e).toList()).toMap((e) {
        final id = e.uid;
        if (id == null) {
          return null;
        }
        return MapEntry(
            id, e.toGithubPullRequestModel().toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubPullRequestTimelineModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match = GithubPullRequestTimelineModel.collection.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final pullRequestId = match?.group(3);
      if (organizationId == null ||
          repositoryId == null ||
          pullRequestId == null) {
        throw Exception(
            "Invalid path for pull request comment collection load");
      }
      final pullRequest = github.issues.listCommentsByIssue(
        RepositorySlug(organizationId, repositoryId),
        int.parse(pullRequestId),
      );
      res = (await pullRequest.map((e) => e).toList()).toMap((e) {
        final id = e.uid;
        if (id == null) {
          return null;
        }
        return MapEntry(
            id, e.toGithubPullRequestTimelineModel().toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubBranchModel.collection.hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubBranchModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for branch collection load");
      }
      final branch = github.repositories.listBranches(
        RepositorySlug(organizationId, repositoryId),
      );
      res = (await branch.map((e) => e).toList()).toMap((e) {
        final id = e.uid;
        if (id == null) {
          return null;
        }
        return MapEntry(id, e.toGithubBranchModel().toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubCommitModel.collection.hasMatchPath(query.query.path)) {
      final limit = (query.query.filters.get<int>(types: [
            ModelQueryFilterType.limit,
          ]) ??
          100);
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubCommitModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = match?.group(3)?.fromUrlEncode();
      if (organizationId == null || repositoryId == null || branchId == null) {
        throw Exception("Invalid path for commit collection load");
      }
      res ??= {};
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Failed to get access token");
      }
      var page = 1;
      final since = DateTime.now().subtract(commitsDuration);
      final sinceIso = since.toUtc().toIso8601String();
      do {
        final parameters = Uri(queryParameters: {
          "sha": branchId,
          "since": sinceIso,
          "per_page": limit.toString(),
          "page": page.toString(),
        }).query;
        final result = await Api.get(
          "$_kGithubEndpoint/repos/$organizationId/$repositoryId/commits?$parameters",
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        );
        if (!result.statusCode.toString().startsWith("2")) {
          throw Exception("Failed to get commits: ${result.statusCode}");
        }
        final json = jsonDecodeAsList<DynamicMap>(result.body);
        final partialRes = json.toMap((e) {
          final id = e.get("sha", nullOfString);
          if (id == null) {
            return null;
          }
          return MapEntry(id, e.toGithubCommitModel().toJson().toEntireJson());
        });
        res.addAll(partialRes);
        page++;
      } while (page <= query.page);
      await database.syncCollection(query, res);
      return res;
    } else if (GithubContentModel.collection.hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match =
          GithubContentModel.collection.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = match?.group(3)?.fromUrlEncode();
      final commitId = match?.group(4);
      final pathId = match?.group(5);
      if (organizationId == null ||
          repositoryId == null ||
          branchId == null ||
          commitId == null) {
        throw Exception("Invalid path for content collection load");
      }
      final path = Uri.decodeComponent(pathId ?? "").trimString("/");
      final contents = await github.repositories.getContents(
        RepositorySlug(organizationId, repositoryId),
        path,
        ref: commitId,
      );
      res = contents.tree?.toMap((e) {
            final id = e.uid;
            if (id == null) {
              return null;
            }
            return MapEntry(
                id, e.toGithubContentModel().toJson().toEntireJson());
          }) ??
          {};
      await database.syncCollection(query, res);
      return res;
    } else if (GithubCopilotSessionModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match = GithubCopilotSessionModel.collection.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for copilot session collection load");
      }
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Failed to get access token");
      }
      final session = await Api.get(
        "$_kGithubCopilotEndpoint/agents/resource/repository/$repositoryId",
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
          "Copilot-Integration-Id": "copilot-4-cli",
        },
      );
      final json = jsonDecodeAsMap(session.body);
      final sessions = json.getAsList<DynamicMap>("sessions");
      res = sessions.toMap((e) {
        final id = e.get("id", nullOfString);
        if (id == null) {
          return null;
        }
        return MapEntry(
            id, e.toGithubCopilotSessionModel().toJson().toEntireJson());
      });
      await database.syncCollection(query, res);
      return res;
    } else if (GithubCopilotSessionLogModel.collection
        .hasMatchPath(query.query.path)) {
      var res = await database.loadCollection(query);
      if (!query.reload && res.isNotEmpty) {
        return res ?? {};
      }
      final match = GithubCopilotSessionLogModel.collection.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final sessionId = match?.group(3);
      if (organizationId == null || repositoryId == null || sessionId == null) {
        throw Exception("Invalid path for copilot session log collection load");
      }
      final accessToken = await onRetrieveToken();
      if (accessToken == null) {
        throw Exception("Failed to get access token");
      }
      final log = await Api.get(
        "$_kGithubCopilotEndpoint/agents/sessions/$sessionId/logs",
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
          "Copilot-Integration-Id": "copilot-4-cli",
        },
      );
      final json = jsonDecodeAsMap(log.body);
      final logs = json.getAsList<DynamicMap>("logs");
      res = logs.toMap((e) {
        final id = e.get("id", nullOfString);
        if (id == null) {
          return null;
        }
        return MapEntry(
          id,
          e
              .toGithubCopilotSessionLogModel(sessionId: sessionId)
              .toJson()
              .toEntireJson(),
        );
      });
      await database.syncCollection(query, res);
      return res;
    }
    throw UnsupportedError("Unsupported collection: ${query.query.path}");
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    final github = await _getInstance();

    if (GithubOrganizationModel.document.hasMatchPath(query.query.path)) {
      final organizationId = query.query.path.split("/").last;
      final model = GithubOrganizationModel.fromJson(value);
      await github.organizations.edit(
        organizationId,
        name: model.name,
        location: model.location,
        company: model.company,
        email: model.email,
      );
      await database.saveDocument(query, value);
      return;
    } else if (GithubUserModel.document.hasMatchPath(query.query.path)) {
      final model = GithubUserModel.fromJson(value);
      await github.users.editCurrentUser(
        name: model.name,
        email: model.email,
        blog: model.blog,
        company: model.company,
        location: model.location,
        bio: model.bio,
      );
      await database.saveDocument(query, value);
      return;
    } else if (GithubRepositoryModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubRepositoryModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = query.query.path.split("/").last;
      if (organizationId == null) {
        throw Exception("Invalid path for repository document save");
      }
      final model = GithubRepositoryModel.fromJson(value);
      final fromServer = model.fromServer;
      if (!fromServer) {
        await github.repositories.createRepository(
          CreateRepository(
            model.name,
            description: model.description,
            homepage: model.homepageUrl?.toString(),
            private: model.isPrivate,
            hasWiki: model.hasWiki,
            hasIssues: model.hasIssues,
            hasDownloads: model.hasDownloads,
          ),
          org: organizationId,
        );
      } else {
        await github.repositories.editRepository(
          RepositorySlug(organizationId, repositoryId),
          name: model.name,
          description: model.description,
          homepage: model.homepageUrl?.toString(),
          private: model.isPrivate,
          hasWiki: model.hasWiki,
          hasIssues: model.hasIssues,
          hasDownloads: model.hasDownloads,
        );
      }
      await database.saveDocument(query, value);
      return;
    } else if (GithubIssueModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubIssueModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final issueId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null || repositoryId == null || issueId == null) {
        throw Exception("Invalid path for issue document save");
      }
      final model = GithubIssueModel.fromJson(value);
      final fromServer = model.fromServer;
      if (!fromServer) {
        await github.issues.create(
          RepositorySlug(organizationId, repositoryId),
          IssueRequest(
            title: model.title,
            body: model.body,
            assignee: model.assignee?.login,
            state: "open",
            assignees: model.assignees.mapAndRemoveEmpty((e) => e.login),
            labels: model.labels.mapAndRemoveEmpty((e) => e.name),
          ),
        );
      } else {
        await github.issues.edit(
          RepositorySlug(organizationId, repositoryId),
          issueId,
          IssueRequest(state: "closed"),
        );
      }
      await database.saveDocument(query, value);
      return;
    } else if (GithubIssueTimelineModel.document
        .hasMatchPath(query.query.path)) {
      final match =
          GithubIssueTimelineModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final issueId = int.tryParse(match?.group(3) ?? "");
      final commentId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          issueId == null ||
          commentId == null) {
        throw Exception("Invalid path for issue document deletion");
      }
      final model = GithubIssueTimelineModel.fromJson(value);
      final fromServer = model.fromServer;
      if (!fromServer) {
        await github.issues.createComment(
          RepositorySlug(organizationId, repositoryId),
          issueId,
          model.body ?? "",
        );
      } else {
        await github.issues.updateComment(
          RepositorySlug(organizationId, repositoryId),
          commentId,
          model.body ?? "",
        );
      }
      await database.saveDocument(query, value);
      return;
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
      final model = GithubPullRequestModel.fromJson(value);
      final fromServer = model.fromServer;
      if (!fromServer) {
        await github.pullRequests.create(
          RepositorySlug(organizationId, repositoryId),
          CreatePullRequest(
            model.title,
            model.head?.ref,
            model.base?.ref,
            draft: model.draft,
            body: model.body,
          ),
        );
      } else {
        await github.pullRequests.edit(
          RepositorySlug(organizationId, repositoryId),
          pullRequestId,
          title: model.title,
          body: model.body,
          base: model.base?.ref,
        );
      }
      await database.saveDocument(query, value);
      return;
    } else if (GithubPullRequestTimelineModel.document
        .hasMatchPath(query.query.path)) {
      final match = GithubPullRequestTimelineModel.document.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final pullRequestId = int.tryParse(match?.group(3) ?? "");
      final commentId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          pullRequestId == null ||
          commentId == null) {
        throw Exception("Invalid path for pull request document deletion");
      }
      final model = GithubPullRequestTimelineModel.fromJson(value);
      final fromServer = model.fromServer;
      if (!fromServer) {
        await github.issues.createComment(
          RepositorySlug(organizationId, repositoryId),
          pullRequestId,
          model.body ?? "",
        );
      } else {
        await github.issues.updateComment(
          RepositorySlug(organizationId, repositoryId),
          commentId,
          model.body ?? "",
        );
      }
      await database.saveDocument(query, value);
      return;
    } else if (GithubBranchModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubBranchModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = query.query.path.split("/").last.fromUrlEncode();
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for branch document deletion");
      }
      final model = GithubBranchModel.fromJson(value);
      final fromServer = model.fromServer;
      if (!fromServer) {
        final baseRefName = model.baseRef?.value?.name;
        if (baseRefName == null) {
          throw Exception("Invalid base ref for branch.");
        }
        final baseRef = await github.git.getReference(
          RepositorySlug(organizationId, repositoryId),
          "heads/$baseRefName",
        );
        final baseSha = baseRef.object?.sha;
        if (baseSha == null) {
          throw Exception("Invalid base ref for branch.");
        }
        await github.git.createReference(
          RepositorySlug(organizationId, repositoryId),
          "refs/heads/$branchId",
          baseSha,
        );
      } else {
        throw UnsupportedError("Branch update is not supported");
      }
      await database.saveDocument(query, value);
      return;
    } else if (GithubCommitModel.document.hasMatchPath(query.query.path)) {
      throw UnsupportedError("Commit update is not supported");
    } else if (GithubContentModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubContentModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = match?.group(3)?.fromUrlEncode();
      final commitId = match?.group(4);
      final pathId = match?.group(5);
      final contentId = query.query.path.split("/").last;
      if (organizationId == null ||
          repositoryId == null ||
          branchId == null ||
          commitId == null) {
        throw Exception("Invalid path for content document deletion");
      }
      final path = Uri.decodeComponent(pathId ?? "").trimString("/");
      final contentPath = Uri.decodeComponent(contentId).trimString("/");
      final model = GithubContentModel.fromJson(value);
      final fromServer = model.fromServer;
      if (!fromServer) {
        await github.repositories.createFile(
          RepositorySlug(organizationId, repositoryId),
          CreateFile(
            path: model.path ?? "$path/$contentPath",
            message: "chore: Create file(${model.path?.last()})",
            content: model.content,
            branch: branchId,
            committer: model.committer != null
                ? CommitUser(
                    model.committer?.value?.name,
                    model.committer?.value?.email,
                  )
                : null,
          ),
        );
      } else {
        await github.repositories.updateFile(
          RepositorySlug(organizationId, repositoryId),
          model.path ?? "$path/$contentPath",
          "chore: Update file(${model.path?.last()})",
          base64Encode(utf8.encode(model.content ?? "")),
          model.sha ?? "",
          branch: branchId,
        );
      }
      await database.saveDocument(query, value);
      return;
    }
    throw UnsupportedError("Unsupported document: ${query.query.path}");
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
      await database.deleteDocument(query);
      return;
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
      await database.deleteDocument(query);
      return;
    } else if (GithubIssueTimelineModel.document
        .hasMatchPath(query.query.path)) {
      final match =
          GithubIssueTimelineModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final issueId = match?.group(3);
      final commentId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          issueId == null ||
          commentId == null) {
        throw Exception("Invalid path for issue document deletion");
      }
      await github.issues.deleteComment(
        RepositorySlug(organizationId, repositoryId),
        commentId,
      );
      await database.deleteDocument(query);
      return;
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
      await database.deleteDocument(query);
      return;
    } else if (GithubPullRequestTimelineModel.document
        .hasMatchPath(query.query.path)) {
      final match = GithubPullRequestTimelineModel.document.regExp
          .firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final pullRequestId = match?.group(3);
      final commentId = int.tryParse(query.query.path.split("/").last);
      if (organizationId == null ||
          repositoryId == null ||
          pullRequestId == null ||
          commentId == null) {
        throw Exception("Invalid path for pull request document deletion");
      }
      await github.issues.deleteComment(
        RepositorySlug(organizationId, repositoryId),
        commentId,
      );
      await database.deleteDocument(query);
      return;
    } else if (GithubBranchModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubBranchModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = query.query.path.split("/").last.fromUrlEncode();
      if (organizationId == null || repositoryId == null) {
        throw Exception("Invalid path for branch document deletion");
      }
      await github.git.deleteReference(
        RepositorySlug(organizationId, repositoryId),
        "refs/heads/$branchId",
      );
      await database.deleteDocument(query);
      return;
    } else if (GithubCommitModel.document.hasMatchPath(query.query.path)) {
      throw UnsupportedError("Commit deletion is not supported");
    } else if (GithubContentModel.document.hasMatchPath(query.query.path)) {
      final match =
          GithubContentModel.document.regExp.firstMatch(query.query.path);
      final organizationId = match?.group(1);
      final repositoryId = match?.group(2);
      final branchId = match?.group(3)?.fromUrlEncode();
      final commitId = match?.group(4);
      final pathId = match?.group(5);
      final contentId = query.query.path.split("/").last;
      if (organizationId == null ||
          repositoryId == null ||
          branchId == null ||
          commitId == null) {
        throw Exception("Invalid path for content document deletion");
      }
      String? path;
      final res = await database.loadDocument(query);
      if (res == null) {
        final contents = await github.repositories.getContents(
          RepositorySlug(organizationId, repositoryId), "", // ルートディレクトリ
          ref: contentId,
        );
        path = contents.file?.path;
      }
      path ??=
          "${Uri.decodeComponent(pathId ?? "").trimString("/")}/${Uri.decodeComponent(contentId).trimString("/")}";
      await github.repositories.deleteFile(
        RepositorySlug(organizationId, repositoryId),
        path,
        "chore: Delete file(${path.last()})",
        contentId,
        branchId,
      );
      await database.deleteDocument(query);
      return;
    }
    throw UnsupportedError("Unsupported document: ${query.query.path}");
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    database.removeCollectionListener(query);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    database.removeDocumentListener(query);
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
  Future<void> clearAll() async {
    await database.clearAll();
  }

  @override
  Future<void> clearCache() async {
    await database.clearAll();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return onRetrieveToken.hashCode ^ database.hashCode;
  }

  Future<Map<String, DynamicMap>> _fetchGithubActionsLogs({
    required String organizationId,
    required String repositoryId,
    required int runId,
    required int jobId,
  }) async {
    final accessToken = await onRetrieveToken();
    if (accessToken == null) {
      throw Exception("Access token is not available");
    }
    final response = await Api.get(
      "$_kGithubEndpoint/repos/$organizationId/$repositoryId/actions/jobs/$jobId/logs",
      headers: {
        "Authorization": "Bearer $accessToken",
        _kGitHubApiVersionHeader: _kGitHubApiVersion,
        "Accept": "application/vnd.github+json",
      },
    );
    final downloadUrl =
        "$_kGithubEndpoint/repos/$organizationId/$repositoryId/actions/jobs/$jobId/logs";
    final logs = response.bodyBytes.toGithubActionsLogModelList(
      runId: runId,
      jobId: jobId,
      downloadUrl: downloadUrl,
    );
    return logs.toMap((log) {
      final chunk = log.chunk ?? 0;
      return MapEntry(
        chunk.toString(),
        log.toJson().toEntireJson(),
      );
    });
  }
}
