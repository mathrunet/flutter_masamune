// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_campaign.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowCampaignModel {
  @refParam
  WorkflowOrganizationModelRef get organization;
  double get limit;
  ModelTimestamp? get expiredTime;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowCampaignModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowCampaignModelCopyWith<WorkflowCampaignModel> get copyWith =>
      _$WorkflowCampaignModelCopyWithImpl<WorkflowCampaignModel>(
          this as WorkflowCampaignModel, _$identity);

  /// Serializes this WorkflowCampaignModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowCampaignModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.expiredTime, expiredTime) ||
                other.expiredTime == expiredTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, organization, limit, expiredTime, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowCampaignModel(organization: $organization, limit: $limit, expiredTime: $expiredTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowCampaignModelCopyWith<$Res> {
  factory $WorkflowCampaignModelCopyWith(WorkflowCampaignModel value,
          $Res Function(WorkflowCampaignModel) _then) =
      _$WorkflowCampaignModelCopyWithImpl;
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      double limit,
      ModelTimestamp? expiredTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowCampaignModelCopyWithImpl<$Res>
    implements $WorkflowCampaignModelCopyWith<$Res> {
  _$WorkflowCampaignModelCopyWithImpl(this._self, this._then);

  final WorkflowCampaignModel _self;
  final $Res Function(WorkflowCampaignModel) _then;

  /// Create a copy of WorkflowCampaignModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organization = freezed,
    Object? limit = null,
    Object? expiredTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      expiredTime: freezed == expiredTime
          ? _self.expiredTime
          : expiredTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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

/// Adds pattern-matching-related methods to [WorkflowCampaignModel].
extension WorkflowCampaignModelPatterns on WorkflowCampaignModel {
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
    TResult Function(_WorkflowCampaignModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowCampaignModel() when $default != null:
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
    TResult Function(_WorkflowCampaignModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCampaignModel():
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
    TResult? Function(_WorkflowCampaignModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCampaignModel() when $default != null:
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
            @refParam WorkflowOrganizationModelRef organization,
            double limit,
            ModelTimestamp? expiredTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowCampaignModel() when $default != null:
        return $default(_that.organization, _that.limit, _that.expiredTime,
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
            @refParam WorkflowOrganizationModelRef organization,
            double limit,
            ModelTimestamp? expiredTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCampaignModel():
        return $default(_that.organization, _that.limit, _that.expiredTime,
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
            @refParam WorkflowOrganizationModelRef organization,
            double limit,
            ModelTimestamp? expiredTime,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowCampaignModel() when $default != null:
        return $default(_that.organization, _that.limit, _that.expiredTime,
            _that.createdTime, _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowCampaignModel extends WorkflowCampaignModel {
  const _WorkflowCampaignModel(
      {@refParam this.organization,
      this.limit = 0,
      this.expiredTime,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : super._();
  factory _WorkflowCampaignModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowCampaignModelFromJson(json);

  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  @JsonKey()
  final double limit;
  @override
  final ModelTimestamp? expiredTime;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowCampaignModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowCampaignModelCopyWith<_WorkflowCampaignModel> get copyWith =>
      __$WorkflowCampaignModelCopyWithImpl<_WorkflowCampaignModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowCampaignModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowCampaignModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.expiredTime, expiredTime) ||
                other.expiredTime == expiredTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, organization, limit, expiredTime, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowCampaignModel(organization: $organization, limit: $limit, expiredTime: $expiredTime, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowCampaignModelCopyWith<$Res>
    implements $WorkflowCampaignModelCopyWith<$Res> {
  factory _$WorkflowCampaignModelCopyWith(_WorkflowCampaignModel value,
          $Res Function(_WorkflowCampaignModel) _then) =
      __$WorkflowCampaignModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      double limit,
      ModelTimestamp? expiredTime,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowCampaignModelCopyWithImpl<$Res>
    implements _$WorkflowCampaignModelCopyWith<$Res> {
  __$WorkflowCampaignModelCopyWithImpl(this._self, this._then);

  final _WorkflowCampaignModel _self;
  final $Res Function(_WorkflowCampaignModel) _then;

  /// Create a copy of WorkflowCampaignModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? organization = freezed,
    Object? limit = null,
    Object? expiredTime = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowCampaignModel(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      expiredTime: freezed == expiredTime
          ? _self.expiredTime
          : expiredTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
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
