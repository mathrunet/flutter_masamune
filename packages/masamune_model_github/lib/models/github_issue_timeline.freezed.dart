// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_issue_timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubIssueTimelineModel {
  int? get id;
  String? get body;
  String? get previousBody;
  String? get authorAssociation;
  String? get commitId;
  String? get sha;
  String? get state;
  int? get reviewId;
  GithubTimelineEvent get event;
  @jsonParam
  GithubUserModel? get user;
  @jsonParam
  GithubUserModel? get from;
  @jsonParam
  GithubUserModel? get to;
  @jsonParam
  GithubProjectModel? get project;
  @jsonParam
  GithubMilestoneValue? get milestone;
  @jsonParam
  GithubReactionValue? get reaction;
  @jsonParam
  GithubIssueModel? get issue;
  @jsonParam
  GithubPullRequestModel? get pullRequest;
  @jsonParam
  GithubLabelValue? get label;
  ModelUri? get url;
  ModelUri? get commitUrl;
  ModelUri? get htmlUrl;
  ModelUri? get issueUrl;
  ModelUri? get links;
  ModelUri? get pullRequestUrl;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;
  bool get fromServer;

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubIssueTimelineModelCopyWith<GithubIssueTimelineModel> get copyWith =>
      _$GithubIssueTimelineModelCopyWithImpl<GithubIssueTimelineModel>(
          this as GithubIssueTimelineModel, _$identity);

  /// Serializes this GithubIssueTimelineModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubIssueTimelineModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.previousBody, previousBody) ||
                other.previousBody == previousBody) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.commitId, commitId) ||
                other.commitId == commitId) &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.milestone, milestone) ||
                other.milestone == milestone) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.issue, issue) || other.issue == issue) &&
            (identical(other.pullRequest, pullRequest) ||
                other.pullRequest == pullRequest) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.commitUrl, commitUrl) ||
                other.commitUrl == commitUrl) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.issueUrl, issueUrl) ||
                other.issueUrl == issueUrl) &&
            (identical(other.links, links) || other.links == links) &&
            (identical(other.pullRequestUrl, pullRequestUrl) ||
                other.pullRequestUrl == pullRequestUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        body,
        previousBody,
        authorAssociation,
        commitId,
        sha,
        state,
        reviewId,
        event,
        user,
        from,
        to,
        project,
        milestone,
        reaction,
        issue,
        pullRequest,
        label,
        url,
        commitUrl,
        htmlUrl,
        issueUrl,
        links,
        pullRequestUrl,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubIssueTimelineModel(id: $id, body: $body, previousBody: $previousBody, authorAssociation: $authorAssociation, commitId: $commitId, sha: $sha, state: $state, reviewId: $reviewId, event: $event, user: $user, from: $from, to: $to, project: $project, milestone: $milestone, reaction: $reaction, issue: $issue, pullRequest: $pullRequest, label: $label, url: $url, commitUrl: $commitUrl, htmlUrl: $htmlUrl, issueUrl: $issueUrl, links: $links, pullRequestUrl: $pullRequestUrl, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubIssueTimelineModelCopyWith<$Res> {
  factory $GithubIssueTimelineModelCopyWith(GithubIssueTimelineModel value,
          $Res Function(GithubIssueTimelineModel) _then) =
      _$GithubIssueTimelineModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? body,
      String? previousBody,
      String? authorAssociation,
      String? commitId,
      String? sha,
      String? state,
      int? reviewId,
      GithubTimelineEvent event,
      @jsonParam GithubUserModel? user,
      @jsonParam GithubUserModel? from,
      @jsonParam GithubUserModel? to,
      @jsonParam GithubProjectModel? project,
      @jsonParam GithubMilestoneValue? milestone,
      @jsonParam GithubReactionValue? reaction,
      @jsonParam GithubIssueModel? issue,
      @jsonParam GithubPullRequestModel? pullRequest,
      @jsonParam GithubLabelValue? label,
      ModelUri? url,
      ModelUri? commitUrl,
      ModelUri? htmlUrl,
      ModelUri? issueUrl,
      ModelUri? links,
      ModelUri? pullRequestUrl,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  $GithubUserModelCopyWith<$Res>? get user;
  $GithubUserModelCopyWith<$Res>? get from;
  $GithubUserModelCopyWith<$Res>? get to;
  $GithubProjectModelCopyWith<$Res>? get project;
  $GithubMilestoneValueCopyWith<$Res>? get milestone;
  $GithubReactionValueCopyWith<$Res>? get reaction;
  $GithubIssueModelCopyWith<$Res>? get issue;
  $GithubPullRequestModelCopyWith<$Res>? get pullRequest;
  $GithubLabelValueCopyWith<$Res>? get label;
}

/// @nodoc
class _$GithubIssueTimelineModelCopyWithImpl<$Res>
    implements $GithubIssueTimelineModelCopyWith<$Res> {
  _$GithubIssueTimelineModelCopyWithImpl(this._self, this._then);

  final GithubIssueTimelineModel _self;
  final $Res Function(GithubIssueTimelineModel) _then;

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? previousBody = freezed,
    Object? authorAssociation = freezed,
    Object? commitId = freezed,
    Object? sha = freezed,
    Object? state = freezed,
    Object? reviewId = freezed,
    Object? event = null,
    Object? user = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? project = freezed,
    Object? milestone = freezed,
    Object? reaction = freezed,
    Object? issue = freezed,
    Object? pullRequest = freezed,
    Object? label = freezed,
    Object? url = freezed,
    Object? commitUrl = freezed,
    Object? htmlUrl = freezed,
    Object? issueUrl = freezed,
    Object? links = freezed,
    Object? pullRequestUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      previousBody: freezed == previousBody
          ? _self.previousBody
          : previousBody // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      commitId: freezed == commitId
          ? _self.commitId
          : commitId // ignore: cast_nullable_to_non_nullable
              as String?,
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewId: freezed == reviewId
          ? _self.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as int?,
      event: null == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as GithubTimelineEvent,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      from: freezed == from
          ? _self.from
          : from // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      to: freezed == to
          ? _self.to
          : to // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as GithubProjectModel?,
      milestone: freezed == milestone
          ? _self.milestone
          : milestone // ignore: cast_nullable_to_non_nullable
              as GithubMilestoneValue?,
      reaction: freezed == reaction
          ? _self.reaction
          : reaction // ignore: cast_nullable_to_non_nullable
              as GithubReactionValue?,
      issue: freezed == issue
          ? _self.issue
          : issue // ignore: cast_nullable_to_non_nullable
              as GithubIssueModel?,
      pullRequest: freezed == pullRequest
          ? _self.pullRequest
          : pullRequest // ignore: cast_nullable_to_non_nullable
              as GithubPullRequestModel?,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as GithubLabelValue?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commitUrl: freezed == commitUrl
          ? _self.commitUrl
          : commitUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueUrl: freezed == issueUrl
          ? _self.issueUrl
          : issueUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      links: freezed == links
          ? _self.links
          : links // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      pullRequestUrl: freezed == pullRequestUrl
          ? _self.pullRequestUrl
          : pullRequestUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
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

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get from {
    if (_self.from == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.from!, (value) {
      return _then(_self.copyWith(from: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get to {
    if (_self.to == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.to!, (value) {
      return _then(_self.copyWith(to: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubProjectModelCopyWith<$Res>? get project {
    if (_self.project == null) {
      return null;
    }

    return $GithubProjectModelCopyWith<$Res>(_self.project!, (value) {
      return _then(_self.copyWith(project: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubMilestoneValueCopyWith<$Res>? get milestone {
    if (_self.milestone == null) {
      return null;
    }

    return $GithubMilestoneValueCopyWith<$Res>(_self.milestone!, (value) {
      return _then(_self.copyWith(milestone: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubReactionValueCopyWith<$Res>? get reaction {
    if (_self.reaction == null) {
      return null;
    }

    return $GithubReactionValueCopyWith<$Res>(_self.reaction!, (value) {
      return _then(_self.copyWith(reaction: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubIssueModelCopyWith<$Res>? get issue {
    if (_self.issue == null) {
      return null;
    }

    return $GithubIssueModelCopyWith<$Res>(_self.issue!, (value) {
      return _then(_self.copyWith(issue: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubPullRequestModelCopyWith<$Res>? get pullRequest {
    if (_self.pullRequest == null) {
      return null;
    }

    return $GithubPullRequestModelCopyWith<$Res>(_self.pullRequest!, (value) {
      return _then(_self.copyWith(pullRequest: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubLabelValueCopyWith<$Res>? get label {
    if (_self.label == null) {
      return null;
    }

    return $GithubLabelValueCopyWith<$Res>(_self.label!, (value) {
      return _then(_self.copyWith(label: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GithubIssueTimelineModel].
extension GithubIssueTimelineModelPatterns on GithubIssueTimelineModel {
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
    TResult Function(_GithubIssueTimelineModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubIssueTimelineModel() when $default != null:
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
    TResult Function(_GithubIssueTimelineModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueTimelineModel():
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
    TResult? Function(_GithubIssueTimelineModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueTimelineModel() when $default != null:
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
            String? body,
            String? previousBody,
            String? authorAssociation,
            String? commitId,
            String? sha,
            String? state,
            int? reviewId,
            GithubTimelineEvent event,
            @jsonParam GithubUserModel? user,
            @jsonParam GithubUserModel? from,
            @jsonParam GithubUserModel? to,
            @jsonParam GithubProjectModel? project,
            @jsonParam GithubMilestoneValue? milestone,
            @jsonParam GithubReactionValue? reaction,
            @jsonParam GithubIssueModel? issue,
            @jsonParam GithubPullRequestModel? pullRequest,
            @jsonParam GithubLabelValue? label,
            ModelUri? url,
            ModelUri? commitUrl,
            ModelUri? htmlUrl,
            ModelUri? issueUrl,
            ModelUri? links,
            ModelUri? pullRequestUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubIssueTimelineModel() when $default != null:
        return $default(
            _that.id,
            _that.body,
            _that.previousBody,
            _that.authorAssociation,
            _that.commitId,
            _that.sha,
            _that.state,
            _that.reviewId,
            _that.event,
            _that.user,
            _that.from,
            _that.to,
            _that.project,
            _that.milestone,
            _that.reaction,
            _that.issue,
            _that.pullRequest,
            _that.label,
            _that.url,
            _that.commitUrl,
            _that.htmlUrl,
            _that.issueUrl,
            _that.links,
            _that.pullRequestUrl,
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
            String? body,
            String? previousBody,
            String? authorAssociation,
            String? commitId,
            String? sha,
            String? state,
            int? reviewId,
            GithubTimelineEvent event,
            @jsonParam GithubUserModel? user,
            @jsonParam GithubUserModel? from,
            @jsonParam GithubUserModel? to,
            @jsonParam GithubProjectModel? project,
            @jsonParam GithubMilestoneValue? milestone,
            @jsonParam GithubReactionValue? reaction,
            @jsonParam GithubIssueModel? issue,
            @jsonParam GithubPullRequestModel? pullRequest,
            @jsonParam GithubLabelValue? label,
            ModelUri? url,
            ModelUri? commitUrl,
            ModelUri? htmlUrl,
            ModelUri? issueUrl,
            ModelUri? links,
            ModelUri? pullRequestUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueTimelineModel():
        return $default(
            _that.id,
            _that.body,
            _that.previousBody,
            _that.authorAssociation,
            _that.commitId,
            _that.sha,
            _that.state,
            _that.reviewId,
            _that.event,
            _that.user,
            _that.from,
            _that.to,
            _that.project,
            _that.milestone,
            _that.reaction,
            _that.issue,
            _that.pullRequest,
            _that.label,
            _that.url,
            _that.commitUrl,
            _that.htmlUrl,
            _that.issueUrl,
            _that.links,
            _that.pullRequestUrl,
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
            String? body,
            String? previousBody,
            String? authorAssociation,
            String? commitId,
            String? sha,
            String? state,
            int? reviewId,
            GithubTimelineEvent event,
            @jsonParam GithubUserModel? user,
            @jsonParam GithubUserModel? from,
            @jsonParam GithubUserModel? to,
            @jsonParam GithubProjectModel? project,
            @jsonParam GithubMilestoneValue? milestone,
            @jsonParam GithubReactionValue? reaction,
            @jsonParam GithubIssueModel? issue,
            @jsonParam GithubPullRequestModel? pullRequest,
            @jsonParam GithubLabelValue? label,
            ModelUri? url,
            ModelUri? commitUrl,
            ModelUri? htmlUrl,
            ModelUri? issueUrl,
            ModelUri? links,
            ModelUri? pullRequestUrl,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueTimelineModel() when $default != null:
        return $default(
            _that.id,
            _that.body,
            _that.previousBody,
            _that.authorAssociation,
            _that.commitId,
            _that.sha,
            _that.state,
            _that.reviewId,
            _that.event,
            _that.user,
            _that.from,
            _that.to,
            _that.project,
            _that.milestone,
            _that.reaction,
            _that.issue,
            _that.pullRequest,
            _that.label,
            _that.url,
            _that.commitUrl,
            _that.htmlUrl,
            _that.issueUrl,
            _that.links,
            _that.pullRequestUrl,
            _that.createdAt,
            _that.updatedAt,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GithubIssueTimelineModel extends GithubIssueTimelineModel {
  const _GithubIssueTimelineModel(
      {this.id,
      this.body,
      this.previousBody,
      this.authorAssociation,
      this.commitId,
      this.sha,
      this.state,
      this.reviewId,
      this.event = GithubTimelineEvent.unknown,
      @jsonParam this.user,
      @jsonParam this.from,
      @jsonParam this.to,
      @jsonParam this.project,
      @jsonParam this.milestone,
      @jsonParam this.reaction,
      @jsonParam this.issue,
      @jsonParam this.pullRequest,
      @jsonParam this.label,
      this.url,
      this.commitUrl,
      this.htmlUrl,
      this.issueUrl,
      this.links,
      this.pullRequestUrl,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now(),
      this.fromServer = false})
      : super._();
  factory _GithubIssueTimelineModel.fromJson(Map<String, dynamic> json) =>
      _$GithubIssueTimelineModelFromJson(json);

  @override
  final int? id;
  @override
  final String? body;
  @override
  final String? previousBody;
  @override
  final String? authorAssociation;
  @override
  final String? commitId;
  @override
  final String? sha;
  @override
  final String? state;
  @override
  final int? reviewId;
  @override
  @JsonKey()
  final GithubTimelineEvent event;
  @override
  @jsonParam
  final GithubUserModel? user;
  @override
  @jsonParam
  final GithubUserModel? from;
  @override
  @jsonParam
  final GithubUserModel? to;
  @override
  @jsonParam
  final GithubProjectModel? project;
  @override
  @jsonParam
  final GithubMilestoneValue? milestone;
  @override
  @jsonParam
  final GithubReactionValue? reaction;
  @override
  @jsonParam
  final GithubIssueModel? issue;
  @override
  @jsonParam
  final GithubPullRequestModel? pullRequest;
  @override
  @jsonParam
  final GithubLabelValue? label;
  @override
  final ModelUri? url;
  @override
  final ModelUri? commitUrl;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? issueUrl;
  @override
  final ModelUri? links;
  @override
  final ModelUri? pullRequestUrl;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubIssueTimelineModelCopyWith<_GithubIssueTimelineModel> get copyWith =>
      __$GithubIssueTimelineModelCopyWithImpl<_GithubIssueTimelineModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubIssueTimelineModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubIssueTimelineModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.previousBody, previousBody) ||
                other.previousBody == previousBody) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.commitId, commitId) ||
                other.commitId == commitId) &&
            (identical(other.sha, sha) || other.sha == sha) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.milestone, milestone) ||
                other.milestone == milestone) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.issue, issue) || other.issue == issue) &&
            (identical(other.pullRequest, pullRequest) ||
                other.pullRequest == pullRequest) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.commitUrl, commitUrl) ||
                other.commitUrl == commitUrl) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.issueUrl, issueUrl) ||
                other.issueUrl == issueUrl) &&
            (identical(other.links, links) || other.links == links) &&
            (identical(other.pullRequestUrl, pullRequestUrl) ||
                other.pullRequestUrl == pullRequestUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        body,
        previousBody,
        authorAssociation,
        commitId,
        sha,
        state,
        reviewId,
        event,
        user,
        from,
        to,
        project,
        milestone,
        reaction,
        issue,
        pullRequest,
        label,
        url,
        commitUrl,
        htmlUrl,
        issueUrl,
        links,
        pullRequestUrl,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubIssueTimelineModel(id: $id, body: $body, previousBody: $previousBody, authorAssociation: $authorAssociation, commitId: $commitId, sha: $sha, state: $state, reviewId: $reviewId, event: $event, user: $user, from: $from, to: $to, project: $project, milestone: $milestone, reaction: $reaction, issue: $issue, pullRequest: $pullRequest, label: $label, url: $url, commitUrl: $commitUrl, htmlUrl: $htmlUrl, issueUrl: $issueUrl, links: $links, pullRequestUrl: $pullRequestUrl, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubIssueTimelineModelCopyWith<$Res>
    implements $GithubIssueTimelineModelCopyWith<$Res> {
  factory _$GithubIssueTimelineModelCopyWith(_GithubIssueTimelineModel value,
          $Res Function(_GithubIssueTimelineModel) _then) =
      __$GithubIssueTimelineModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? body,
      String? previousBody,
      String? authorAssociation,
      String? commitId,
      String? sha,
      String? state,
      int? reviewId,
      GithubTimelineEvent event,
      @jsonParam GithubUserModel? user,
      @jsonParam GithubUserModel? from,
      @jsonParam GithubUserModel? to,
      @jsonParam GithubProjectModel? project,
      @jsonParam GithubMilestoneValue? milestone,
      @jsonParam GithubReactionValue? reaction,
      @jsonParam GithubIssueModel? issue,
      @jsonParam GithubPullRequestModel? pullRequest,
      @jsonParam GithubLabelValue? label,
      ModelUri? url,
      ModelUri? commitUrl,
      ModelUri? htmlUrl,
      ModelUri? issueUrl,
      ModelUri? links,
      ModelUri? pullRequestUrl,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  @override
  $GithubUserModelCopyWith<$Res>? get user;
  @override
  $GithubUserModelCopyWith<$Res>? get from;
  @override
  $GithubUserModelCopyWith<$Res>? get to;
  @override
  $GithubProjectModelCopyWith<$Res>? get project;
  @override
  $GithubMilestoneValueCopyWith<$Res>? get milestone;
  @override
  $GithubReactionValueCopyWith<$Res>? get reaction;
  @override
  $GithubIssueModelCopyWith<$Res>? get issue;
  @override
  $GithubPullRequestModelCopyWith<$Res>? get pullRequest;
  @override
  $GithubLabelValueCopyWith<$Res>? get label;
}

/// @nodoc
class __$GithubIssueTimelineModelCopyWithImpl<$Res>
    implements _$GithubIssueTimelineModelCopyWith<$Res> {
  __$GithubIssueTimelineModelCopyWithImpl(this._self, this._then);

  final _GithubIssueTimelineModel _self;
  final $Res Function(_GithubIssueTimelineModel) _then;

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? body = freezed,
    Object? previousBody = freezed,
    Object? authorAssociation = freezed,
    Object? commitId = freezed,
    Object? sha = freezed,
    Object? state = freezed,
    Object? reviewId = freezed,
    Object? event = null,
    Object? user = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? project = freezed,
    Object? milestone = freezed,
    Object? reaction = freezed,
    Object? issue = freezed,
    Object? pullRequest = freezed,
    Object? label = freezed,
    Object? url = freezed,
    Object? commitUrl = freezed,
    Object? htmlUrl = freezed,
    Object? issueUrl = freezed,
    Object? links = freezed,
    Object? pullRequestUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubIssueTimelineModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      previousBody: freezed == previousBody
          ? _self.previousBody
          : previousBody // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      commitId: freezed == commitId
          ? _self.commitId
          : commitId // ignore: cast_nullable_to_non_nullable
              as String?,
      sha: freezed == sha
          ? _self.sha
          : sha // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewId: freezed == reviewId
          ? _self.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as int?,
      event: null == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as GithubTimelineEvent,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      from: freezed == from
          ? _self.from
          : from // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      to: freezed == to
          ? _self.to
          : to // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      project: freezed == project
          ? _self.project
          : project // ignore: cast_nullable_to_non_nullable
              as GithubProjectModel?,
      milestone: freezed == milestone
          ? _self.milestone
          : milestone // ignore: cast_nullable_to_non_nullable
              as GithubMilestoneValue?,
      reaction: freezed == reaction
          ? _self.reaction
          : reaction // ignore: cast_nullable_to_non_nullable
              as GithubReactionValue?,
      issue: freezed == issue
          ? _self.issue
          : issue // ignore: cast_nullable_to_non_nullable
              as GithubIssueModel?,
      pullRequest: freezed == pullRequest
          ? _self.pullRequest
          : pullRequest // ignore: cast_nullable_to_non_nullable
              as GithubPullRequestModel?,
      label: freezed == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as GithubLabelValue?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commitUrl: freezed == commitUrl
          ? _self.commitUrl
          : commitUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      issueUrl: freezed == issueUrl
          ? _self.issueUrl
          : issueUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      links: freezed == links
          ? _self.links
          : links // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      pullRequestUrl: freezed == pullRequestUrl
          ? _self.pullRequestUrl
          : pullRequestUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
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

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get from {
    if (_self.from == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.from!, (value) {
      return _then(_self.copyWith(from: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get to {
    if (_self.to == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.to!, (value) {
      return _then(_self.copyWith(to: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubProjectModelCopyWith<$Res>? get project {
    if (_self.project == null) {
      return null;
    }

    return $GithubProjectModelCopyWith<$Res>(_self.project!, (value) {
      return _then(_self.copyWith(project: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubMilestoneValueCopyWith<$Res>? get milestone {
    if (_self.milestone == null) {
      return null;
    }

    return $GithubMilestoneValueCopyWith<$Res>(_self.milestone!, (value) {
      return _then(_self.copyWith(milestone: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubReactionValueCopyWith<$Res>? get reaction {
    if (_self.reaction == null) {
      return null;
    }

    return $GithubReactionValueCopyWith<$Res>(_self.reaction!, (value) {
      return _then(_self.copyWith(reaction: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubIssueModelCopyWith<$Res>? get issue {
    if (_self.issue == null) {
      return null;
    }

    return $GithubIssueModelCopyWith<$Res>(_self.issue!, (value) {
      return _then(_self.copyWith(issue: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubPullRequestModelCopyWith<$Res>? get pullRequest {
    if (_self.pullRequest == null) {
      return null;
    }

    return $GithubPullRequestModelCopyWith<$Res>(_self.pullRequest!, (value) {
      return _then(_self.copyWith(pullRequest: value));
    });
  }

  /// Create a copy of GithubIssueTimelineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubLabelValueCopyWith<$Res>? get label {
    if (_self.label == null) {
      return null;
    }

    return $GithubLabelValueCopyWith<$Res>(_self.label!, (value) {
      return _then(_self.copyWith(label: value));
    });
  }
}

// dart format on
