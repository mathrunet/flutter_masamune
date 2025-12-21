// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_organization_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowOrganizationMemberModel {
  WorkflowRole get role;
  String? get userId;
  @refParam
  WorkflowOrganizationModelRef get organization;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowOrganizationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowOrganizationMemberModelCopyWith<WorkflowOrganizationMemberModel>
      get copyWith => _$WorkflowOrganizationMemberModelCopyWithImpl<
              WorkflowOrganizationMemberModel>(
          this as WorkflowOrganizationMemberModel, _$identity);

  /// Serializes this WorkflowOrganizationMemberModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowOrganizationMemberModel &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, role, userId, organization, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowOrganizationMemberModel(role: $role, userId: $userId, organization: $organization, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowOrganizationMemberModelCopyWith<$Res> {
  factory $WorkflowOrganizationMemberModelCopyWith(
          WorkflowOrganizationMemberModel value,
          $Res Function(WorkflowOrganizationMemberModel) _then) =
      _$WorkflowOrganizationMemberModelCopyWithImpl;
  @useResult
  $Res call(
      {WorkflowRole role,
      String? userId,
      @refParam WorkflowOrganizationModelRef organization,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowOrganizationMemberModelCopyWithImpl<$Res>
    implements $WorkflowOrganizationMemberModelCopyWith<$Res> {
  _$WorkflowOrganizationMemberModelCopyWithImpl(this._self, this._then);

  final WorkflowOrganizationMemberModel _self;
  final $Res Function(WorkflowOrganizationMemberModel) _then;

  /// Create a copy of WorkflowOrganizationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? userId = freezed,
    Object? organization = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as WorkflowRole,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      createdTime: null == createdTime
          ? _self.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

/// Adds pattern-matching-related methods to [WorkflowOrganizationMemberModel].
extension WorkflowOrganizationMemberModelPatterns
    on WorkflowOrganizationMemberModel {
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
    TResult Function(_WorkflowOrganizationMemberModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationMemberModel() when $default != null:
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
    TResult Function(_WorkflowOrganizationMemberModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationMemberModel():
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
    TResult? Function(_WorkflowOrganizationMemberModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationMemberModel() when $default != null:
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
            WorkflowRole role,
            String? userId,
            @refParam WorkflowOrganizationModelRef organization,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationMemberModel() when $default != null:
        return $default(_that.role, _that.userId, _that.organization,
            _that.createdTime, _that.updatedTime);
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
            WorkflowRole role,
            String? userId,
            @refParam WorkflowOrganizationModelRef organization,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationMemberModel():
        return $default(_that.role, _that.userId, _that.organization,
            _that.createdTime, _that.updatedTime);
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
            WorkflowRole role,
            String? userId,
            @refParam WorkflowOrganizationModelRef organization,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationMemberModel() when $default != null:
        return $default(_that.role, _that.userId, _that.organization,
            _that.createdTime, _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowOrganizationMemberModel extends WorkflowOrganizationMemberModel {
  const _WorkflowOrganizationMemberModel(
      {required this.role,
      this.userId,
      @refParam this.organization,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : super._();
  factory _WorkflowOrganizationMemberModel.fromJson(
          Map<String, dynamic> json) =>
      _$WorkflowOrganizationMemberModelFromJson(json);

  @override
  final WorkflowRole role;
  @override
  final String? userId;
  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowOrganizationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowOrganizationMemberModelCopyWith<_WorkflowOrganizationMemberModel>
      get copyWith => __$WorkflowOrganizationMemberModelCopyWithImpl<
          _WorkflowOrganizationMemberModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowOrganizationMemberModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowOrganizationMemberModel &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, role, userId, organization, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowOrganizationMemberModel(role: $role, userId: $userId, organization: $organization, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowOrganizationMemberModelCopyWith<$Res>
    implements $WorkflowOrganizationMemberModelCopyWith<$Res> {
  factory _$WorkflowOrganizationMemberModelCopyWith(
          _WorkflowOrganizationMemberModel value,
          $Res Function(_WorkflowOrganizationMemberModel) _then) =
      __$WorkflowOrganizationMemberModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {WorkflowRole role,
      String? userId,
      @refParam WorkflowOrganizationModelRef organization,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowOrganizationMemberModelCopyWithImpl<$Res>
    implements _$WorkflowOrganizationMemberModelCopyWith<$Res> {
  __$WorkflowOrganizationMemberModelCopyWithImpl(this._self, this._then);

  final _WorkflowOrganizationMemberModel _self;
  final $Res Function(_WorkflowOrganizationMemberModel) _then;

  /// Create a copy of WorkflowOrganizationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? role = null,
    Object? userId = freezed,
    Object? organization = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowOrganizationMemberModel(
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as WorkflowRole,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      createdTime: null == createdTime
          ? _self.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedTime: null == updatedTime
          ? _self.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

// dart format on
