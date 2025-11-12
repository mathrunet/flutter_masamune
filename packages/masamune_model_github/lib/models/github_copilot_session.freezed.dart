// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_copilot_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubCopilotSessionModel {
  String get id;
  String get state;
  String? get name;
  String? get resourceType;
  String? get resourceId;
  String? get userId;
  String? get agentId;
  String? get errorMessage;
  String? get errorCode;
  int? get pullRequestNumber;
  String? get pullRequestUrl;
  String? get pullRequestId;
  String? get pullRequestBaseRef;
  ModelTimestamp? get completedAt;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;
  bool get fromServer;

  /// Create a copy of GithubCopilotSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubCopilotSessionModelCopyWith<GithubCopilotSessionModel> get copyWith =>
      _$GithubCopilotSessionModelCopyWithImpl<GithubCopilotSessionModel>(
          this as GithubCopilotSessionModel, _$identity);

  /// Serializes this GithubCopilotSessionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubCopilotSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.resourceId, resourceId) ||
                other.resourceId == resourceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.agentId, agentId) || other.agentId == agentId) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.pullRequestNumber, pullRequestNumber) ||
                other.pullRequestNumber == pullRequestNumber) &&
            (identical(other.pullRequestUrl, pullRequestUrl) ||
                other.pullRequestUrl == pullRequestUrl) &&
            (identical(other.pullRequestId, pullRequestId) ||
                other.pullRequestId == pullRequestId) &&
            (identical(other.pullRequestBaseRef, pullRequestBaseRef) ||
                other.pullRequestBaseRef == pullRequestBaseRef) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      state,
      name,
      resourceType,
      resourceId,
      userId,
      agentId,
      errorMessage,
      errorCode,
      pullRequestNumber,
      pullRequestUrl,
      pullRequestId,
      pullRequestBaseRef,
      completedAt,
      createdAt,
      updatedAt,
      fromServer);

  @override
  String toString() {
    return 'GithubCopilotSessionModel(id: $id, state: $state, name: $name, resourceType: $resourceType, resourceId: $resourceId, userId: $userId, agentId: $agentId, errorMessage: $errorMessage, errorCode: $errorCode, pullRequestNumber: $pullRequestNumber, pullRequestUrl: $pullRequestUrl, pullRequestId: $pullRequestId, pullRequestBaseRef: $pullRequestBaseRef, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class $GithubCopilotSessionModelCopyWith<$Res> {
  factory $GithubCopilotSessionModelCopyWith(GithubCopilotSessionModel value,
          $Res Function(GithubCopilotSessionModel) _then) =
      _$GithubCopilotSessionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String state,
      String? name,
      String? resourceType,
      String? resourceId,
      String? userId,
      String? agentId,
      String? errorMessage,
      String? errorCode,
      int? pullRequestNumber,
      String? pullRequestUrl,
      String? pullRequestId,
      String? pullRequestBaseRef,
      ModelTimestamp? completedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});
}

/// @nodoc
class _$GithubCopilotSessionModelCopyWithImpl<$Res>
    implements $GithubCopilotSessionModelCopyWith<$Res> {
  _$GithubCopilotSessionModelCopyWithImpl(this._self, this._then);

  final GithubCopilotSessionModel _self;
  final $Res Function(GithubCopilotSessionModel) _then;

  /// Create a copy of GithubCopilotSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? state = null,
    Object? name = freezed,
    Object? resourceType = freezed,
    Object? resourceId = freezed,
    Object? userId = freezed,
    Object? agentId = freezed,
    Object? errorMessage = freezed,
    Object? errorCode = freezed,
    Object? pullRequestNumber = freezed,
    Object? pullRequestUrl = freezed,
    Object? pullRequestId = freezed,
    Object? pullRequestBaseRef = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: freezed == resourceType
          ? _self.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceId: freezed == resourceId
          ? _self.resourceId
          : resourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      agentId: freezed == agentId
          ? _self.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      errorCode: freezed == errorCode
          ? _self.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      pullRequestNumber: freezed == pullRequestNumber
          ? _self.pullRequestNumber
          : pullRequestNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      pullRequestUrl: freezed == pullRequestUrl
          ? _self.pullRequestUrl
          : pullRequestUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pullRequestId: freezed == pullRequestId
          ? _self.pullRequestId
          : pullRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      pullRequestBaseRef: freezed == pullRequestBaseRef
          ? _self.pullRequestBaseRef
          : pullRequestBaseRef // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
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
}

/// Adds pattern-matching-related methods to [GithubCopilotSessionModel].
extension GithubCopilotSessionModelPatterns on GithubCopilotSessionModel {
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
    TResult Function(_GithubCopilotSessionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionModel() when $default != null:
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
    TResult Function(_GithubCopilotSessionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionModel():
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
    TResult? Function(_GithubCopilotSessionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionModel() when $default != null:
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
            String state,
            String? name,
            String? resourceType,
            String? resourceId,
            String? userId,
            String? agentId,
            String? errorMessage,
            String? errorCode,
            int? pullRequestNumber,
            String? pullRequestUrl,
            String? pullRequestId,
            String? pullRequestBaseRef,
            ModelTimestamp? completedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionModel() when $default != null:
        return $default(
            _that.id,
            _that.state,
            _that.name,
            _that.resourceType,
            _that.resourceId,
            _that.userId,
            _that.agentId,
            _that.errorMessage,
            _that.errorCode,
            _that.pullRequestNumber,
            _that.pullRequestUrl,
            _that.pullRequestId,
            _that.pullRequestBaseRef,
            _that.completedAt,
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
            String id,
            String state,
            String? name,
            String? resourceType,
            String? resourceId,
            String? userId,
            String? agentId,
            String? errorMessage,
            String? errorCode,
            int? pullRequestNumber,
            String? pullRequestUrl,
            String? pullRequestId,
            String? pullRequestBaseRef,
            ModelTimestamp? completedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionModel():
        return $default(
            _that.id,
            _that.state,
            _that.name,
            _that.resourceType,
            _that.resourceId,
            _that.userId,
            _that.agentId,
            _that.errorMessage,
            _that.errorCode,
            _that.pullRequestNumber,
            _that.pullRequestUrl,
            _that.pullRequestId,
            _that.pullRequestBaseRef,
            _that.completedAt,
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
            String id,
            String state,
            String? name,
            String? resourceType,
            String? resourceId,
            String? userId,
            String? agentId,
            String? errorMessage,
            String? errorCode,
            int? pullRequestNumber,
            String? pullRequestUrl,
            String? pullRequestId,
            String? pullRequestBaseRef,
            ModelTimestamp? completedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt,
            bool fromServer)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubCopilotSessionModel() when $default != null:
        return $default(
            _that.id,
            _that.state,
            _that.name,
            _that.resourceType,
            _that.resourceId,
            _that.userId,
            _that.agentId,
            _that.errorMessage,
            _that.errorCode,
            _that.pullRequestNumber,
            _that.pullRequestUrl,
            _that.pullRequestId,
            _that.pullRequestBaseRef,
            _that.completedAt,
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
class _GithubCopilotSessionModel extends GithubCopilotSessionModel {
  const _GithubCopilotSessionModel(
      {required this.id,
      required this.state,
      this.name,
      this.resourceType,
      this.resourceId,
      this.userId,
      this.agentId,
      this.errorMessage,
      this.errorCode,
      this.pullRequestNumber,
      this.pullRequestUrl,
      this.pullRequestId,
      this.pullRequestBaseRef,
      this.completedAt,
      this.createdAt = const ModelTimestamp(),
      this.updatedAt = const ModelTimestamp(),
      this.fromServer = false})
      : super._();
  factory _GithubCopilotSessionModel.fromJson(Map<String, dynamic> json) =>
      _$GithubCopilotSessionModelFromJson(json);

  @override
  final String id;
  @override
  final String state;
  @override
  final String? name;
  @override
  final String? resourceType;
  @override
  final String? resourceId;
  @override
  final String? userId;
  @override
  final String? agentId;
  @override
  final String? errorMessage;
  @override
  final String? errorCode;
  @override
  final int? pullRequestNumber;
  @override
  final String? pullRequestUrl;
  @override
  final String? pullRequestId;
  @override
  final String? pullRequestBaseRef;
  @override
  final ModelTimestamp? completedAt;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;
  @override
  @JsonKey()
  final bool fromServer;

  /// Create a copy of GithubCopilotSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubCopilotSessionModelCopyWith<_GithubCopilotSessionModel>
      get copyWith =>
          __$GithubCopilotSessionModelCopyWithImpl<_GithubCopilotSessionModel>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubCopilotSessionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubCopilotSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.resourceId, resourceId) ||
                other.resourceId == resourceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.agentId, agentId) || other.agentId == agentId) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.pullRequestNumber, pullRequestNumber) ||
                other.pullRequestNumber == pullRequestNumber) &&
            (identical(other.pullRequestUrl, pullRequestUrl) ||
                other.pullRequestUrl == pullRequestUrl) &&
            (identical(other.pullRequestId, pullRequestId) ||
                other.pullRequestId == pullRequestId) &&
            (identical(other.pullRequestBaseRef, pullRequestBaseRef) ||
                other.pullRequestBaseRef == pullRequestBaseRef) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fromServer, fromServer) ||
                other.fromServer == fromServer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      state,
      name,
      resourceType,
      resourceId,
      userId,
      agentId,
      errorMessage,
      errorCode,
      pullRequestNumber,
      pullRequestUrl,
      pullRequestId,
      pullRequestBaseRef,
      completedAt,
      createdAt,
      updatedAt,
      fromServer);

  @override
  String toString() {
    return 'GithubCopilotSessionModel(id: $id, state: $state, name: $name, resourceType: $resourceType, resourceId: $resourceId, userId: $userId, agentId: $agentId, errorMessage: $errorMessage, errorCode: $errorCode, pullRequestNumber: $pullRequestNumber, pullRequestUrl: $pullRequestUrl, pullRequestId: $pullRequestId, pullRequestBaseRef: $pullRequestBaseRef, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, fromServer: $fromServer)';
  }
}

/// @nodoc
abstract mixin class _$GithubCopilotSessionModelCopyWith<$Res>
    implements $GithubCopilotSessionModelCopyWith<$Res> {
  factory _$GithubCopilotSessionModelCopyWith(_GithubCopilotSessionModel value,
          $Res Function(_GithubCopilotSessionModel) _then) =
      __$GithubCopilotSessionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String state,
      String? name,
      String? resourceType,
      String? resourceId,
      String? userId,
      String? agentId,
      String? errorMessage,
      String? errorCode,
      int? pullRequestNumber,
      String? pullRequestUrl,
      String? pullRequestId,
      String? pullRequestBaseRef,
      ModelTimestamp? completedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt,
      bool fromServer});
}

/// @nodoc
class __$GithubCopilotSessionModelCopyWithImpl<$Res>
    implements _$GithubCopilotSessionModelCopyWith<$Res> {
  __$GithubCopilotSessionModelCopyWithImpl(this._self, this._then);

  final _GithubCopilotSessionModel _self;
  final $Res Function(_GithubCopilotSessionModel) _then;

  /// Create a copy of GithubCopilotSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? state = null,
    Object? name = freezed,
    Object? resourceType = freezed,
    Object? resourceId = freezed,
    Object? userId = freezed,
    Object? agentId = freezed,
    Object? errorMessage = freezed,
    Object? errorCode = freezed,
    Object? pullRequestNumber = freezed,
    Object? pullRequestUrl = freezed,
    Object? pullRequestId = freezed,
    Object? pullRequestBaseRef = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromServer = null,
  }) {
    return _then(_GithubCopilotSessionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceType: freezed == resourceType
          ? _self.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceId: freezed == resourceId
          ? _self.resourceId
          : resourceId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      agentId: freezed == agentId
          ? _self.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      errorCode: freezed == errorCode
          ? _self.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      pullRequestNumber: freezed == pullRequestNumber
          ? _self.pullRequestNumber
          : pullRequestNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      pullRequestUrl: freezed == pullRequestUrl
          ? _self.pullRequestUrl
          : pullRequestUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pullRequestId: freezed == pullRequestId
          ? _self.pullRequestId
          : pullRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      pullRequestBaseRef: freezed == pullRequestBaseRef
          ? _self.pullRequestBaseRef
          : pullRequestBaseRef // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
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
}

// dart format on
