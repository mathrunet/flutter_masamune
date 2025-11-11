// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_actions_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubActionsJobModel {
  int? get id;
  int? get runId;
  int? get runAttempt;
  String? get name;
  String? get runnerName;
  int? get runnerId;
  int? get runnerGroupId;
  String? get status;
  String? get conclusion;
  List<String> get labels;
  @jsonParam
  GithubUserModel? get runner;
  @jsonParam
  List<GithubActionsStepValue> get steps;
  ModelUri? get url;
  ModelUri? get htmlUrl;
  ModelUri? get logsUrl;
  ModelTimestamp? get startedAt;
  ModelTimestamp? get completedAt;
  bool get fromServer;

  /// Create a copy of GithubActionsJobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubActionsJobModelCopyWith<GithubActionsJobModel> get copyWith =>
      _$GithubActionsJobModelCopyWithImpl<GithubActionsJobModel>(
          this as GithubActionsJobModel, _$identity);

  /// Serializes this GithubActionsJobModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubActionsJobModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.runAttempt, runAttempt) ||
                other.runAttempt == runAttempt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.runnerName, runnerName) ||
                other.runnerName == runnerName) &&
            (identical(other.runnerId, runnerId) ||
                other.runnerId == runnerId) &&
            (identical(other.runnerGroupId, runnerGroupId) ||
                other.runnerGroupId == runnerGroupId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.conclusion, conclusion) ||
                other.conclusion == conclusion) &&
            const DeepCollectionEquality().equals(other.labels, labels) &&
            (identical(other.runner, runner) || other.runner == runner) &&
            const DeepCollectionEquality().equals(other.steps, steps) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.logsUrl, logsUrl) || other.logsUrl == logsUrl) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      runId,
      runAttempt,
      name,
      runnerName,
      runnerId,
      runnerGroupId,
      status,
      conclusion,
      const DeepCollectionEquality().hash(labels),
      runner,
      const DeepCollectionEquality().hash(steps),
      url,
      htmlUrl,
      logsUrl,
      startedAt,
      completedAt,
      fromServer);

  @override
  String toString() {
    return 'GithubActionsJobModel(id: $id, runId: $runId, runAttempt: $runAttempt, name: $name, runnerName: $runnerName, runnerId: $runnerId, runnerGroupId: $runnerGroupId, status: $status, conclusion: $conclusion, labels: $labels, runner: $runner, steps: $steps, url: $url, htmlUrl: $htmlUrl, logsUrl: $logsUrl, startedAt: $startedAt, completedAt: $completedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubActionsJobModelCopyWith<$Res> {
  factory $GithubActionsJobModelCopyWith(GithubActionsJobModel value,
          $Res Function(GithubActionsJobModel) _then) =
      _$GithubActionsJobModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      int? runId,
      int? runAttempt,
      String? name,
      String? runnerName,
      int? runnerId,
      int? runnerGroupId,
      String? status,
      String? conclusion,
      List<String> labels,
      @jsonParam GithubUserModel? runner,
      @jsonParam List<GithubActionsStepValue> steps,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? logsUrl,
      ModelTimestamp? startedAt,
      ModelTimestamp? completedAt,
      bool fromServer});

  $GithubUserModelCopyWith<$Res>? get runner;
}

/// @nodoc
class _$GithubActionsJobModelCopyWithImpl<$Res>
    implements $GithubActionsJobModelCopyWith<$Res> {
  _$GithubActionsJobModelCopyWithImpl(this._self, this._then);

  final GithubActionsJobModel _self;
  final $Res Function(GithubActionsJobModel) _then;

  /// Create a copy of GithubActionsJobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? runId = freezed,
    Object? runAttempt = freezed,
    Object? name = freezed,
    Object? runnerName = freezed,
    Object? runnerId = freezed,
    Object? runnerGroupId = freezed,
    Object? status = freezed,
    Object? conclusion = freezed,
    Object? labels = null,
    Object? runner = freezed,
    Object? steps = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? logsUrl = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as int?,
      runAttempt: freezed == runAttempt
          ? _self.runAttempt
          : runAttempt // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      runnerName: freezed == runnerName
          ? _self.runnerName
          : runnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      runnerId: freezed == runnerId
          ? _self.runnerId
          : runnerId // ignore: cast_nullable_to_non_nullable
              as int?,
      runnerGroupId: freezed == runnerGroupId
          ? _self.runnerGroupId
          : runnerGroupId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      conclusion: freezed == conclusion
          ? _self.conclusion
          : conclusion // ignore: cast_nullable_to_non_nullable
              as String?,
      labels: null == labels
          ? _self.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      runner: freezed == runner
          ? _self.runner
          : runner // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<GithubActionsStepValue>,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      logsUrl: freezed == logsUrl
          ? _self.logsUrl
          : logsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubActionsJobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get runner {
    if (_self.runner == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.runner!, (value) {
      return _then(_self.copyWith(runner: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GithubActionsJobModel].
extension GithubActionsJobModelPatterns on GithubActionsJobModel {
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
    TResult Function(_GithubActionsJobModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsJobModel() when $default != null:
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
    TResult Function(_GithubActionsJobModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsJobModel():
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
    TResult? Function(_GithubActionsJobModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsJobModel() when $default != null:
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
            int? runId,
            int? runAttempt,
            String? name,
            String? runnerName,
            int? runnerId,
            int? runnerGroupId,
            String? status,
            String? conclusion,
            List<String> labels,
            @jsonParam GithubUserModel? runner,
            @jsonParam List<GithubActionsStepValue> steps,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? logsUrl,
            ModelTimestamp? startedAt,
            ModelTimestamp? completedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsJobModel() when $default != null:
        return $default(
            _that.id,
            _that.runId,
            _that.runAttempt,
            _that.name,
            _that.runnerName,
            _that.runnerId,
            _that.runnerGroupId,
            _that.status,
            _that.conclusion,
            _that.labels,
            _that.runner,
            _that.steps,
            _that.url,
            _that.htmlUrl,
            _that.logsUrl,
            _that.startedAt,
            _that.completedAt,
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
            int? runId,
            int? runAttempt,
            String? name,
            String? runnerName,
            int? runnerId,
            int? runnerGroupId,
            String? status,
            String? conclusion,
            List<String> labels,
            @jsonParam GithubUserModel? runner,
            @jsonParam List<GithubActionsStepValue> steps,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? logsUrl,
            ModelTimestamp? startedAt,
            ModelTimestamp? completedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsJobModel():
        return $default(
            _that.id,
            _that.runId,
            _that.runAttempt,
            _that.name,
            _that.runnerName,
            _that.runnerId,
            _that.runnerGroupId,
            _that.status,
            _that.conclusion,
            _that.labels,
            _that.runner,
            _that.steps,
            _that.url,
            _that.htmlUrl,
            _that.logsUrl,
            _that.startedAt,
            _that.completedAt,
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
            int? runId,
            int? runAttempt,
            String? name,
            String? runnerName,
            int? runnerId,
            int? runnerGroupId,
            String? status,
            String? conclusion,
            List<String> labels,
            @jsonParam GithubUserModel? runner,
            @jsonParam List<GithubActionsStepValue> steps,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? logsUrl,
            ModelTimestamp? startedAt,
            ModelTimestamp? completedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsJobModel() when $default != null:
        return $default(
            _that.id,
            _that.runId,
            _that.runAttempt,
            _that.name,
            _that.runnerName,
            _that.runnerId,
            _that.runnerGroupId,
            _that.status,
            _that.conclusion,
            _that.labels,
            _that.runner,
            _that.steps,
            _that.url,
            _that.htmlUrl,
            _that.logsUrl,
            _that.startedAt,
            _that.completedAt,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GithubActionsJobModel extends GithubActionsJobModel {
  const _GithubActionsJobModel(
      {this.id,
      this.runId,
      this.runAttempt,
      this.name,
      this.runnerName,
      this.runnerId,
      this.runnerGroupId,
      this.status,
      this.conclusion,
      final List<String> labels = const <String>[],
      @jsonParam this.runner,
      @jsonParam final List<GithubActionsStepValue> steps =
          const <GithubActionsStepValue>[],
      this.url,
      this.htmlUrl,
      this.logsUrl,
      this.startedAt,
      this.completedAt,
      this.fromServer = false})
      : _labels = labels,
        _steps = steps,
        super._();
  factory _GithubActionsJobModel.fromJson(Map<String, dynamic> json) =>
      _$GithubActionsJobModelFromJson(json);

  @override
  final int? id;
  @override
  final int? runId;
  @override
  final int? runAttempt;
  @override
  final String? name;
  @override
  final String? runnerName;
  @override
  final int? runnerId;
  @override
  final int? runnerGroupId;
  @override
  final String? status;
  @override
  final String? conclusion;
  final List<String> _labels;
  @override
  @JsonKey()
  List<String> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  @override
  @jsonParam
  final GithubUserModel? runner;
  final List<GithubActionsStepValue> _steps;
  @override
  @JsonKey()
  @jsonParam
  List<GithubActionsStepValue> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final ModelUri? url;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? logsUrl;
  @override
  final ModelTimestamp? startedAt;
  @override
  final ModelTimestamp? completedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubActionsJobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubActionsJobModelCopyWith<_GithubActionsJobModel> get copyWith =>
      __$GithubActionsJobModelCopyWithImpl<_GithubActionsJobModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubActionsJobModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubActionsJobModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.runAttempt, runAttempt) ||
                other.runAttempt == runAttempt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.runnerName, runnerName) ||
                other.runnerName == runnerName) &&
            (identical(other.runnerId, runnerId) ||
                other.runnerId == runnerId) &&
            (identical(other.runnerGroupId, runnerGroupId) ||
                other.runnerGroupId == runnerGroupId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.conclusion, conclusion) ||
                other.conclusion == conclusion) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.runner, runner) || other.runner == runner) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.logsUrl, logsUrl) || other.logsUrl == logsUrl) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      runId,
      runAttempt,
      name,
      runnerName,
      runnerId,
      runnerGroupId,
      status,
      conclusion,
      const DeepCollectionEquality().hash(_labels),
      runner,
      const DeepCollectionEquality().hash(_steps),
      url,
      htmlUrl,
      logsUrl,
      startedAt,
      completedAt,
      fromServer);

  @override
  String toString() {
    return 'GithubActionsJobModel(id: $id, runId: $runId, runAttempt: $runAttempt, name: $name, runnerName: $runnerName, runnerId: $runnerId, runnerGroupId: $runnerGroupId, status: $status, conclusion: $conclusion, labels: $labels, runner: $runner, steps: $steps, url: $url, htmlUrl: $htmlUrl, logsUrl: $logsUrl, startedAt: $startedAt, completedAt: $completedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubActionsJobModelCopyWith<$Res>
    implements $GithubActionsJobModelCopyWith<$Res> {
  factory _$GithubActionsJobModelCopyWith(_GithubActionsJobModel value,
          $Res Function(_GithubActionsJobModel) _then) =
      __$GithubActionsJobModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      int? runId,
      int? runAttempt,
      String? name,
      String? runnerName,
      int? runnerId,
      int? runnerGroupId,
      String? status,
      String? conclusion,
      List<String> labels,
      @jsonParam GithubUserModel? runner,
      @jsonParam List<GithubActionsStepValue> steps,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? logsUrl,
      ModelTimestamp? startedAt,
      ModelTimestamp? completedAt,
      bool fromServer});

  @override
  $GithubUserModelCopyWith<$Res>? get runner;
}

/// @nodoc
class __$GithubActionsJobModelCopyWithImpl<$Res>
    implements _$GithubActionsJobModelCopyWith<$Res> {
  __$GithubActionsJobModelCopyWithImpl(this._self, this._then);

  final _GithubActionsJobModel _self;
  final $Res Function(_GithubActionsJobModel) _then;

  /// Create a copy of GithubActionsJobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? runId = freezed,
    Object? runAttempt = freezed,
    Object? name = freezed,
    Object? runnerName = freezed,
    Object? runnerId = freezed,
    Object? runnerGroupId = freezed,
    Object? status = freezed,
    Object? conclusion = freezed,
    Object? labels = null,
    Object? runner = freezed,
    Object? steps = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? logsUrl = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? fromServer = null,
  }) {
    return _then(_GithubActionsJobModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as int?,
      runAttempt: freezed == runAttempt
          ? _self.runAttempt
          : runAttempt // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      runnerName: freezed == runnerName
          ? _self.runnerName
          : runnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      runnerId: freezed == runnerId
          ? _self.runnerId
          : runnerId // ignore: cast_nullable_to_non_nullable
              as int?,
      runnerGroupId: freezed == runnerGroupId
          ? _self.runnerGroupId
          : runnerGroupId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      conclusion: freezed == conclusion
          ? _self.conclusion
          : conclusion // ignore: cast_nullable_to_non_nullable
              as String?,
      labels: null == labels
          ? _self._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      runner: freezed == runner
          ? _self.runner
          : runner // ignore: cast_nullable_to_non_nullable
              as GithubUserModel?,
      steps: null == steps
          ? _self._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<GithubActionsStepValue>,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      logsUrl: freezed == logsUrl
          ? _self.logsUrl
          : logsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GithubActionsJobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GithubUserModelCopyWith<$Res>? get runner {
    if (_self.runner == null) {
      return null;
    }

    return $GithubUserModelCopyWith<$Res>(_self.runner!, (value) {
      return _then(_self.copyWith(runner: value));
    });
  }
}

/// @nodoc
mixin _$GithubActionsStepValue {
  int? get number;
  String? get name;
  String? get status;
  String? get conclusion;
  ModelTimestamp? get startedAt;
  ModelTimestamp? get completedAt;

  /// Create a copy of GithubActionsStepValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubActionsStepValueCopyWith<GithubActionsStepValue> get copyWith =>
      _$GithubActionsStepValueCopyWithImpl<GithubActionsStepValue>(
          this as GithubActionsStepValue, _$identity);

  /// Serializes this GithubActionsStepValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubActionsStepValue &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.conclusion, conclusion) ||
                other.conclusion == conclusion) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, name, status, conclusion, startedAt, completedAt);

  @override
  String toString() {
    return 'GithubActionsStepValue(number: $number, name: $name, status: $status, conclusion: $conclusion, startedAt: $startedAt, completedAt: $completedAt)';
  }
}

/// @nodoc
abstract mixin class $GithubActionsStepValueCopyWith<$Res> {
  factory $GithubActionsStepValueCopyWith(GithubActionsStepValue value,
          $Res Function(GithubActionsStepValue) _then) =
      _$GithubActionsStepValueCopyWithImpl;
  @useResult
  $Res call(
      {int? number,
      String? name,
      String? status,
      String? conclusion,
      ModelTimestamp? startedAt,
      ModelTimestamp? completedAt});
}

/// @nodoc
class _$GithubActionsStepValueCopyWithImpl<$Res>
    implements $GithubActionsStepValueCopyWith<$Res> {
  _$GithubActionsStepValueCopyWithImpl(this._self, this._then);

  final GithubActionsStepValue _self;
  final $Res Function(GithubActionsStepValue) _then;

  /// Create a copy of GithubActionsStepValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? name = freezed,
    Object? status = freezed,
    Object? conclusion = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_self.copyWith(
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      conclusion: freezed == conclusion
          ? _self.conclusion
          : conclusion // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubActionsStepValue].
extension GithubActionsStepValuePatterns on GithubActionsStepValue {
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
    TResult Function(_GithubActionsStepValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsStepValue() when $default != null:
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
    TResult Function(_GithubActionsStepValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsStepValue():
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
    TResult? Function(_GithubActionsStepValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsStepValue() when $default != null:
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
            int? number,
            String? name,
            String? status,
            String? conclusion,
            ModelTimestamp? startedAt,
            ModelTimestamp? completedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsStepValue() when $default != null:
        return $default(_that.number, _that.name, _that.status,
            _that.conclusion, _that.startedAt, _that.completedAt);
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
            int? number,
            String? name,
            String? status,
            String? conclusion,
            ModelTimestamp? startedAt,
            ModelTimestamp? completedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsStepValue():
        return $default(_that.number, _that.name, _that.status,
            _that.conclusion, _that.startedAt, _that.completedAt);
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
            int? number,
            String? name,
            String? status,
            String? conclusion,
            ModelTimestamp? startedAt,
            ModelTimestamp? completedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsStepValue() when $default != null:
        return $default(_that.number, _that.name, _that.status,
            _that.conclusion, _that.startedAt, _that.completedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubActionsStepValue extends GithubActionsStepValue {
  const _GithubActionsStepValue(
      {this.number,
      this.name,
      this.status,
      this.conclusion,
      this.startedAt,
      this.completedAt})
      : super._();
  factory _GithubActionsStepValue.fromJson(Map<String, dynamic> json) =>
      _$GithubActionsStepValueFromJson(json);

  @override
  final int? number;
  @override
  final String? name;
  @override
  final String? status;
  @override
  final String? conclusion;
  @override
  final ModelTimestamp? startedAt;
  @override
  final ModelTimestamp? completedAt;

  /// Create a copy of GithubActionsStepValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubActionsStepValueCopyWith<_GithubActionsStepValue> get copyWith =>
      __$GithubActionsStepValueCopyWithImpl<_GithubActionsStepValue>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubActionsStepValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubActionsStepValue &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.conclusion, conclusion) ||
                other.conclusion == conclusion) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, name, status, conclusion, startedAt, completedAt);

  @override
  String toString() {
    return 'GithubActionsStepValue(number: $number, name: $name, status: $status, conclusion: $conclusion, startedAt: $startedAt, completedAt: $completedAt)';
  }
}

/// @nodoc
abstract mixin class _$GithubActionsStepValueCopyWith<$Res>
    implements $GithubActionsStepValueCopyWith<$Res> {
  factory _$GithubActionsStepValueCopyWith(_GithubActionsStepValue value,
          $Res Function(_GithubActionsStepValue) _then) =
      __$GithubActionsStepValueCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? number,
      String? name,
      String? status,
      String? conclusion,
      ModelTimestamp? startedAt,
      ModelTimestamp? completedAt});
}

/// @nodoc
class __$GithubActionsStepValueCopyWithImpl<$Res>
    implements _$GithubActionsStepValueCopyWith<$Res> {
  __$GithubActionsStepValueCopyWithImpl(this._self, this._then);

  final _GithubActionsStepValue _self;
  final $Res Function(_GithubActionsStepValue) _then;

  /// Create a copy of GithubActionsStepValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? number = freezed,
    Object? name = freezed,
    Object? status = freezed,
    Object? conclusion = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_GithubActionsStepValue(
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      conclusion: freezed == conclusion
          ? _self.conclusion
          : conclusion // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
    ));
  }
}

// dart format on
