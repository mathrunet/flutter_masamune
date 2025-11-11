// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_actions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubActionsModel {
  int? get id;
  int? get workflowId;
  int? get runNumber;
  int? get runAttempt;
  String? get name;
  String? get displayTitle;
  String? get event;
  String? get status;
  String? get conclusion;
  String? get headBranch;
  String? get headSha;
  String? get path;
  @jsonParam
  GithubUserModel? get actor;
  @jsonParam
  GithubUserModel? get triggeringActor;
  @refParam
  GithubRepositoryModelRef? get repository;
  ModelUri? get url;
  ModelUri? get htmlUrl;
  ModelUri? get jobsUrl;
  ModelUri? get logsUrl;
  ModelUri? get artifactsUrl;
  ModelUri? get cancelUrl;
  ModelUri? get rerunUrl;
  ModelUri? get workflowUrl;
  ModelUri? get checkSuiteUrl;
  ModelUri? get previousAttemptUrl;
  ModelTimestamp? get runStartedAt;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;
  bool get fromServer;

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubActionsModelCopyWith<GithubActionsModel> get copyWith =>
      _$GithubActionsModelCopyWithImpl<GithubActionsModel>(
          this as GithubActionsModel, _$identity);

  /// Serializes this GithubActionsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubActionsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.runNumber, runNumber) ||
                other.runNumber == runNumber) &&
            (identical(other.runAttempt, runAttempt) ||
                other.runAttempt == runAttempt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.conclusion, conclusion) ||
                other.conclusion == conclusion) &&
            (identical(other.headBranch, headBranch) ||
                other.headBranch == headBranch) &&
            (identical(other.headSha, headSha) || other.headSha == headSha) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.actor, actor) || other.actor == actor) &&
            (identical(other.triggeringActor, triggeringActor) ||
                other.triggeringActor == triggeringActor) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.jobsUrl, jobsUrl) || other.jobsUrl == jobsUrl) &&
            (identical(other.logsUrl, logsUrl) || other.logsUrl == logsUrl) &&
            (identical(other.artifactsUrl, artifactsUrl) ||
                other.artifactsUrl == artifactsUrl) &&
            (identical(other.cancelUrl, cancelUrl) ||
                other.cancelUrl == cancelUrl) &&
            (identical(other.rerunUrl, rerunUrl) ||
                other.rerunUrl == rerunUrl) &&
            (identical(other.workflowUrl, workflowUrl) ||
                other.workflowUrl == workflowUrl) &&
            (identical(other.checkSuiteUrl, checkSuiteUrl) ||
                other.checkSuiteUrl == checkSuiteUrl) &&
            (identical(other.previousAttemptUrl, previousAttemptUrl) ||
                other.previousAttemptUrl == previousAttemptUrl) &&
            (identical(other.runStartedAt, runStartedAt) ||
                other.runStartedAt == runStartedAt) &&
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
        workflowId,
        runNumber,
        runAttempt,
        name,
        displayTitle,
        event,
        status,
        conclusion,
        headBranch,
        headSha,
        path,
        actor,
        triggeringActor,
        repository,
        url,
        htmlUrl,
        jobsUrl,
        logsUrl,
        artifactsUrl,
        cancelUrl,
        rerunUrl,
        workflowUrl,
        checkSuiteUrl,
        previousAttemptUrl,
        runStartedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubActionsModel(id: $id, workflowId: $workflowId, runNumber: $runNumber, runAttempt: $runAttempt, name: $name, displayTitle: $displayTitle, event: $event, status: $status, conclusion: $conclusion, headBranch: $headBranch, headSha: $headSha, path: $path, actor: $actor, triggeringActor: $triggeringActor, repository: $repository, url: $url, htmlUrl: $htmlUrl, jobsUrl: $jobsUrl, logsUrl: $logsUrl, artifactsUrl: $artifactsUrl, cancelUrl: $cancelUrl, rerunUrl: $rerunUrl, workflowUrl: $workflowUrl, checkSuiteUrl: $checkSuiteUrl, previousAttemptUrl: $previousAttemptUrl, runStartedAt: $runStartedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubActionsModelCopyWith<$Res> {
  factory $GithubActionsModelCopyWith(
          GithubActionsModel value, $Res Function(GithubActionsModel) _then) =
      _$GithubActionsModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      int? workflowId,
      int? runNumber,
      int? runAttempt,
      String? name,
      String? displayTitle,
      String? event,
      String? status,
      String? conclusion,
      String? headBranch,
      String? headSha,
      String? path,
      @jsonParam GithubUserModel? actor,
      @jsonParam GithubUserModel? triggeringActor,
      @refParam GithubRepositoryModelRef? repository,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? jobsUrl,
      ModelUri? logsUrl,
      ModelUri? artifactsUrl,
      ModelUri? cancelUrl,
      ModelUri? rerunUrl,
      ModelUri? workflowUrl,
      ModelUri? checkSuiteUrl,
      ModelUri? previousAttemptUrl,
      ModelTimestamp? runStartedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  $GithubUserModelCopyWith<$Res>? get actor;
  $GithubUserModelCopyWith<$Res>? get triggeringActor;
}

/// @nodoc
class _$GithubActionsModelCopyWithImpl<$Res>
    implements $GithubActionsModelCopyWith<$Res> {
  _$GithubActionsModelCopyWithImpl(this._self, this._then);

  final GithubActionsModel _self;
  final $Res Function(GithubActionsModel) _then;

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? workflowId = freezed,
    Object? runNumber = freezed,
    Object? runAttempt = freezed,
    Object? name = freezed,
    Object? displayTitle = freezed,
    Object? event = freezed,
    Object? status = freezed,
    Object? conclusion = freezed,
    Object? headBranch = freezed,
    Object? headSha = freezed,
    Object? path = freezed,
    Object? actor = freezed,
    Object? triggeringActor = freezed,
    Object? repository = freezed,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? jobsUrl = freezed,
    Object? logsUrl = freezed,
    Object? artifactsUrl = freezed,
    Object? cancelUrl = freezed,
    Object? rerunUrl = freezed,
    Object? workflowUrl = freezed,
    Object? checkSuiteUrl = freezed,
    Object? previousAttemptUrl = freezed,
    Object? runStartedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      workflowId: freezed == workflowId
          ? _self.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as int?,
      runNumber: freezed == runNumber
          ? _self.runNumber
          : runNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      runAttempt: freezed == runAttempt
          ? _self.runAttempt
          : runAttempt // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      displayTitle: freezed == displayTitle
          ? _self.displayTitle
          : displayTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      event: freezed == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      conclusion: freezed == conclusion
          ? _self.conclusion
          : conclusion // ignore: cast_nullable_to_non_nullable
              as String?,
      headBranch: freezed == headBranch
          ? _self.headBranch
          : headBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      headSha: freezed == headSha
          ? _self.headSha
          : headSha // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      actor: freezed == actor
          ? _self.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      triggeringActor: freezed == triggeringActor
          ? _self.triggeringActor
          : triggeringActor // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      repository: freezed == repository
          ? _self.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      jobsUrl: freezed == jobsUrl
          ? _self.jobsUrl
          : jobsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      logsUrl: freezed == logsUrl
          ? _self.logsUrl
          : logsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      artifactsUrl: freezed == artifactsUrl
          ? _self.artifactsUrl
          : artifactsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      cancelUrl: freezed == cancelUrl
          ? _self.cancelUrl
          : cancelUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      rerunUrl: freezed == rerunUrl
          ? _self.rerunUrl
          : rerunUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      workflowUrl: freezed == workflowUrl
          ? _self.workflowUrl
          : workflowUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      checkSuiteUrl: freezed == checkSuiteUrl
          ? _self.checkSuiteUrl
          : checkSuiteUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      previousAttemptUrl: freezed == previousAttemptUrl
          ? _self.previousAttemptUrl
          : previousAttemptUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      runStartedAt: freezed == runStartedAt
          ? _self.runStartedAt
          : runStartedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get actor {
    if (_self.actor == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.actor!, (value) {
      return _then(_self.copyWith(actor: value));
    });
  }

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get triggeringActor {
    if (_self.triggeringActor == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.triggeringActor!, (value) {
      return _then(_self.copyWith(triggeringActor: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GithubActionsModel].
extension GithubActionsModelPatterns on GithubActionsModel {
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
    TResult Function(_GithubActionsModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsModel() when $default != null:
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
    TResult Function(_GithubActionsModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsModel():
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
    TResult? Function(_GithubActionsModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsModel() when $default != null:
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
            int? workflowId,
            int? runNumber,
            int? runAttempt,
            String? name,
            String? displayTitle,
            String? event,
            String? status,
            String? conclusion,
            String? headBranch,
            String? headSha,
            String? path,
            @jsonParam GithubUserModel? actor,
            @jsonParam GithubUserModel? triggeringActor,
            @refParam GithubRepositoryModelRef? repository,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? jobsUrl,
            ModelUri? logsUrl,
            ModelUri? artifactsUrl,
            ModelUri? cancelUrl,
            ModelUri? rerunUrl,
            ModelUri? workflowUrl,
            ModelUri? checkSuiteUrl,
            ModelUri? previousAttemptUrl,
            ModelTimestamp? runStartedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsModel() when $default != null:
        return $default(
            _that.id,
            _that.workflowId,
            _that.runNumber,
            _that.runAttempt,
            _that.name,
            _that.displayTitle,
            _that.event,
            _that.status,
            _that.conclusion,
            _that.headBranch,
            _that.headSha,
            _that.path,
            _that.actor,
            _that.triggeringActor,
            _that.repository,
            _that.url,
            _that.htmlUrl,
            _that.jobsUrl,
            _that.logsUrl,
            _that.artifactsUrl,
            _that.cancelUrl,
            _that.rerunUrl,
            _that.workflowUrl,
            _that.checkSuiteUrl,
            _that.previousAttemptUrl,
            _that.runStartedAt,
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
            int? workflowId,
            int? runNumber,
            int? runAttempt,
            String? name,
            String? displayTitle,
            String? event,
            String? status,
            String? conclusion,
            String? headBranch,
            String? headSha,
            String? path,
            @jsonParam GithubUserModel? actor,
            @jsonParam GithubUserModel? triggeringActor,
            @refParam GithubRepositoryModelRef? repository,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? jobsUrl,
            ModelUri? logsUrl,
            ModelUri? artifactsUrl,
            ModelUri? cancelUrl,
            ModelUri? rerunUrl,
            ModelUri? workflowUrl,
            ModelUri? checkSuiteUrl,
            ModelUri? previousAttemptUrl,
            ModelTimestamp? runStartedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsModel():
        return $default(
            _that.id,
            _that.workflowId,
            _that.runNumber,
            _that.runAttempt,
            _that.name,
            _that.displayTitle,
            _that.event,
            _that.status,
            _that.conclusion,
            _that.headBranch,
            _that.headSha,
            _that.path,
            _that.actor,
            _that.triggeringActor,
            _that.repository,
            _that.url,
            _that.htmlUrl,
            _that.jobsUrl,
            _that.logsUrl,
            _that.artifactsUrl,
            _that.cancelUrl,
            _that.rerunUrl,
            _that.workflowUrl,
            _that.checkSuiteUrl,
            _that.previousAttemptUrl,
            _that.runStartedAt,
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
            int? workflowId,
            int? runNumber,
            int? runAttempt,
            String? name,
            String? displayTitle,
            String? event,
            String? status,
            String? conclusion,
            String? headBranch,
            String? headSha,
            String? path,
            @jsonParam GithubUserModel? actor,
            @jsonParam GithubUserModel? triggeringActor,
            @refParam GithubRepositoryModelRef? repository,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? jobsUrl,
            ModelUri? logsUrl,
            ModelUri? artifactsUrl,
            ModelUri? cancelUrl,
            ModelUri? rerunUrl,
            ModelUri? workflowUrl,
            ModelUri? checkSuiteUrl,
            ModelUri? previousAttemptUrl,
            ModelTimestamp? runStartedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsModel() when $default != null:
        return $default(
            _that.id,
            _that.workflowId,
            _that.runNumber,
            _that.runAttempt,
            _that.name,
            _that.displayTitle,
            _that.event,
            _that.status,
            _that.conclusion,
            _that.headBranch,
            _that.headSha,
            _that.path,
            _that.actor,
            _that.triggeringActor,
            _that.repository,
            _that.url,
            _that.htmlUrl,
            _that.jobsUrl,
            _that.logsUrl,
            _that.artifactsUrl,
            _that.cancelUrl,
            _that.rerunUrl,
            _that.workflowUrl,
            _that.checkSuiteUrl,
            _that.previousAttemptUrl,
            _that.runStartedAt,
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
class _GithubActionsModel extends GithubActionsModel {
  const _GithubActionsModel(
      {this.id,
      this.workflowId,
      this.runNumber,
      this.runAttempt,
      this.name,
      this.displayTitle,
      this.event,
      this.status,
      this.conclusion,
      this.headBranch,
      this.headSha,
      this.path,
      @jsonParam this.actor,
      @jsonParam this.triggeringActor,
      @refParam this.repository,
      this.url,
      this.htmlUrl,
      this.jobsUrl,
      this.logsUrl,
      this.artifactsUrl,
      this.cancelUrl,
      this.rerunUrl,
      this.workflowUrl,
      this.checkSuiteUrl,
      this.previousAttemptUrl,
      this.runStartedAt,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now(),
      this.fromServer = false})
      : super._();
  factory _GithubActionsModel.fromJson(Map<String, dynamic> json) =>
      _$GithubActionsModelFromJson(json);

  @override
  final int? id;
  @override
  final int? workflowId;
  @override
  final int? runNumber;
  @override
  final int? runAttempt;
  @override
  final String? name;
  @override
  final String? displayTitle;
  @override
  final String? event;
  @override
  final String? status;
  @override
  final String? conclusion;
  @override
  final String? headBranch;
  @override
  final String? headSha;
  @override
  final String? path;
  @override
  @jsonParam
  final GithubUserModel? actor;
  @override
  @jsonParam
  final GithubUserModel? triggeringActor;
  @override
  @refParam
  final GithubRepositoryModelRef? repository;
  @override
  final ModelUri? url;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? jobsUrl;
  @override
  final ModelUri? logsUrl;
  @override
  final ModelUri? artifactsUrl;
  @override
  final ModelUri? cancelUrl;
  @override
  final ModelUri? rerunUrl;
  @override
  final ModelUri? workflowUrl;
  @override
  final ModelUri? checkSuiteUrl;
  @override
  final ModelUri? previousAttemptUrl;
  @override
  final ModelTimestamp? runStartedAt;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubActionsModelCopyWith<_GithubActionsModel> get copyWith =>
      __$GithubActionsModelCopyWithImpl<_GithubActionsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubActionsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubActionsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.runNumber, runNumber) ||
                other.runNumber == runNumber) &&
            (identical(other.runAttempt, runAttempt) ||
                other.runAttempt == runAttempt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.conclusion, conclusion) ||
                other.conclusion == conclusion) &&
            (identical(other.headBranch, headBranch) ||
                other.headBranch == headBranch) &&
            (identical(other.headSha, headSha) || other.headSha == headSha) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.actor, actor) || other.actor == actor) &&
            (identical(other.triggeringActor, triggeringActor) ||
                other.triggeringActor == triggeringActor) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.jobsUrl, jobsUrl) || other.jobsUrl == jobsUrl) &&
            (identical(other.logsUrl, logsUrl) || other.logsUrl == logsUrl) &&
            (identical(other.artifactsUrl, artifactsUrl) ||
                other.artifactsUrl == artifactsUrl) &&
            (identical(other.cancelUrl, cancelUrl) ||
                other.cancelUrl == cancelUrl) &&
            (identical(other.rerunUrl, rerunUrl) ||
                other.rerunUrl == rerunUrl) &&
            (identical(other.workflowUrl, workflowUrl) ||
                other.workflowUrl == workflowUrl) &&
            (identical(other.checkSuiteUrl, checkSuiteUrl) ||
                other.checkSuiteUrl == checkSuiteUrl) &&
            (identical(other.previousAttemptUrl, previousAttemptUrl) ||
                other.previousAttemptUrl == previousAttemptUrl) &&
            (identical(other.runStartedAt, runStartedAt) ||
                other.runStartedAt == runStartedAt) &&
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
        workflowId,
        runNumber,
        runAttempt,
        name,
        displayTitle,
        event,
        status,
        conclusion,
        headBranch,
        headSha,
        path,
        actor,
        triggeringActor,
        repository,
        url,
        htmlUrl,
        jobsUrl,
        logsUrl,
        artifactsUrl,
        cancelUrl,
        rerunUrl,
        workflowUrl,
        checkSuiteUrl,
        previousAttemptUrl,
        runStartedAt,
        createdAt,
        updatedAt,
        fromServer
      ]);

  @override
  String toString() {
    return 'GithubActionsModel(id: $id, workflowId: $workflowId, runNumber: $runNumber, runAttempt: $runAttempt, name: $name, displayTitle: $displayTitle, event: $event, status: $status, conclusion: $conclusion, headBranch: $headBranch, headSha: $headSha, path: $path, actor: $actor, triggeringActor: $triggeringActor, repository: $repository, url: $url, htmlUrl: $htmlUrl, jobsUrl: $jobsUrl, logsUrl: $logsUrl, artifactsUrl: $artifactsUrl, cancelUrl: $cancelUrl, rerunUrl: $rerunUrl, workflowUrl: $workflowUrl, checkSuiteUrl: $checkSuiteUrl, previousAttemptUrl: $previousAttemptUrl, runStartedAt: $runStartedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubActionsModelCopyWith<$Res>
    implements $GithubActionsModelCopyWith<$Res> {
  factory _$GithubActionsModelCopyWith(
          _GithubActionsModel value, $Res Function(_GithubActionsModel) _then) =
      __$GithubActionsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      int? workflowId,
      int? runNumber,
      int? runAttempt,
      String? name,
      String? displayTitle,
      String? event,
      String? status,
      String? conclusion,
      String? headBranch,
      String? headSha,
      String? path,
      @jsonParam GithubUserModel? actor,
      @jsonParam GithubUserModel? triggeringActor,
      @refParam GithubRepositoryModelRef? repository,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? jobsUrl,
      ModelUri? logsUrl,
      ModelUri? artifactsUrl,
      ModelUri? cancelUrl,
      ModelUri? rerunUrl,
      ModelUri? workflowUrl,
      ModelUri? checkSuiteUrl,
      ModelUri? previousAttemptUrl,
      ModelTimestamp? runStartedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});

  @override
  $GithubUserModelCopyWith<$Res>? get actor;
  @override
  $GithubUserModelCopyWith<$Res>? get triggeringActor;
}

/// @nodoc
class __$GithubActionsModelCopyWithImpl<$Res>
    implements _$GithubActionsModelCopyWith<$Res> {
  __$GithubActionsModelCopyWithImpl(this._self, this._then);

  final _GithubActionsModel _self;
  final $Res Function(_GithubActionsModel) _then;

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? workflowId = freezed,
    Object? runNumber = freezed,
    Object? runAttempt = freezed,
    Object? name = freezed,
    Object? displayTitle = freezed,
    Object? event = freezed,
    Object? status = freezed,
    Object? conclusion = freezed,
    Object? headBranch = freezed,
    Object? headSha = freezed,
    Object? path = freezed,
    Object? actor = freezed,
    Object? triggeringActor = freezed,
    Object? repository = freezed,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? jobsUrl = freezed,
    Object? logsUrl = freezed,
    Object? artifactsUrl = freezed,
    Object? cancelUrl = freezed,
    Object? rerunUrl = freezed,
    Object? workflowUrl = freezed,
    Object? checkSuiteUrl = freezed,
    Object? previousAttemptUrl = freezed,
    Object? runStartedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubActionsModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      workflowId: freezed == workflowId
          ? _self.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as int?,
      runNumber: freezed == runNumber
          ? _self.runNumber
          : runNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      runAttempt: freezed == runAttempt
          ? _self.runAttempt
          : runAttempt // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      displayTitle: freezed == displayTitle
          ? _self.displayTitle
          : displayTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      event: freezed == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      conclusion: freezed == conclusion
          ? _self.conclusion
          : conclusion // ignore: cast_nullable_to_non_nullable
              as String?,
      headBranch: freezed == headBranch
          ? _self.headBranch
          : headBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      headSha: freezed == headSha
          ? _self.headSha
          : headSha // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      actor: freezed == actor
          ? _self.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      triggeringActor: freezed == triggeringActor
          ? _self.triggeringActor
          : triggeringActor // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      repository: freezed == repository
          ? _self.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as GithubRepositoryModelRef?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      jobsUrl: freezed == jobsUrl
          ? _self.jobsUrl
          : jobsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      logsUrl: freezed == logsUrl
          ? _self.logsUrl
          : logsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      artifactsUrl: freezed == artifactsUrl
          ? _self.artifactsUrl
          : artifactsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      cancelUrl: freezed == cancelUrl
          ? _self.cancelUrl
          : cancelUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      rerunUrl: freezed == rerunUrl
          ? _self.rerunUrl
          : rerunUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      workflowUrl: freezed == workflowUrl
          ? _self.workflowUrl
          : workflowUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      checkSuiteUrl: freezed == checkSuiteUrl
          ? _self.checkSuiteUrl
          : checkSuiteUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      previousAttemptUrl: freezed == previousAttemptUrl
          ? _self.previousAttemptUrl
          : previousAttemptUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      runStartedAt: freezed == runStartedAt
          ? _self.runStartedAt
          : runStartedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get actor {
    if (_self.actor == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.actor!, (value) {
      return _then(_self.copyWith(actor: value));
    });
  }

  /// Create a copy of GithubActionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get triggeringActor {
    if (_self.triggeringActor == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.triggeringActor!, (value) {
      return _then(_self.copyWith(triggeringActor: value));
    });
  }
}

// dart format on
