// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_actions_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubActionsLogModel {
  int? get runId;
  int? get jobId;
  int? get chunk;
  String? get name;
  ModelUri? get downloadUrl;
  String get text;
  ModelTimestamp? get createdAt;
  bool get fromServer;

  /// Create a copy of GithubActionsLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubActionsLogModelCopyWith<GithubActionsLogModel> get copyWith =>
      _$GithubActionsLogModelCopyWithImpl<GithubActionsLogModel>(
          this as GithubActionsLogModel, _$identity);

  /// Serializes this GithubActionsLogModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubActionsLogModel &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.chunk, chunk) || other.chunk == chunk) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, runId, jobId, chunk, name,
      downloadUrl, text, createdAt, fromServer);

  @override
  String toString() {
    return 'GithubActionsLogModel(runId: $runId, jobId: $jobId, chunk: $chunk, name: $name, downloadUrl: $downloadUrl, text: $text, createdAt: $createdAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubActionsLogModelCopyWith<$Res> {
  factory $GithubActionsLogModelCopyWith(GithubActionsLogModel value,
          $Res Function(GithubActionsLogModel) _then) =
      _$GithubActionsLogModelCopyWithImpl;
  @useResult
  $Res call(
      {int? runId,
      int? jobId,
      int? chunk,
      String? name,
      ModelUri? downloadUrl,
      String text,
      ModelTimestamp? createdAt,
      bool fromServer});
}

/// @nodoc
class _$GithubActionsLogModelCopyWithImpl<$Res>
    implements $GithubActionsLogModelCopyWith<$Res> {
  _$GithubActionsLogModelCopyWithImpl(this._self, this._then);

  final GithubActionsLogModel _self;
  final $Res Function(GithubActionsLogModel) _then;

  /// Create a copy of GithubActionsLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? runId = freezed,
    Object? jobId = freezed,
    Object? chunk = freezed,
    Object? name = freezed,
    Object? downloadUrl = freezed,
    Object? text = null,
    Object? createdAt = freezed,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as int?,
      jobId: freezed == jobId
          ? _self.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as int?,
      chunk: freezed == chunk
          ? _self.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadUrl: freezed == downloadUrl
          ? _self.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubActionsLogModel].
extension GithubActionsLogModelPatterns on GithubActionsLogModel {
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
    TResult Function(_GithubActionsLogModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsLogModel() when $default != null:
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
    TResult Function(_GithubActionsLogModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsLogModel():
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
    TResult? Function(_GithubActionsLogModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsLogModel() when $default != null:
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
            int? runId,
            int? jobId,
            int? chunk,
            String? name,
            ModelUri? downloadUrl,
            String text,
            ModelTimestamp? createdAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubActionsLogModel() when $default != null:
        return $default(_that.runId, _that.jobId, _that.chunk, _that.name,
            _that.downloadUrl, _that.text, _that.createdAt, _that.fromServer);
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
            int? runId,
            int? jobId,
            int? chunk,
            String? name,
            ModelUri? downloadUrl,
            String text,
            ModelTimestamp? createdAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsLogModel():
        return $default(_that.runId, _that.jobId, _that.chunk, _that.name,
            _that.downloadUrl, _that.text, _that.createdAt, _that.fromServer);
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
            int? runId,
            int? jobId,
            int? chunk,
            String? name,
            ModelUri? downloadUrl,
            String text,
            ModelTimestamp? createdAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubActionsLogModel() when $default != null:
        return $default(_that.runId, _that.jobId, _that.chunk, _that.name,
            _that.downloadUrl, _that.text, _that.createdAt, _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GithubActionsLogModel extends GithubActionsLogModel {
  const _GithubActionsLogModel(
      {this.runId,
      this.jobId,
      this.chunk,
      this.name,
      this.downloadUrl,
      this.text = "",
      this.createdAt,
      this.fromServer = false})
      : super._();
  factory _GithubActionsLogModel.fromJson(Map<String, dynamic> json) =>
      _$GithubActionsLogModelFromJson(json);

  @override
  final int? runId;
  @override
  final int? jobId;
  @override
  final int? chunk;
  @override
  final String? name;
  @override
  final ModelUri? downloadUrl;
  @override
  @JsonKey()
  final String text;
  @override
  final ModelTimestamp? createdAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubActionsLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubActionsLogModelCopyWith<_GithubActionsLogModel> get copyWith =>
      __$GithubActionsLogModelCopyWithImpl<_GithubActionsLogModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubActionsLogModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubActionsLogModel &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.chunk, chunk) || other.chunk == chunk) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, runId, jobId, chunk, name,
      downloadUrl, text, createdAt, fromServer);

  @override
  String toString() {
    return 'GithubActionsLogModel(runId: $runId, jobId: $jobId, chunk: $chunk, name: $name, downloadUrl: $downloadUrl, text: $text, createdAt: $createdAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubActionsLogModelCopyWith<$Res>
    implements $GithubActionsLogModelCopyWith<$Res> {
  factory _$GithubActionsLogModelCopyWith(_GithubActionsLogModel value,
          $Res Function(_GithubActionsLogModel) _then) =
      __$GithubActionsLogModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? runId,
      int? jobId,
      int? chunk,
      String? name,
      ModelUri? downloadUrl,
      String text,
      ModelTimestamp? createdAt,
      bool fromServer});
}

/// @nodoc
class __$GithubActionsLogModelCopyWithImpl<$Res>
    implements _$GithubActionsLogModelCopyWith<$Res> {
  __$GithubActionsLogModelCopyWithImpl(this._self, this._then);

  final _GithubActionsLogModel _self;
  final $Res Function(_GithubActionsLogModel) _then;

  /// Create a copy of GithubActionsLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? runId = freezed,
    Object? jobId = freezed,
    Object? chunk = freezed,
    Object? name = freezed,
    Object? downloadUrl = freezed,
    Object? text = null,
    Object? createdAt = freezed,
    Object? fromServer = null,
  }) {
    return _then(_GithubActionsLogModel(
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as int?,
      jobId: freezed == jobId
          ? _self.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as int?,
      chunk: freezed == chunk
          ? _self.chunk
          : chunk // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadUrl: freezed == downloadUrl
          ? _self.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
