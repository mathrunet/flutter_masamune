// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowOrganizationModel {
  String? get name;
  String? get description;
  String? get icon;
  String? get ownerId;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowOrganizationModelCopyWith<WorkflowOrganizationModel> get copyWith =>
      _$WorkflowOrganizationModelCopyWithImpl<WorkflowOrganizationModel>(
          this as WorkflowOrganizationModel, _$identity);

  /// Serializes this WorkflowOrganizationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowOrganizationModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, description, icon, ownerId, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowOrganizationModel(name: $name, description: $description, icon: $icon, ownerId: $ownerId, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowOrganizationModelCopyWith<$Res> {
  factory $WorkflowOrganizationModelCopyWith(WorkflowOrganizationModel value,
          $Res Function(WorkflowOrganizationModel) _then) =
      _$WorkflowOrganizationModelCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? description,
      String? icon,
      String? ownerId,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowOrganizationModelCopyWithImpl<$Res>
    implements $WorkflowOrganizationModelCopyWith<$Res> {
  _$WorkflowOrganizationModelCopyWithImpl(this._self, this._then);

  final WorkflowOrganizationModel _self;
  final $Res Function(WorkflowOrganizationModel) _then;

  /// Create a copy of WorkflowOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? icon = freezed,
    Object? ownerId = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// Adds pattern-matching-related methods to [WorkflowOrganizationModel].
extension WorkflowOrganizationModelPatterns on WorkflowOrganizationModel {
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
    TResult Function(_WorkflowOrganizationModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationModel() when $default != null:
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
    TResult Function(_WorkflowOrganizationModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationModel():
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
    TResult? Function(_WorkflowOrganizationModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationModel() when $default != null:
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
            String? name,
            String? description,
            String? icon,
            String? ownerId,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationModel() when $default != null:
        return $default(_that.name, _that.description, _that.icon,
            _that.ownerId, _that.createdTime, _that.updatedTime);
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
            String? name,
            String? description,
            String? icon,
            String? ownerId,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationModel():
        return $default(_that.name, _that.description, _that.icon,
            _that.ownerId, _that.createdTime, _that.updatedTime);
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
            String? name,
            String? description,
            String? icon,
            String? ownerId,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowOrganizationModel() when $default != null:
        return $default(_that.name, _that.description, _that.icon,
            _that.ownerId, _that.createdTime, _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowOrganizationModel extends WorkflowOrganizationModel {
  const _WorkflowOrganizationModel(
      {this.name,
      this.description,
      this.icon,
      this.ownerId,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : super._();
  factory _WorkflowOrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowOrganizationModelFromJson(json);

  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  final String? ownerId;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowOrganizationModelCopyWith<_WorkflowOrganizationModel>
      get copyWith =>
          __$WorkflowOrganizationModelCopyWithImpl<_WorkflowOrganizationModel>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowOrganizationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowOrganizationModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, description, icon, ownerId, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowOrganizationModel(name: $name, description: $description, icon: $icon, ownerId: $ownerId, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowOrganizationModelCopyWith<$Res>
    implements $WorkflowOrganizationModelCopyWith<$Res> {
  factory _$WorkflowOrganizationModelCopyWith(_WorkflowOrganizationModel value,
          $Res Function(_WorkflowOrganizationModel) _then) =
      __$WorkflowOrganizationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? description,
      String? icon,
      String? ownerId,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowOrganizationModelCopyWithImpl<$Res>
    implements _$WorkflowOrganizationModelCopyWith<$Res> {
  __$WorkflowOrganizationModelCopyWithImpl(this._self, this._then);

  final _WorkflowOrganizationModel _self;
  final $Res Function(_WorkflowOrganizationModel) _then;

  /// Create a copy of WorkflowOrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? icon = freezed,
    Object? ownerId = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowOrganizationModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
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
