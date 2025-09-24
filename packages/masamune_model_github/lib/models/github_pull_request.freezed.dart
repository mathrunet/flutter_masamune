// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_pull_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubPullRequestModel {
  int? get id;
  String? get nodeId;
  int? get number;
  String? get state;
  String? get title;
  String? get body;
  String? get mergeCommitSha;
  String? get mergeableState;
  String? get authorAssociation;
  bool get draft;
  bool get merged;
  bool get mergeable;
  bool get rebaseable;
  bool get maintainerCanModify;
  int get commentsCount;
  int get commitsCount;
  int get additionsCount;
  int get deletionsCount;
  int get changedFilesCount;
  int get reviewCommentCount;
  @refParam
  GithubRepositoryModelRef? get repository;
  @refParam
  GithubUserModelRef? get user;
  @refParam
  GithubUserModelRef? get mergedBy;
  @refParam
  List<GithubUserModelRef> get requestedReviewers;
  @jsonParam
  List<GithubLabelValue> get labels;
  @jsonParam
  GithubPullRequestHeadValue? get head;
  @jsonParam
  GithubPullRequestHeadValue? get base;
  @jsonParam
  GithubMilestoneValue? get milestone;
  ModelUri? get htmlUrl;
  ModelUri? get diffUrl;
  ModelUri? get patchUrl;
  ModelTimestamp? get closedAt;
  ModelTimestamp? get mergedAt;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;
  bool get fromServer;

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubPullRequestModelCopyWith<GithubPullRequestModel> get copyWith =>
      _$GithubPullRequestModelCopyWithImpl<GithubPullRequestModel>(
          this as GithubPullRequestModel, _$identity);

  /// Serializes this GithubPullRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubPullRequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.mergeCommitSha, mergeCommitSha) ||
                other.mergeCommitSha == mergeCommitSha) &&
            (identical(other.mergeableState, mergeableState) ||
                other.mergeableState == mergeableState) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.merged, merged) || other.merged == merged) &&
            (identical(other.mergeable, mergeable) ||
                other.mergeable == mergeable) &&
            (identical(other.rebaseable, rebaseable) ||
                other.rebaseable == rebaseable) &&
            (identical(other.maintainerCanModify, maintainerCanModify) ||
                other.maintainerCanModify == maintainerCanModify) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.commitsCount, commitsCount) ||
                other.commitsCount == commitsCount) &&
            (identical(other.additionsCount, additionsCount) ||
                other.additionsCount == additionsCount) &&
            (identical(other.deletionsCount, deletionsCount) ||
                other.deletionsCount == deletionsCount) &&
            (identical(other.changedFilesCount, changedFilesCount) ||
                other.changedFilesCount == changedFilesCount) &&
            (identical(other.reviewCommentCount, reviewCommentCount) ||
                other.reviewCommentCount == reviewCommentCount) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.mergedBy, mergedBy) ||
                other.mergedBy == mergedBy) &&
            const DeepCollectionEquality()
                .equals(other.requestedReviewers, requestedReviewers) &&
            const DeepCollectionEquality().equals(other.labels, labels) &&
            (identical(other.head, head) || other.head == head) &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.milestone, milestone) ||
                other.milestone == milestone) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.diffUrl, diffUrl) || other.diffUrl == diffUrl) &&
            (identical(other.patchUrl, patchUrl) ||
                other.patchUrl == patchUrl) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.mergedAt, mergedAt) ||
                other.mergedAt == mergedAt) &&
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
        nodeId,
        number,
        state,
        title,
        body,
        mergeCommitSha,
        mergeableState,
        authorAssociation,
        draft,
        merged,
        mergeable,
        rebaseable,
        maintainerCanModify,
        commentsCount,
        commitsCount,
        additionsCount,
        deletionsCount,
        changedFilesCount,
        reviewCommentCount,
        repository,
        user,
        mergedBy,
        const DeepCollectionEquality().hash(requestedReviewers),
        const DeepCollectionEquality().hash(labels),
        head,
        base,
        milestone,
        htmlUrl,
        diffUrl,
        patchUrl,
        closedAt,
        mergedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubPullRequestModel(id: $id, nodeId: $nodeId, number: $number, state: $state, title: $title, body: $body, mergeCommitSha: $mergeCommitSha, mergeableState: $mergeableState, authorAssociation: $authorAssociation, draft: $draft, merged: $merged, mergeable: $mergeable, rebaseable: $rebaseable, maintainerCanModify: $maintainerCanModify, commentsCount: $commentsCount, commitsCount: $commitsCount, additionsCount: $additionsCount, deletionsCount: $deletionsCount, changedFilesCount: $changedFilesCount, reviewCommentCount: $reviewCommentCount, repository: $repository, user: $user, mergedBy: $mergedBy, requestedReviewers: $requestedReviewers, labels: $labels, head: $head, base: $base, milestone: $milestone, htmlUrl: $htmlUrl, diffUrl: $diffUrl, patchUrl: $patchUrl, closedAt: $closedAt, mergedAt: $mergedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubPullRequestModelCopyWith<$Res> {
  factory $GithubPullRequestModelCopyWith(GithubPullRequestModel value,
          $Res Function(GithubPullRequestModel) _then) =
      _$GithubPullRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? nodeId,
      int? number,
      String? state,
      String? title,
      String? body,
      String? mergeCommitSha,
      String? mergeableState,
      String? authorAssociation,
      bool draft,
      bool merged,
      bool mergeable,
      bool rebaseable,
      bool maintainerCanModify,
      int commentsCount,
      int commitsCount,
      int additionsCount,
      int deletionsCount,
      int changedFilesCount,
      int reviewCommentCount,
      @refParam GithubRepositoryModelRef? repository,
      @refParam GithubUserModelRef? user,
      @refParam GithubUserModelRef? mergedBy,
      @refParam List<GithubUserModelRef> requestedReviewers,
      @jsonParam List<GithubLabelValue> labels,
      @jsonParam GithubPullRequestHeadValue? head,
      @jsonParam GithubPullRequestHeadValue? base,
      @jsonParam GithubMilestoneValue? milestone,
      ModelUri? htmlUrl,
      ModelUri? diffUrl,
      ModelUri? patchUrl,
      ModelTimestamp? closedAt,
      ModelTimestamp? mergedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  $GithubPullRequestHeadValueCopyWith<$Res>? get head;
  $GithubPullRequestHeadValueCopyWith<$Res>? get base;
  $GithubMilestoneValueCopyWith<$Res>? get milestone;
}

/// @nodoc
class _$GithubPullRequestModelCopyWithImpl<$Res>
    implements $GithubPullRequestModelCopyWith<$Res> {
  _$GithubPullRequestModelCopyWithImpl(this._self, this._then);

  final GithubPullRequestModel _self;
  final $Res Function(GithubPullRequestModel) _then;

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nodeId = freezed,
    Object? number = freezed,
    Object? state = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? mergeCommitSha = freezed,
    Object? mergeableState = freezed,
    Object? authorAssociation = freezed,
    Object? draft = null,
    Object? merged = null,
    Object? mergeable = null,
    Object? rebaseable = null,
    Object? maintainerCanModify = null,
    Object? commentsCount = null,
    Object? commitsCount = null,
    Object? additionsCount = null,
    Object? deletionsCount = null,
    Object? changedFilesCount = null,
    Object? reviewCommentCount = null,
    Object? repository = freezed,
    Object? user = freezed,
    Object? mergedBy = freezed,
    Object? requestedReviewers = null,
    Object? labels = null,
    Object? head = freezed,
    Object? base = freezed,
    Object? milestone = freezed,
    Object? htmlUrl = freezed,
    Object? diffUrl = freezed,
    Object? patchUrl = freezed,
    Object? closedAt = freezed,
    Object? mergedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeCommitSha: freezed == mergeCommitSha
          ? _self.mergeCommitSha
          : mergeCommitSha // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeableState: freezed == mergeableState
          ? _self.mergeableState
          : mergeableState // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      draft: null == draft
          ? _self.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as bool,
      merged: null == merged
          ? _self.merged
          : merged // ignore: cast_nullable_to_non_nullable
              as bool,
      mergeable: null == mergeable
          ? _self.mergeable
          : mergeable // ignore: cast_nullable_to_non_nullable
              as bool,
      rebaseable: null == rebaseable
          ? _self.rebaseable
          : rebaseable // ignore: cast_nullable_to_non_nullable
              as bool,
      maintainerCanModify: null == maintainerCanModify
          ? _self.maintainerCanModify
          : maintainerCanModify // ignore: cast_nullable_to_non_nullable
              as bool,
      commentsCount: null == commentsCount
          ? _self.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      commitsCount: null == commitsCount
          ? _self.commitsCount
          : commitsCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionsCount: null == additionsCount
          ? _self.additionsCount
          : additionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      deletionsCount: null == deletionsCount
          ? _self.deletionsCount
          : deletionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      changedFilesCount: null == changedFilesCount
          ? _self.changedFilesCount
          : changedFilesCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewCommentCount: null == reviewCommentCount
          ? _self.reviewCommentCount
          : reviewCommentCount // ignore: cast_nullable_to_non_nullable
              as int,
      repository: freezed == repository
          ? _self.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      mergedBy: freezed == mergedBy
          ? _self.mergedBy
          : mergedBy // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      requestedReviewers: null == requestedReviewers
          ? _self.requestedReviewers
          : requestedReviewers // ignore: cast_nullable_to_non_nullable
              as List<GithubUserModelRef>,
      labels: null == labels
          ? _self.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<GithubLabelValue>,
      head: freezed == head
          ? _self.head
          : head // ignore: cast_nullable_to_non_nullable
              as GithubPullRequestHeadValue?,
      base: freezed == base
          ? _self.base
          : base // ignore: cast_nullable_to_non_nullable
              as GithubPullRequestHeadValue?,
      milestone: freezed == milestone
          ? _self.milestone
          : milestone // ignore: cast_nullable_to_non_nullable
              as GithubMilestoneValue?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      diffUrl: freezed == diffUrl
          ? _self.diffUrl
          : diffUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      patchUrl: freezed == patchUrl
          ? _self.patchUrl
          : patchUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      mergedAt: freezed == mergedAt
          ? _self.mergedAt
          : mergedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubPullRequestHeadValueCopyWith<$Res>? get head {
    if (_self.head == null) {
      return null;
    }

    return $GithubPullRequestHeadValueCopyWith<$Res>(_self.head!, (value) {
      return _then(_self.copyWith(head: value));
    });
  }

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubPullRequestHeadValueCopyWith<$Res>? get base {
    if (_self.base == null) {
      return null;
    }

    return $GithubPullRequestHeadValueCopyWith<$Res>(_self.base!, (value) {
      return _then(_self.copyWith(base: value));
    });
  }

  /// Create a copy of GithubPullRequestModel
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
}

/// Adds pattern-matching-related methods to [GithubPullRequestModel].
extension GithubPullRequestModelPatterns on GithubPullRequestModel {
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
    TResult Function(_GithubPullRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestModel() when $default != null:
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
    TResult Function(_GithubPullRequestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestModel():
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
    TResult? Function(_GithubPullRequestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestModel() when $default != null:
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
            String? nodeId,
            int? number,
            String? state,
            String? title,
            String? body,
            String? mergeCommitSha,
            String? mergeableState,
            String? authorAssociation,
            bool draft,
            bool merged,
            bool mergeable,
            bool rebaseable,
            bool maintainerCanModify,
            int commentsCount,
            int commitsCount,
            int additionsCount,
            int deletionsCount,
            int changedFilesCount,
            int reviewCommentCount,
            @refParam GithubRepositoryModelRef? repository,
            @refParam GithubUserModelRef? user,
            @refParam GithubUserModelRef? mergedBy,
            @refParam List<GithubUserModelRef> requestedReviewers,
            @jsonParam List<GithubLabelValue> labels,
            @jsonParam GithubPullRequestHeadValue? head,
            @jsonParam GithubPullRequestHeadValue? base,
            @jsonParam GithubMilestoneValue? milestone,
            ModelUri? htmlUrl,
            ModelUri? diffUrl,
            ModelUri? patchUrl,
            ModelTimestamp? closedAt,
            ModelTimestamp? mergedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestModel() when $default != null:
        return $default(
            _that.id,
            _that.nodeId,
            _that.number,
            _that.state,
            _that.title,
            _that.body,
            _that.mergeCommitSha,
            _that.mergeableState,
            _that.authorAssociation,
            _that.draft,
            _that.merged,
            _that.mergeable,
            _that.rebaseable,
            _that.maintainerCanModify,
            _that.commentsCount,
            _that.commitsCount,
            _that.additionsCount,
            _that.deletionsCount,
            _that.changedFilesCount,
            _that.reviewCommentCount,
            _that.repository,
            _that.user,
            _that.mergedBy,
            _that.requestedReviewers,
            _that.labels,
            _that.head,
            _that.base,
            _that.milestone,
            _that.htmlUrl,
            _that.diffUrl,
            _that.patchUrl,
            _that.closedAt,
            _that.mergedAt,
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
            String? nodeId,
            int? number,
            String? state,
            String? title,
            String? body,
            String? mergeCommitSha,
            String? mergeableState,
            String? authorAssociation,
            bool draft,
            bool merged,
            bool mergeable,
            bool rebaseable,
            bool maintainerCanModify,
            int commentsCount,
            int commitsCount,
            int additionsCount,
            int deletionsCount,
            int changedFilesCount,
            int reviewCommentCount,
            @refParam GithubRepositoryModelRef? repository,
            @refParam GithubUserModelRef? user,
            @refParam GithubUserModelRef? mergedBy,
            @refParam List<GithubUserModelRef> requestedReviewers,
            @jsonParam List<GithubLabelValue> labels,
            @jsonParam GithubPullRequestHeadValue? head,
            @jsonParam GithubPullRequestHeadValue? base,
            @jsonParam GithubMilestoneValue? milestone,
            ModelUri? htmlUrl,
            ModelUri? diffUrl,
            ModelUri? patchUrl,
            ModelTimestamp? closedAt,
            ModelTimestamp? mergedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestModel():
        return $default(
            _that.id,
            _that.nodeId,
            _that.number,
            _that.state,
            _that.title,
            _that.body,
            _that.mergeCommitSha,
            _that.mergeableState,
            _that.authorAssociation,
            _that.draft,
            _that.merged,
            _that.mergeable,
            _that.rebaseable,
            _that.maintainerCanModify,
            _that.commentsCount,
            _that.commitsCount,
            _that.additionsCount,
            _that.deletionsCount,
            _that.changedFilesCount,
            _that.reviewCommentCount,
            _that.repository,
            _that.user,
            _that.mergedBy,
            _that.requestedReviewers,
            _that.labels,
            _that.head,
            _that.base,
            _that.milestone,
            _that.htmlUrl,
            _that.diffUrl,
            _that.patchUrl,
            _that.closedAt,
            _that.mergedAt,
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
            String? nodeId,
            int? number,
            String? state,
            String? title,
            String? body,
            String? mergeCommitSha,
            String? mergeableState,
            String? authorAssociation,
            bool draft,
            bool merged,
            bool mergeable,
            bool rebaseable,
            bool maintainerCanModify,
            int commentsCount,
            int commitsCount,
            int additionsCount,
            int deletionsCount,
            int changedFilesCount,
            int reviewCommentCount,
            @refParam GithubRepositoryModelRef? repository,
            @refParam GithubUserModelRef? user,
            @refParam GithubUserModelRef? mergedBy,
            @refParam List<GithubUserModelRef> requestedReviewers,
            @jsonParam List<GithubLabelValue> labels,
            @jsonParam GithubPullRequestHeadValue? head,
            @jsonParam GithubPullRequestHeadValue? base,
            @jsonParam GithubMilestoneValue? milestone,
            ModelUri? htmlUrl,
            ModelUri? diffUrl,
            ModelUri? patchUrl,
            ModelTimestamp? closedAt,
            ModelTimestamp? mergedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubPullRequestModel() when $default != null:
        return $default(
            _that.id,
            _that.nodeId,
            _that.number,
            _that.state,
            _that.title,
            _that.body,
            _that.mergeCommitSha,
            _that.mergeableState,
            _that.authorAssociation,
            _that.draft,
            _that.merged,
            _that.mergeable,
            _that.rebaseable,
            _that.maintainerCanModify,
            _that.commentsCount,
            _that.commitsCount,
            _that.additionsCount,
            _that.deletionsCount,
            _that.changedFilesCount,
            _that.reviewCommentCount,
            _that.repository,
            _that.user,
            _that.mergedBy,
            _that.requestedReviewers,
            _that.labels,
            _that.head,
            _that.base,
            _that.milestone,
            _that.htmlUrl,
            _that.diffUrl,
            _that.patchUrl,
            _that.closedAt,
            _that.mergedAt,
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
class _GithubPullRequestModel extends GithubPullRequestModel {
  const _GithubPullRequestModel(
      {this.id,
      this.nodeId,
      this.number,
      this.state,
      this.title,
      this.body,
      this.mergeCommitSha,
      this.mergeableState,
      this.authorAssociation,
      this.draft = false,
      this.merged = false,
      this.mergeable = false,
      this.rebaseable = false,
      this.maintainerCanModify = false,
      this.commentsCount = 0,
      this.commitsCount = 0,
      this.additionsCount = 0,
      this.deletionsCount = 0,
      this.changedFilesCount = 0,
      this.reviewCommentCount = 0,
      @refParam this.repository,
      @refParam this.user,
      @refParam this.mergedBy,
      @refParam final List<GithubUserModelRef> requestedReviewers = const [],
      @jsonParam
      final List<GithubLabelValue> labels = const <GithubLabelValue>[],
      @jsonParam this.head,
      @jsonParam this.base,
      @jsonParam this.milestone,
      this.htmlUrl,
      this.diffUrl,
      this.patchUrl,
      this.closedAt,
      this.mergedAt,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now(),
      this.fromServer = false})
      : _requestedReviewers = requestedReviewers,
        _labels = labels,
        super._();
  factory _GithubPullRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GithubPullRequestModelFromJson(json);

  @override
  final int? id;
  @override
  final String? nodeId;
  @override
  final int? number;
  @override
  final String? state;
  @override
  final String? title;
  @override
  final String? body;
  @override
  final String? mergeCommitSha;
  @override
  final String? mergeableState;
  @override
  final String? authorAssociation;
  @override
  @JsonKey()
  final bool draft;
  @override
  @JsonKey()
  final bool merged;
  @override
  @JsonKey()
  final bool mergeable;
  @override
  @JsonKey()
  final bool rebaseable;
  @override
  @JsonKey()
  final bool maintainerCanModify;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final int commitsCount;
  @override
  @JsonKey()
  final int additionsCount;
  @override
  @JsonKey()
  final int deletionsCount;
  @override
  @JsonKey()
  final int changedFilesCount;
  @override
  @JsonKey()
  final int reviewCommentCount;
  @override
  @refParam
  final GithubRepositoryModelRef? repository;
  @override
  @refParam
  final GithubUserModelRef? user;
  @override
  @refParam
  final GithubUserModelRef? mergedBy;
  final List<GithubUserModelRef> _requestedReviewers;
  @override
  @JsonKey()
  @refParam
  List<GithubUserModelRef> get requestedReviewers {
    if (_requestedReviewers is EqualUnmodifiableListView)
      return _requestedReviewers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requestedReviewers);
  }

  final List<GithubLabelValue> _labels;
  @override
  @JsonKey()
  @jsonParam
  List<GithubLabelValue> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  @override
  @jsonParam
  final GithubPullRequestHeadValue? head;
  @override
  @jsonParam
  final GithubPullRequestHeadValue? base;
  @override
  @jsonParam
  final GithubMilestoneValue? milestone;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? diffUrl;
  @override
  final ModelUri? patchUrl;
  @override
  final ModelTimestamp? closedAt;
  @override
  final ModelTimestamp? mergedAt;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubPullRequestModelCopyWith<_GithubPullRequestModel> get copyWith =>
      __$GithubPullRequestModelCopyWithImpl<_GithubPullRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubPullRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubPullRequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.mergeCommitSha, mergeCommitSha) ||
                other.mergeCommitSha == mergeCommitSha) &&
            (identical(other.mergeableState, mergeableState) ||
                other.mergeableState == mergeableState) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.merged, merged) || other.merged == merged) &&
            (identical(other.mergeable, mergeable) ||
                other.mergeable == mergeable) &&
            (identical(other.rebaseable, rebaseable) ||
                other.rebaseable == rebaseable) &&
            (identical(other.maintainerCanModify, maintainerCanModify) ||
                other.maintainerCanModify == maintainerCanModify) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.commitsCount, commitsCount) ||
                other.commitsCount == commitsCount) &&
            (identical(other.additionsCount, additionsCount) ||
                other.additionsCount == additionsCount) &&
            (identical(other.deletionsCount, deletionsCount) ||
                other.deletionsCount == deletionsCount) &&
            (identical(other.changedFilesCount, changedFilesCount) ||
                other.changedFilesCount == changedFilesCount) &&
            (identical(other.reviewCommentCount, reviewCommentCount) ||
                other.reviewCommentCount == reviewCommentCount) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.mergedBy, mergedBy) ||
                other.mergedBy == mergedBy) &&
            const DeepCollectionEquality()
                .equals(other._requestedReviewers, _requestedReviewers) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.head, head) || other.head == head) &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.milestone, milestone) ||
                other.milestone == milestone) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.diffUrl, diffUrl) || other.diffUrl == diffUrl) &&
            (identical(other.patchUrl, patchUrl) ||
                other.patchUrl == patchUrl) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.mergedAt, mergedAt) ||
                other.mergedAt == mergedAt) &&
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
        nodeId,
        number,
        state,
        title,
        body,
        mergeCommitSha,
        mergeableState,
        authorAssociation,
        draft,
        merged,
        mergeable,
        rebaseable,
        maintainerCanModify,
        commentsCount,
        commitsCount,
        additionsCount,
        deletionsCount,
        changedFilesCount,
        reviewCommentCount,
        repository,
        user,
        mergedBy,
        const DeepCollectionEquality().hash(_requestedReviewers),
        const DeepCollectionEquality().hash(_labels),
        head,
        base,
        milestone,
        htmlUrl,
        diffUrl,
        patchUrl,
        closedAt,
        mergedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubPullRequestModel(id: $id, nodeId: $nodeId, number: $number, state: $state, title: $title, body: $body, mergeCommitSha: $mergeCommitSha, mergeableState: $mergeableState, authorAssociation: $authorAssociation, draft: $draft, merged: $merged, mergeable: $mergeable, rebaseable: $rebaseable, maintainerCanModify: $maintainerCanModify, commentsCount: $commentsCount, commitsCount: $commitsCount, additionsCount: $additionsCount, deletionsCount: $deletionsCount, changedFilesCount: $changedFilesCount, reviewCommentCount: $reviewCommentCount, repository: $repository, user: $user, mergedBy: $mergedBy, requestedReviewers: $requestedReviewers, labels: $labels, head: $head, base: $base, milestone: $milestone, htmlUrl: $htmlUrl, diffUrl: $diffUrl, patchUrl: $patchUrl, closedAt: $closedAt, mergedAt: $mergedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubPullRequestModelCopyWith<$Res>
    implements $GithubPullRequestModelCopyWith<$Res> {
  factory _$GithubPullRequestModelCopyWith(_GithubPullRequestModel value,
          $Res Function(_GithubPullRequestModel) _then) =
      __$GithubPullRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? nodeId,
      int? number,
      String? state,
      String? title,
      String? body,
      String? mergeCommitSha,
      String? mergeableState,
      String? authorAssociation,
      bool draft,
      bool merged,
      bool mergeable,
      bool rebaseable,
      bool maintainerCanModify,
      int commentsCount,
      int commitsCount,
      int additionsCount,
      int deletionsCount,
      int changedFilesCount,
      int reviewCommentCount,
      @refParam GithubRepositoryModelRef? repository,
      @refParam GithubUserModelRef? user,
      @refParam GithubUserModelRef? mergedBy,
      @refParam List<GithubUserModelRef> requestedReviewers,
      @jsonParam List<GithubLabelValue> labels,
      @jsonParam GithubPullRequestHeadValue? head,
      @jsonParam GithubPullRequestHeadValue? base,
      @jsonParam GithubMilestoneValue? milestone,
      ModelUri? htmlUrl,
      ModelUri? diffUrl,
      ModelUri? patchUrl,
      ModelTimestamp? closedAt,
      ModelTimestamp? mergedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  @override
  $GithubPullRequestHeadValueCopyWith<$Res>? get head;
  @override
  $GithubPullRequestHeadValueCopyWith<$Res>? get base;
  @override
  $GithubMilestoneValueCopyWith<$Res>? get milestone;
}

/// @nodoc
class __$GithubPullRequestModelCopyWithImpl<$Res>
    implements _$GithubPullRequestModelCopyWith<$Res> {
  __$GithubPullRequestModelCopyWithImpl(this._self, this._then);

  final _GithubPullRequestModel _self;
  final $Res Function(_GithubPullRequestModel) _then;

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? nodeId = freezed,
    Object? number = freezed,
    Object? state = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? mergeCommitSha = freezed,
    Object? mergeableState = freezed,
    Object? authorAssociation = freezed,
    Object? draft = null,
    Object? merged = null,
    Object? mergeable = null,
    Object? rebaseable = null,
    Object? maintainerCanModify = null,
    Object? commentsCount = null,
    Object? commitsCount = null,
    Object? additionsCount = null,
    Object? deletionsCount = null,
    Object? changedFilesCount = null,
    Object? reviewCommentCount = null,
    Object? repository = freezed,
    Object? user = freezed,
    Object? mergedBy = freezed,
    Object? requestedReviewers = null,
    Object? labels = null,
    Object? head = freezed,
    Object? base = freezed,
    Object? milestone = freezed,
    Object? htmlUrl = freezed,
    Object? diffUrl = freezed,
    Object? patchUrl = freezed,
    Object? closedAt = freezed,
    Object? mergedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubPullRequestModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeCommitSha: freezed == mergeCommitSha
          ? _self.mergeCommitSha
          : mergeCommitSha // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeableState: freezed == mergeableState
          ? _self.mergeableState
          : mergeableState // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      draft: null == draft
          ? _self.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as bool,
      merged: null == merged
          ? _self.merged
          : merged // ignore: cast_nullable_to_non_nullable
              as bool,
      mergeable: null == mergeable
          ? _self.mergeable
          : mergeable // ignore: cast_nullable_to_non_nullable
              as bool,
      rebaseable: null == rebaseable
          ? _self.rebaseable
          : rebaseable // ignore: cast_nullable_to_non_nullable
              as bool,
      maintainerCanModify: null == maintainerCanModify
          ? _self.maintainerCanModify
          : maintainerCanModify // ignore: cast_nullable_to_non_nullable
              as bool,
      commentsCount: null == commentsCount
          ? _self.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      commitsCount: null == commitsCount
          ? _self.commitsCount
          : commitsCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionsCount: null == additionsCount
          ? _self.additionsCount
          : additionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      deletionsCount: null == deletionsCount
          ? _self.deletionsCount
          : deletionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      changedFilesCount: null == changedFilesCount
          ? _self.changedFilesCount
          : changedFilesCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewCommentCount: null == reviewCommentCount
          ? _self.reviewCommentCount
          : reviewCommentCount // ignore: cast_nullable_to_non_nullable
              as int,
      repository: freezed == repository
          ? _self.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      mergedBy: freezed == mergedBy
          ? _self.mergedBy
          : mergedBy // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      requestedReviewers: null == requestedReviewers
          ? _self._requestedReviewers
          : requestedReviewers // ignore: cast_nullable_to_non_nullable
              as List<GithubUserModelRef>,
      labels: null == labels
          ? _self._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<GithubLabelValue>,
      head: freezed == head
          ? _self.head
          : head // ignore: cast_nullable_to_non_nullable
              as GithubPullRequestHeadValue?,
      base: freezed == base
          ? _self.base
          : base // ignore: cast_nullable_to_non_nullable
              as GithubPullRequestHeadValue?,
      milestone: freezed == milestone
          ? _self.milestone
          : milestone // ignore: cast_nullable_to_non_nullable
              as GithubMilestoneValue?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      diffUrl: freezed == diffUrl
          ? _self.diffUrl
          : diffUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      patchUrl: freezed == patchUrl
          ? _self.patchUrl
          : patchUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      mergedAt: freezed == mergedAt
          ? _self.mergedAt
          : mergedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubPullRequestHeadValueCopyWith<$Res>? get head {
    if (_self.head == null) {
      return null;
    }

    return $GithubPullRequestHeadValueCopyWith<$Res>(_self.head!, (value) {
      return _then(_self.copyWith(head: value));
    });
  }

  /// Create a copy of GithubPullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubPullRequestHeadValueCopyWith<$Res>? get base {
    if (_self.base == null) {
      return null;
    }

    return $GithubPullRequestHeadValueCopyWith<$Res>(_self.base!, (value) {
      return _then(_self.copyWith(base: value));
    });
  }

  /// Create a copy of GithubPullRequestModel
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
}

// dart format on
