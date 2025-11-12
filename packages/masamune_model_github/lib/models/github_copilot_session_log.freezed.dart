// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_copilot_session_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubCopilotSessionLogModel {
  String get id;
  String get sessionId;
  String get message;
  Map<String, dynamic>? get metadata;
  String? get toolName;
  String? get toolResult;
  GithubCopilotSessionLogLevel get level;
  ModelTimestamp get timestamp;
  bool get fromServer;

  /// Create a copy of GithubCopilotSessionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubCopilotSessionLogModelCopyWith<GithubCopilotSessionLogModel>
      get copyWith => _$GithubCopilotSessionLogModelCopyWithImpl<
              GithubCopilotSessionLogModel>(
          this as GithubCopilotSessionLogModel, _$identity);

  /// Serializes this GithubCopilotSessionLogModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubCopilotSessionLogModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            (identical(other.toolResult, toolResult) ||
                other.toolResult == toolResult) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      message,
      const DeepCollectionEquality().hash(metadata),
      toolName,
      toolResult,
      level,
      timestamp,
      fromServer);

  @override
  String toString() {
    return 'GithubCopilotSessionLogModel(id: $id, sessionId: $sessionId, message: $message, metadata: $metadata, toolName: $toolName, toolResult: $toolResult, level: $level, timestamp: $timestamp, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubCopilotSessionLogModelCopyWith<$Res> {
  factory $GithubCopilotSessionLogModelCopyWith(
          GithubCopilotSessionLogModel value,
          $Res Function(GithubCopilotSessionLogModel) _then) =
      _$GithubCopilotSessionLogModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String message,
      Map<String, dynamic>? metadata,
      String? toolName,
      String? toolResult,
      GithubCopilotSessionLogLevel level,
      ModelTimestamp timestamp,
      bool fromServer});
}

/// @nodoc
class _$GithubCopilotSessionLogModelCopyWithImpl<$Res>
    implements $GithubCopilotSessionLogModelCopyWith<$Res> {
  _$GithubCopilotSessionLogModelCopyWithImpl(this._self, this._then);

  final GithubCopilotSessionLogModel _self;
  final $Res Function(GithubCopilotSessionLogModel) _then;

  /// Create a copy of GithubCopilotSessionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? message = null,
    Object? metadata = freezed,
    Object? toolName = freezed,
    Object? toolResult = freezed,
    Object? level = null,
    Object? timestamp = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      toolName: freezed == toolName
          ? _self.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String?,
      toolResult: freezed == toolResult
          ? _self.toolResult
          : toolResult // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as GithubCopilotSessionLogLevel,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubCopilotSessionLogModel].
extension GithubCopilotSessionLogModelPatterns on GithubCopilotSessionLogModel {
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
    TResult Function(_GithubCopilotSessionLogModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionLogModel() when $default != null:
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
    TResult Function(_GithubCopilotSessionLogModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionLogModel():
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
    TResult? Function(_GithubCopilotSessionLogModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionLogModel() when $default != null:
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
            String id,
            String sessionId,
            String message,
            Map<String, dynamic>? metadata,
            String? toolName,
            String? toolResult,
            GithubCopilotSessionLogLevel level,
            ModelTimestamp timestamp,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionLogModel() when $default != null:
        return $default(
            _that.id,
            _that.sessionId,
            _that.message,
            _that.metadata,
            _that.toolName,
            _that.toolResult,
            _that.level,
            _that.timestamp,
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
            String id,
            String sessionId,
            String message,
            Map<String, dynamic>? metadata,
            String? toolName,
            String? toolResult,
            GithubCopilotSessionLogLevel level,
            ModelTimestamp timestamp,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionLogModel():
        return $default(
            _that.id,
            _that.sessionId,
            _that.message,
            _that.metadata,
            _that.toolName,
            _that.toolResult,
            _that.level,
            _that.timestamp,
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
            String id,
            String sessionId,
            String message,
            Map<String, dynamic>? metadata,
            String? toolName,
            String? toolResult,
            GithubCopilotSessionLogLevel level,
            ModelTimestamp timestamp,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionLogModel() when $default != null:
        return $default(
            _that.id,
            _that.sessionId,
            _that.message,
            _that.metadata,
            _that.toolName,
            _that.toolResult,
            _that.level,
            _that.timestamp,
            _that.fromServer);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubCopilotSessionLogModel extends GithubCopilotSessionLogModel {
  const _GithubCopilotSessionLogModel(
      {required this.id,
      required this.sessionId,
      required this.message,
      final Map<String, dynamic>? metadata,
      this.toolName,
      this.toolResult,
      this.level = GithubCopilotSessionLogLevel.unknown,
      this.timestamp = const ModelTimestamp(),
      this.fromServer = false})
      : _metadata = metadata,
        super._();
  factory _GithubCopilotSessionLogModel.fromJson(Map<String, dynamic> json) =>
      _$GithubCopilotSessionLogModelFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String message;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? toolName;
  @override
  final String? toolResult;
  @override
  @JsonKey()
  final GithubCopilotSessionLogLevel level;
  @override
  @JsonKey()
  final ModelTimestamp timestamp;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubCopilotSessionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubCopilotSessionLogModelCopyWith<_GithubCopilotSessionLogModel>
      get copyWith => __$GithubCopilotSessionLogModelCopyWithImpl<
          _GithubCopilotSessionLogModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubCopilotSessionLogModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubCopilotSessionLogModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            (identical(other.toolResult, toolResult) ||
                other.toolResult == toolResult) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      message,
      const DeepCollectionEquality().hash(_metadata),
      toolName,
      toolResult,
      level,
      timestamp,
      fromServer);

  @override
  String toString() {
    return 'GithubCopilotSessionLogModel(id: $id, sessionId: $sessionId, message: $message, metadata: $metadata, toolName: $toolName, toolResult: $toolResult, level: $level, timestamp: $timestamp, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubCopilotSessionLogModelCopyWith<$Res>
    implements $GithubCopilotSessionLogModelCopyWith<$Res> {
  factory _$GithubCopilotSessionLogModelCopyWith(
          _GithubCopilotSessionLogModel value,
          $Res Function(_GithubCopilotSessionLogModel) _then) =
      __$GithubCopilotSessionLogModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String message,
      Map<String, dynamic>? metadata,
      String? toolName,
      String? toolResult,
      GithubCopilotSessionLogLevel level,
      ModelTimestamp timestamp,
      bool fromServer});
}

/// @nodoc
class __$GithubCopilotSessionLogModelCopyWithImpl<$Res>
    implements _$GithubCopilotSessionLogModelCopyWith<$Res> {
  __$GithubCopilotSessionLogModelCopyWithImpl(this._self, this._then);

  final _GithubCopilotSessionLogModel _self;
  final $Res Function(_GithubCopilotSessionLogModel) _then;

  /// Create a copy of GithubCopilotSessionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? message = null,
    Object? metadata = freezed,
    Object? toolName = freezed,
    Object? toolResult = freezed,
    Object? level = null,
    Object? timestamp = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubCopilotSessionLogModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      toolName: freezed == toolName
          ? _self.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String?,
      toolResult: freezed == toolResult
          ? _self.toolResult
          : toolResult // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as GithubCopilotSessionLogLevel,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      fromServer: null == fromServer
          ? _self.fromServer
          : fromServer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
