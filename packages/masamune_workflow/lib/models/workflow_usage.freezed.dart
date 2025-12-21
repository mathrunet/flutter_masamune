// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowUsageModel {
  @refParam
  WorkflowOrganizationModelRef get organization;
  double get usage;
  String? get latestPlan;
  double get bucketBalance;
  ModelTimestamp? get lastCheckTime;
  String? get currentMonth;
  ModelTimestamp get createdTime;
  ModelTimestamp get updatedTime;

  /// Create a copy of WorkflowUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowUsageModelCopyWith<WorkflowUsageModel> get copyWith =>
      _$WorkflowUsageModelCopyWithImpl<WorkflowUsageModel>(
          this as WorkflowUsageModel, _$identity);

  /// Serializes this WorkflowUsageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowUsageModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.latestPlan, latestPlan) ||
                other.latestPlan == latestPlan) &&
            (identical(other.bucketBalance, bucketBalance) ||
                other.bucketBalance == bucketBalance) &&
            (identical(other.lastCheckTime, lastCheckTime) ||
                other.lastCheckTime == lastCheckTime) &&
            (identical(other.currentMonth, currentMonth) ||
                other.currentMonth == currentMonth) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, organization, usage, latestPlan,
      bucketBalance, lastCheckTime, currentMonth, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowUsageModel(organization: $organization, usage: $usage, latestPlan: $latestPlan, bucketBalance: $bucketBalance, lastCheckTime: $lastCheckTime, currentMonth: $currentMonth, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class $WorkflowUsageModelCopyWith<$Res> {
  factory $WorkflowUsageModelCopyWith(
          WorkflowUsageModel value, $Res Function(WorkflowUsageModel) _then) =
      _$WorkflowUsageModelCopyWithImpl;
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      double usage,
      String? latestPlan,
      double bucketBalance,
      ModelTimestamp? lastCheckTime,
      String? currentMonth,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class _$WorkflowUsageModelCopyWithImpl<$Res>
    implements $WorkflowUsageModelCopyWith<$Res> {
  _$WorkflowUsageModelCopyWithImpl(this._self, this._then);

  final WorkflowUsageModel _self;
  final $Res Function(WorkflowUsageModel) _then;

  /// Create a copy of WorkflowUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organization = freezed,
    Object? usage = null,
    Object? latestPlan = freezed,
    Object? bucketBalance = null,
    Object? lastCheckTime = freezed,
    Object? currentMonth = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_self.copyWith(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      usage: null == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as double,
      latestPlan: freezed == latestPlan
          ? _self.latestPlan
          : latestPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      bucketBalance: null == bucketBalance
          ? _self.bucketBalance
          : bucketBalance // ignore: cast_nullable_to_non_nullable
              as double,
      lastCheckTime: freezed == lastCheckTime
          ? _self.lastCheckTime
          : lastCheckTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      currentMonth: freezed == currentMonth
          ? _self.currentMonth
          : currentMonth // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [WorkflowUsageModel].
extension WorkflowUsageModelPatterns on WorkflowUsageModel {
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
    TResult Function(_WorkflowUsageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowUsageModel() when $default != null:
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
    TResult Function(_WorkflowUsageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowUsageModel():
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
    TResult? Function(_WorkflowUsageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowUsageModel() when $default != null:
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
            double usage,
            String? latestPlan,
            double bucketBalance,
            ModelTimestamp? lastCheckTime,
            String? currentMonth,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowUsageModel() when $default != null:
        return $default(
            _that.organization,
            _that.usage,
            _that.latestPlan,
            _that.bucketBalance,
            _that.lastCheckTime,
            _that.currentMonth,
            _that.createdTime,
            _that.updatedTime);
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
            double usage,
            String? latestPlan,
            double bucketBalance,
            ModelTimestamp? lastCheckTime,
            String? currentMonth,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowUsageModel():
        return $default(
            _that.organization,
            _that.usage,
            _that.latestPlan,
            _that.bucketBalance,
            _that.lastCheckTime,
            _that.currentMonth,
            _that.createdTime,
            _that.updatedTime);
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
            double usage,
            String? latestPlan,
            double bucketBalance,
            ModelTimestamp? lastCheckTime,
            String? currentMonth,
            ModelTimestamp createdTime,
            ModelTimestamp updatedTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowUsageModel() when $default != null:
        return $default(
            _that.organization,
            _that.usage,
            _that.latestPlan,
            _that.bucketBalance,
            _that.lastCheckTime,
            _that.currentMonth,
            _that.createdTime,
            _that.updatedTime);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowUsageModel extends WorkflowUsageModel {
  const _WorkflowUsageModel(
      {@refParam this.organization,
      this.usage = 0,
      this.latestPlan,
      this.bucketBalance = 0,
      this.lastCheckTime,
      this.currentMonth,
      this.createdTime = const ModelTimestamp.now(),
      this.updatedTime = const ModelTimestamp.now()})
      : super._();
  factory _WorkflowUsageModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowUsageModelFromJson(json);

  @override
  @refParam
  final WorkflowOrganizationModelRef organization;
  @override
  @JsonKey()
  final double usage;
  @override
  final String? latestPlan;
  @override
  @JsonKey()
  final double bucketBalance;
  @override
  final ModelTimestamp? lastCheckTime;
  @override
  final String? currentMonth;
  @override
  @JsonKey()
  final ModelTimestamp createdTime;
  @override
  @JsonKey()
  final ModelTimestamp updatedTime;

  /// Create a copy of WorkflowUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowUsageModelCopyWith<_WorkflowUsageModel> get copyWith =>
      __$WorkflowUsageModelCopyWithImpl<_WorkflowUsageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowUsageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowUsageModel &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.latestPlan, latestPlan) ||
                other.latestPlan == latestPlan) &&
            (identical(other.bucketBalance, bucketBalance) ||
                other.bucketBalance == bucketBalance) &&
            (identical(other.lastCheckTime, lastCheckTime) ||
                other.lastCheckTime == lastCheckTime) &&
            (identical(other.currentMonth, currentMonth) ||
                other.currentMonth == currentMonth) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, organization, usage, latestPlan,
      bucketBalance, lastCheckTime, currentMonth, createdTime, updatedTime);

  @override
  String toString() {
    return 'WorkflowUsageModel(organization: $organization, usage: $usage, latestPlan: $latestPlan, bucketBalance: $bucketBalance, lastCheckTime: $lastCheckTime, currentMonth: $currentMonth, createdTime: $createdTime, updatedTime: $updatedTime)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowUsageModelCopyWith<$Res>
    implements $WorkflowUsageModelCopyWith<$Res> {
  factory _$WorkflowUsageModelCopyWith(
          _WorkflowUsageModel value, $Res Function(_WorkflowUsageModel) _then) =
      __$WorkflowUsageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@refParam WorkflowOrganizationModelRef organization,
      double usage,
      String? latestPlan,
      double bucketBalance,
      ModelTimestamp? lastCheckTime,
      String? currentMonth,
      ModelTimestamp createdTime,
      ModelTimestamp updatedTime});
}

/// @nodoc
class __$WorkflowUsageModelCopyWithImpl<$Res>
    implements _$WorkflowUsageModelCopyWith<$Res> {
  __$WorkflowUsageModelCopyWithImpl(this._self, this._then);

  final _WorkflowUsageModel _self;
  final $Res Function(_WorkflowUsageModel) _then;

  /// Create a copy of WorkflowUsageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? organization = freezed,
    Object? usage = null,
    Object? latestPlan = freezed,
    Object? bucketBalance = null,
    Object? lastCheckTime = freezed,
    Object? currentMonth = freezed,
    Object? createdTime = null,
    Object? updatedTime = null,
  }) {
    return _then(_WorkflowUsageModel(
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as WorkflowOrganizationModelRef,
      usage: null == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as double,
      latestPlan: freezed == latestPlan
          ? _self.latestPlan
          : latestPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      bucketBalance: null == bucketBalance
          ? _self.bucketBalance
          : bucketBalance // ignore: cast_nullable_to_non_nullable
              as double,
      lastCheckTime: freezed == lastCheckTime
          ? _self.lastCheckTime
          : lastCheckTime // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      currentMonth: freezed == currentMonth
          ? _self.currentMonth
          : currentMonth // ignore: cast_nullable_to_non_nullable
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
