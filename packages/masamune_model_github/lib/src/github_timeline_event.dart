part of "/masamune_model_github.dart";

/// TimelineEvent.
///
/// タイムラインイベント。
enum GithubTimelineEvent {
  /// Added to project
  ///
  /// プロジェクトへの追加。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  addedToProject,

  /// Assigned
  ///
  /// 担当者の変更。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  assigned,

  /// Commented
  ///
  /// コメント。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  commented,

  /// Committed
  ///
  /// コミット。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  committed,

  /// Cross-referenced
  ///
  /// 他のリポジトリへの参照。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  crossReferenced,

  /// Demilestoned
  ///
  /// マイルストーンの削除。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  demilestoned,

  /// Labeled
  ///
  /// ラベルの追加。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  labeled,

  /// Locked
  ///
  /// ロック。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  locked,

  /// Milestoned
  ///
  /// マイルストーンの追加。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  milestoned,

  /// Moved columns across projects
  ///
  /// プロジェクト間の列の移動。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  movedColumnsAcrossProjects,

  /// Removed from project
  ///
  /// プロジェクトからの削除。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  removedFromProject,

  /// Renamed
  ///
  /// 名前の変更。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  renamed,

  /// Review dismissed
  ///
  /// レビューの却下。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  reviewDismissed,

  /// Review requested
  ///
  /// レビューのリクエスト。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  reviewRequested,

  /// Review request removed
  ///
  /// レビューのリクエストの削除。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  reviewRequestRemoved,

  /// Reviewed
  ///
  /// レビュー。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  reviewed,

  /// Unassigned
  ///
  /// 担当者の削除。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  unassigned,

  /// Unlabeled
  ///
  /// ラベルの削除。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  unlabeled,

  /// Pinned
  ///
  /// ピン留め。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  pinned,

  /// Unlocked
  ///
  /// ロック解除。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  unlocked,

  /// Unknown
  ///
  /// 不明。
  ///
  /// https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#timeline-events
  unknown;

  /// Convert a string to [GithubTimelineEvent].
  ///
  /// 文字列から[GithubTimelineEvent]に変換する。
  static GithubTimelineEvent fromString(String value) {
    switch (value) {
      case "added_to_project":
        return addedToProject;
      case "assigned":
        return assigned;
      case "commented":
        return commented;
      case "committed":
        return committed;
      case "cross-referenced":
        return crossReferenced;
      case "demilestoned":
        return demilestoned;
      case "labeled":
        return labeled;
      case "locked":
        return locked;
      case "milestoned":
        return milestoned;
      case "moved_columns_in_project":
        return movedColumnsAcrossProjects;
      case "removed_from_project":
        return removedFromProject;
      case "renamed":
        return renamed;
      case "review_dismissed":
        return reviewDismissed;
      case "review_requested":
        return reviewRequested;
      case "review_request_removed":
        return reviewRequestRemoved;
      case "reviewed":
        return reviewed;
      case "unassigned":
        return unassigned;
      case "unlabeled":
        return unlabeled;
      case "pinned":
        return pinned;
      case "unlocked":
        return unlocked;
      default:
        debugPrint("Unknown timeline event: $value");
        return unknown;
    }
  }

  /// Convert a [TimelineEvent] to a [GithubIssueTimelineModel].
  ///
  /// [TimelineEvent]から[GithubIssueTimelineModel]に変換する。
  GithubIssueTimelineModel toGithubIssueTimelineModelFromTimelineEvent(
      TimelineEvent event) {
    switch (this) {
      case addedToProject:
        if (event is ProjectEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            project: event.projectCard?.toGithubProjectEventValue(),
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case assigned:
        if (event is AssigneeEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            to: event.assignee?.toGithubUserModel(),
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case commented:
        if (event is CommentEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            from: event.user?.toGithubUserModel(),
            body: event.body,
            htmlUrl: ModelUri.tryParse(event.htmlUrl),
            issueUrl: ModelUri.tryParse(event.issueUrl),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            authorAssociation: event.authorAssociation,
            commitId: event.commitId,
            reaction: event.reactions?.toGithubReactionValue(),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.updatedAt != null
                ? ModelTimestamp(event.updatedAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case committed:
        if (event is TimelineCommitEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            from: event.author?.toGithubUserModel(),
            to: event.committer?.toGithubUserModel(),
            sha: event.sha,
            body: event.message,
            htmlUrl: ModelUri.tryParse(event.htmlUrl),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case crossReferenced:
        if (event is CrossReferenceEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            issue: event.source?.issue?.toGithubIssueModel(),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.updatedAt != null
                ? ModelTimestamp(event.updatedAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case demilestoned:
        if (event is MilestoneEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            milestone: event.milestone?.toGithubMilestoneValue(),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case labeled:
        if (event is LabelEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            label: event.label?.toGithubLabelValue(),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case locked:
        if (event is LockEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            body: event.lockReason,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case milestoned:
        if (event is MilestoneEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            milestone: event.milestone?.toGithubMilestoneValue(),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case movedColumnsAcrossProjects:
        if (event is ProjectEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            project: event.projectCard?.toGithubProjectEventValue(),
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case removedFromProject:
        if (event is ProjectEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            project: event.projectCard?.toGithubProjectEventValue(),
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case renamed:
        if (event is RenameEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            body: event.rename?.to,
            previousBody: event.rename?.from,
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case reviewDismissed:
        if (event is ReviewDismissedEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            reviewId: event.dismissedReview?.reviewId,
            state: event.dismissedReview?.state,
            body: event.dismissedReview?.dismissalMessage,
            previousBody: event.dismissedReview?.dismissalMessage,
            commitId: event.dismissedReview?.dismissalCommitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case reviewRequested:
        if (event is ReviewRequestEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            from: event.requestedReviewer?.toGithubUserModel(),
            to: event.reviewRequester?.toGithubUserModel(),
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case reviewRequestRemoved:
        if (event is ReviewRequestEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            from: event.requestedReviewer?.toGithubUserModel(),
            to: event.reviewRequester?.toGithubUserModel(),
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case reviewed:
        if (event is ReviewEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            from: event.user?.toGithubUserModel(),
            body: event.body,
            state: event.state,
            htmlUrl: ModelUri.tryParse(event.htmlUrl),
            pullRequestUrl: ModelUri.tryParse(event.pullRequestUrl),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            authorAssociation: event.authorAssociation,
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.submittedAt != null
                ? ModelTimestamp(event.submittedAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case unassigned:
        if (event is AssigneeEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            to: event.assignee?.toGithubUserModel(),
            commitId: event.commitId,
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      case unlabeled:
        if (event is LabelEvent) {
          return GithubIssueTimelineModel(
            id: event.id,
            event: this,
            user: event.actor?.toGithubUserModel(),
            label: event.label?.toGithubLabelValue(),
            url: ModelUri.tryParse(event.url),
            commitUrl: ModelUri.tryParse(event.commitUrl),
            commitId: event.commitId,
            createdAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            updatedAt: event.createdAt != null
                ? ModelTimestamp(event.createdAt!)
                : const ModelTimestamp.now(),
            fromServer: true,
          );
        }
        break;
      default:
        break;
    }
    return GithubIssueTimelineModel(
      id: event.id,
      event: this,
      user: event.actor?.toGithubUserModel(),
      commitId: event.commitId,
      url: ModelUri.tryParse(event.url),
      commitUrl: ModelUri.tryParse(event.commitUrl),
      createdAt: event.createdAt != null
          ? ModelTimestamp(event.createdAt!)
          : const ModelTimestamp.now(),
      updatedAt: event.createdAt != null
          ? ModelTimestamp(event.createdAt!)
          : const ModelTimestamp.now(),
      fromServer: true,
    );
  }
}
