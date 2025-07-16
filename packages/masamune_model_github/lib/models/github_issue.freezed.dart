// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubIssueModel {
  int? get id;
  int? get number;
  String? get title;
  String? get body;
  String? get bodyHtml;
  String? get bodyText;
  String? get state;
  String? get stateReason;
  String? get activeLockReason;
  String? get authorAssociation;
  String? get nodeId;
  bool get draft;
  bool get locked;
  int get commentsCount;
  @refParam
  GithubRepositoryModelRef? get repository;
  @refParam
  GithubUserModelRef? get user;
  @refParam
  GithubUserModelRef? get assignee;
  @refParam
  List<GithubUserModelRef> get assignees;
  @refParam
  GithubUserModelRef? get closedBy;
  @jsonParam
  List<GithubLabelValue> get labels;
  ModelUri? get url;
  ModelUri? get htmlUrl;
  ModelUri? get commentsUrl;
  ModelUri? get eventsUrl;
  ModelUri? get labelsUrl;
  ModelUri? get repositoryUrl;
  ModelUri? get timelineUrl;
  @jsonParam
  GithubReactionValue? get reactions;
  ModelTimestamp? get closedAt;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;
  bool get fromServer;

  /// Create a copy of GithubIssueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubIssueModelCopyWith<GithubIssueModel> get copyWith =>
      _$GithubIssueModelCopyWithImpl<GithubIssueModel>(
          this as GithubIssueModel, _$identity);

  /// Serializes this GithubIssueModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubIssueModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.bodyHtml, bodyHtml) ||
                other.bodyHtml == bodyHtml) &&
            (identical(other.bodyText, bodyText) ||
                other.bodyText == bodyText) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.stateReason, stateReason) ||
                other.stateReason == stateReason) &&
            (identical(other.activeLockReason, activeLockReason) ||
                other.activeLockReason == activeLockReason) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.locked, locked) || other.locked == locked) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.assignee, assignee) ||
                other.assignee == assignee) &&
            const DeepCollectionEquality().equals(other.assignees, assignees) &&
            (identical(other.closedBy, closedBy) ||
                other.closedBy == closedBy) &&
            const DeepCollectionEquality().equals(other.labels, labels) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.commentsUrl, commentsUrl) ||
                other.commentsUrl == commentsUrl) &&
            (identical(other.eventsUrl, eventsUrl) ||
                other.eventsUrl == eventsUrl) &&
            (identical(other.labelsUrl, labelsUrl) ||
                other.labelsUrl == labelsUrl) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.timelineUrl, timelineUrl) ||
                other.timelineUrl == timelineUrl) &&
            (identical(other.reactions, reactions) ||
                other.reactions == reactions) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
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
        number,
        title,
        body,
        bodyHtml,
        bodyText,
        state,
        stateReason,
        activeLockReason,
        authorAssociation,
        nodeId,
        draft,
        locked,
        commentsCount,
        repository,
        user,
        assignee,
        const DeepCollectionEquality().hash(assignees),
        closedBy,
        const DeepCollectionEquality().hash(labels),
        url,
        htmlUrl,
        commentsUrl,
        eventsUrl,
        labelsUrl,
        repositoryUrl,
        timelineUrl,
        reactions,
        closedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubIssueModel(id: $id, number: $number, title: $title, body: $body, bodyHtml: $bodyHtml, bodyText: $bodyText, state: $state, stateReason: $stateReason, activeLockReason: $activeLockReason, authorAssociation: $authorAssociation, nodeId: $nodeId, draft: $draft, locked: $locked, commentsCount: $commentsCount, repository: $repository, user: $user, assignee: $assignee, assignees: $assignees, closedBy: $closedBy, labels: $labels, url: $url, htmlUrl: $htmlUrl, commentsUrl: $commentsUrl, eventsUrl: $eventsUrl, labelsUrl: $labelsUrl, repositoryUrl: $repositoryUrl, timelineUrl: $timelineUrl, reactions: $reactions, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubIssueModelCopyWith<$Res> {
  factory $GithubIssueModelCopyWith(
          GithubIssueModel value, $Res Function(GithubIssueModel) _then) =
      _$GithubIssueModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      int? number,
      String? title,
      String? body,
      String? bodyHtml,
      String? bodyText,
      String? state,
      String? stateReason,
      String? activeLockReason,
      String? authorAssociation,
      String? nodeId,
      bool draft,
      bool locked,
      int commentsCount,
      @refParam GithubRepositoryModelRef? repository,
      @refParam GithubUserModelRef? user,
      @refParam GithubUserModelRef? assignee,
      @refParam List<GithubUserModelRef> assignees,
      @refParam GithubUserModelRef? closedBy,
      @jsonParam List<GithubLabelValue> labels,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? commentsUrl,
      ModelUri? eventsUrl,
      ModelUri? labelsUrl,
      ModelUri? repositoryUrl,
      ModelUri? timelineUrl,
      @jsonParam GithubReactionValue? reactions,
      ModelTimestamp? closedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  $GithubReactionValueCopyWith<$Res>? get reactions;
}

/// @nodoc
class _$GithubIssueModelCopyWithImpl<$Res>
    implements $GithubIssueModelCopyWith<$Res> {
  _$GithubIssueModelCopyWithImpl(this._self, this._then);

  final GithubIssueModel _self;
  final $Res Function(GithubIssueModel) _then;

  /// Create a copy of GithubIssueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? number = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? bodyHtml = freezed,
    Object? bodyText = freezed,
    Object? state = freezed,
    Object? stateReason = freezed,
    Object? activeLockReason = freezed,
    Object? authorAssociation = freezed,
    Object? nodeId = freezed,
    Object? draft = null,
    Object? locked = null,
    Object? commentsCount = null,
    Object? repository = freezed,
    Object? user = freezed,
    Object? assignee = freezed,
    Object? assignees = null,
    Object? closedBy = freezed,
    Object? labels = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? commentsUrl = freezed,
    Object? eventsUrl = freezed,
    Object? labelsUrl = freezed,
    Object? repositoryUrl = freezed,
    Object? timelineUrl = freezed,
    Object? reactions = freezed,
    Object? closedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyHtml: freezed == bodyHtml
          ? _self.bodyHtml
          : bodyHtml // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyText: freezed == bodyText
          ? _self.bodyText
          : bodyText // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      stateReason: freezed == stateReason
          ? _self.stateReason
          : stateReason // ignore: cast_nullable_to_non_nullable
              as String?,
      activeLockReason: freezed == activeLockReason
          ? _self.activeLockReason
          : activeLockReason // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      draft: null == draft
          ? _self.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as bool,
      locked: null == locked
          ? _self.locked
          : locked // ignore: cast_nullable_to_non_nullable
              as bool,
      commentsCount: null == commentsCount
          ? _self.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      repository: freezed == repository
          ? _self.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      assignee: freezed == assignee
          ? _self.assignee
          : assignee // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      assignees: null == assignees
          ? _self.assignees
          : assignees // ignore: cast_nullable_to_non_nullable
              as List<GithubUserModelRef>,
      closedBy: freezed == closedBy
          ? _self.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      labels: null == labels
          ? _self.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<GithubLabelValue>,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commentsUrl: freezed == commentsUrl
          ? _self.commentsUrl
          : commentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      eventsUrl: freezed == eventsUrl
          ? _self.eventsUrl
          : eventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      labelsUrl: freezed == labelsUrl
          ? _self.labelsUrl
          : labelsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      repositoryUrl: freezed == repositoryUrl
          ? _self.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      timelineUrl: freezed == timelineUrl
          ? _self.timelineUrl
          : timelineUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      reactions: freezed == reactions
          ? _self.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as GithubReactionValue?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of GithubIssueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubReactionValueCopyWith<$Res>? get reactions {
    if (_self.reactions == null) {
      return null;
    }

    return $GithubReactionValueCopyWith<$Res>(_self.reactions!, (value) {
      return _then(_self.copyWith(reactions: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GithubIssueModel].
extension GithubIssueModelPatterns on GithubIssueModel {
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
    TResult Function(_GithubIssueModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubIssueModel() when $default != null:
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
    TResult Function(_GithubIssueModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueModel():
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
    TResult? Function(_GithubIssueModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueModel() when $default != null:
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
            int? number,
            String? title,
            String? body,
            String? bodyHtml,
            String? bodyText,
            String? state,
            String? stateReason,
            String? activeLockReason,
            String? authorAssociation,
            String? nodeId,
            bool draft,
            bool locked,
            int commentsCount,
            @refParam GithubRepositoryModelRef? repository,
            @refParam GithubUserModelRef? user,
            @refParam GithubUserModelRef? assignee,
            @refParam List<GithubUserModelRef> assignees,
            @refParam GithubUserModelRef? closedBy,
            @jsonParam List<GithubLabelValue> labels,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? commentsUrl,
            ModelUri? eventsUrl,
            ModelUri? labelsUrl,
            ModelUri? repositoryUrl,
            ModelUri? timelineUrl,
            @jsonParam GithubReactionValue? reactions,
            ModelTimestamp? closedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubIssueModel() when $default != null:
        return $default(
            _that.id,
            _that.number,
            _that.title,
            _that.body,
            _that.bodyHtml,
            _that.bodyText,
            _that.state,
            _that.stateReason,
            _that.activeLockReason,
            _that.authorAssociation,
            _that.nodeId,
            _that.draft,
            _that.locked,
            _that.commentsCount,
            _that.repository,
            _that.user,
            _that.assignee,
            _that.assignees,
            _that.closedBy,
            _that.labels,
            _that.url,
            _that.htmlUrl,
            _that.commentsUrl,
            _that.eventsUrl,
            _that.labelsUrl,
            _that.repositoryUrl,
            _that.timelineUrl,
            _that.reactions,
            _that.closedAt,
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
            int? number,
            String? title,
            String? body,
            String? bodyHtml,
            String? bodyText,
            String? state,
            String? stateReason,
            String? activeLockReason,
            String? authorAssociation,
            String? nodeId,
            bool draft,
            bool locked,
            int commentsCount,
            @refParam GithubRepositoryModelRef? repository,
            @refParam GithubUserModelRef? user,
            @refParam GithubUserModelRef? assignee,
            @refParam List<GithubUserModelRef> assignees,
            @refParam GithubUserModelRef? closedBy,
            @jsonParam List<GithubLabelValue> labels,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? commentsUrl,
            ModelUri? eventsUrl,
            ModelUri? labelsUrl,
            ModelUri? repositoryUrl,
            ModelUri? timelineUrl,
            @jsonParam GithubReactionValue? reactions,
            ModelTimestamp? closedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueModel():
        return $default(
            _that.id,
            _that.number,
            _that.title,
            _that.body,
            _that.bodyHtml,
            _that.bodyText,
            _that.state,
            _that.stateReason,
            _that.activeLockReason,
            _that.authorAssociation,
            _that.nodeId,
            _that.draft,
            _that.locked,
            _that.commentsCount,
            _that.repository,
            _that.user,
            _that.assignee,
            _that.assignees,
            _that.closedBy,
            _that.labels,
            _that.url,
            _that.htmlUrl,
            _that.commentsUrl,
            _that.eventsUrl,
            _that.labelsUrl,
            _that.repositoryUrl,
            _that.timelineUrl,
            _that.reactions,
            _that.closedAt,
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
            int? number,
            String? title,
            String? body,
            String? bodyHtml,
            String? bodyText,
            String? state,
            String? stateReason,
            String? activeLockReason,
            String? authorAssociation,
            String? nodeId,
            bool draft,
            bool locked,
            int commentsCount,
            @refParam GithubRepositoryModelRef? repository,
            @refParam GithubUserModelRef? user,
            @refParam GithubUserModelRef? assignee,
            @refParam List<GithubUserModelRef> assignees,
            @refParam GithubUserModelRef? closedBy,
            @jsonParam List<GithubLabelValue> labels,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? commentsUrl,
            ModelUri? eventsUrl,
            ModelUri? labelsUrl,
            ModelUri? repositoryUrl,
            ModelUri? timelineUrl,
            @jsonParam GithubReactionValue? reactions,
            ModelTimestamp? closedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubIssueModel() when $default != null:
        return $default(
            _that.id,
            _that.number,
            _that.title,
            _that.body,
            _that.bodyHtml,
            _that.bodyText,
            _that.state,
            _that.stateReason,
            _that.activeLockReason,
            _that.authorAssociation,
            _that.nodeId,
            _that.draft,
            _that.locked,
            _that.commentsCount,
            _that.repository,
            _that.user,
            _that.assignee,
            _that.assignees,
            _that.closedBy,
            _that.labels,
            _that.url,
            _that.htmlUrl,
            _that.commentsUrl,
            _that.eventsUrl,
            _that.labelsUrl,
            _that.repositoryUrl,
            _that.timelineUrl,
            _that.reactions,
            _that.closedAt,
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
class _GithubIssueModel extends GithubIssueModel {
  const _GithubIssueModel(
      {this.id,
      this.number,
      this.title,
      this.body,
      this.bodyHtml,
      this.bodyText,
      this.state,
      this.stateReason,
      this.activeLockReason,
      this.authorAssociation,
      this.nodeId,
      this.draft = false,
      this.locked = false,
      this.commentsCount = 0,
      @refParam this.repository,
      @refParam this.user,
      @refParam this.assignee,
      @refParam final List<GithubUserModelRef> assignees = const [],
      @refParam this.closedBy,
      @jsonParam
      final List<GithubLabelValue> labels = const <GithubLabelValue>[],
      this.url,
      this.htmlUrl,
      this.commentsUrl,
      this.eventsUrl,
      this.labelsUrl,
      this.repositoryUrl,
      this.timelineUrl,
      @jsonParam this.reactions,
      this.closedAt,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now(),
      this.fromServer = false})
      : _assignees = assignees,
        _labels = labels,
        super._();
  factory _GithubIssueModel.fromJson(Map<String, dynamic> json) =>
      _$GithubIssueModelFromJson(json);

  @override
  final int? id;
  @override
  final int? number;
  @override
  final String? title;
  @override
  final String? body;
  @override
  final String? bodyHtml;
  @override
  final String? bodyText;
  @override
  final String? state;
  @override
  final String? stateReason;
  @override
  final String? activeLockReason;
  @override
  final String? authorAssociation;
  @override
  final String? nodeId;
  @override
  @JsonKey()
  final bool draft;
  @override
  @JsonKey()
  final bool locked;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @refParam
  final GithubRepositoryModelRef? repository;
  @override
  @refParam
  final GithubUserModelRef? user;
  @override
  @refParam
  final GithubUserModelRef? assignee;
  final List<GithubUserModelRef> _assignees;
  @override
  @JsonKey()
  @refParam
  List<GithubUserModelRef> get assignees {
    if (_assignees is EqualUnmodifiableListView) return _assignees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignees);
  }

  @override
  @refParam
  final GithubUserModelRef? closedBy;
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
  final ModelUri? url;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? commentsUrl;
  @override
  final ModelUri? eventsUrl;
  @override
  final ModelUri? labelsUrl;
  @override
  final ModelUri? repositoryUrl;
  @override
  final ModelUri? timelineUrl;
  @override
  @jsonParam
  final GithubReactionValue? reactions;
  @override
  final ModelTimestamp? closedAt;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubIssueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubIssueModelCopyWith<_GithubIssueModel> get copyWith =>
      __$GithubIssueModelCopyWithImpl<_GithubIssueModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubIssueModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubIssueModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.bodyHtml, bodyHtml) ||
                other.bodyHtml == bodyHtml) &&
            (identical(other.bodyText, bodyText) ||
                other.bodyText == bodyText) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.stateReason, stateReason) ||
                other.stateReason == stateReason) &&
            (identical(other.activeLockReason, activeLockReason) ||
                other.activeLockReason == activeLockReason) &&
            (identical(other.authorAssociation, authorAssociation) ||
                other.authorAssociation == authorAssociation) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.locked, locked) || other.locked == locked) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.assignee, assignee) ||
                other.assignee == assignee) &&
            const DeepCollectionEquality()
                .equals(other._assignees, _assignees) &&
            (identical(other.closedBy, closedBy) ||
                other.closedBy == closedBy) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.commentsUrl, commentsUrl) ||
                other.commentsUrl == commentsUrl) &&
            (identical(other.eventsUrl, eventsUrl) ||
                other.eventsUrl == eventsUrl) &&
            (identical(other.labelsUrl, labelsUrl) ||
                other.labelsUrl == labelsUrl) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.timelineUrl, timelineUrl) ||
                other.timelineUrl == timelineUrl) &&
            (identical(other.reactions, reactions) ||
                other.reactions == reactions) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
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
        number,
        title,
        body,
        bodyHtml,
        bodyText,
        state,
        stateReason,
        activeLockReason,
        authorAssociation,
        nodeId,
        draft,
        locked,
        commentsCount,
        repository,
        user,
        assignee,
        const DeepCollectionEquality().hash(_assignees),
        closedBy,
        const DeepCollectionEquality().hash(_labels),
        url,
        htmlUrl,
        commentsUrl,
        eventsUrl,
        labelsUrl,
        repositoryUrl,
        timelineUrl,
        reactions,
        closedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubIssueModel(id: $id, number: $number, title: $title, body: $body, bodyHtml: $bodyHtml, bodyText: $bodyText, state: $state, stateReason: $stateReason, activeLockReason: $activeLockReason, authorAssociation: $authorAssociation, nodeId: $nodeId, draft: $draft, locked: $locked, commentsCount: $commentsCount, repository: $repository, user: $user, assignee: $assignee, assignees: $assignees, closedBy: $closedBy, labels: $labels, url: $url, htmlUrl: $htmlUrl, commentsUrl: $commentsUrl, eventsUrl: $eventsUrl, labelsUrl: $labelsUrl, repositoryUrl: $repositoryUrl, timelineUrl: $timelineUrl, reactions: $reactions, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubIssueModelCopyWith<$Res>
    implements $GithubIssueModelCopyWith<$Res> {
  factory _$GithubIssueModelCopyWith(
          _GithubIssueModel value, $Res Function(_GithubIssueModel) _then) =
      __$GithubIssueModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      int? number,
      String? title,
      String? body,
      String? bodyHtml,
      String? bodyText,
      String? state,
      String? stateReason,
      String? activeLockReason,
      String? authorAssociation,
      String? nodeId,
      bool draft,
      bool locked,
      int commentsCount,
      @refParam GithubRepositoryModelRef? repository,
      @refParam GithubUserModelRef? user,
      @refParam GithubUserModelRef? assignee,
      @refParam List<GithubUserModelRef> assignees,
      @refParam GithubUserModelRef? closedBy,
      @jsonParam List<GithubLabelValue> labels,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? commentsUrl,
      ModelUri? eventsUrl,
      ModelUri? labelsUrl,
      ModelUri? repositoryUrl,
      ModelUri? timelineUrl,
      @jsonParam GithubReactionValue? reactions,
      ModelTimestamp? closedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  @override
  $GithubReactionValueCopyWith<$Res>? get reactions;
}

/// @nodoc
class __$GithubIssueModelCopyWithImpl<$Res>
    implements _$GithubIssueModelCopyWith<$Res> {
  __$GithubIssueModelCopyWithImpl(this._self, this._then);

  final _GithubIssueModel _self;
  final $Res Function(_GithubIssueModel) _then;

  /// Create a copy of GithubIssueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? number = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? bodyHtml = freezed,
    Object? bodyText = freezed,
    Object? state = freezed,
    Object? stateReason = freezed,
    Object? activeLockReason = freezed,
    Object? authorAssociation = freezed,
    Object? nodeId = freezed,
    Object? draft = null,
    Object? locked = null,
    Object? commentsCount = null,
    Object? repository = freezed,
    Object? user = freezed,
    Object? assignee = freezed,
    Object? assignees = null,
    Object? closedBy = freezed,
    Object? labels = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? commentsUrl = freezed,
    Object? eventsUrl = freezed,
    Object? labelsUrl = freezed,
    Object? repositoryUrl = freezed,
    Object? timelineUrl = freezed,
    Object? reactions = freezed,
    Object? closedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubIssueModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyHtml: freezed == bodyHtml
          ? _self.bodyHtml
          : bodyHtml // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyText: freezed == bodyText
          ? _self.bodyText
          : bodyText // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      stateReason: freezed == stateReason
          ? _self.stateReason
          : stateReason // ignore: cast_nullable_to_non_nullable
              as String?,
      activeLockReason: freezed == activeLockReason
          ? _self.activeLockReason
          : activeLockReason // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAssociation: freezed == authorAssociation
          ? _self.authorAssociation
          : authorAssociation // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      draft: null == draft
          ? _self.draft
          : draft // ignore: cast_nullable_to_non_nullable
              as bool,
      locked: null == locked
          ? _self.locked
          : locked // ignore: cast_nullable_to_non_nullable
              as bool,
      commentsCount: null == commentsCount
          ? _self.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      repository: freezed == repository
          ? _self.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      assignee: freezed == assignee
          ? _self.assignee
          : assignee // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      assignees: null == assignees
          ? _self._assignees
          : assignees // ignore: cast_nullable_to_non_nullable
              as List<GithubUserModelRef>,
      closedBy: freezed == closedBy
          ? _self.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      labels: null == labels
          ? _self._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<GithubLabelValue>,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      commentsUrl: freezed == commentsUrl
          ? _self.commentsUrl
          : commentsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      eventsUrl: freezed == eventsUrl
          ? _self.eventsUrl
          : eventsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      labelsUrl: freezed == labelsUrl
          ? _self.labelsUrl
          : labelsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      repositoryUrl: freezed == repositoryUrl
          ? _self.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      timelineUrl: freezed == timelineUrl
          ? _self.timelineUrl
          : timelineUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      reactions: freezed == reactions
          ? _self.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as GithubReactionValue?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of GithubIssueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubReactionValueCopyWith<$Res>? get reactions {
    if (_self.reactions == null) {
      return null;
    }

    return $GithubReactionValueCopyWith<$Res>(_self.reactions!, (value) {
      return _then(_self.copyWith(reactions: value));
    });
  }
}

// dart format on
