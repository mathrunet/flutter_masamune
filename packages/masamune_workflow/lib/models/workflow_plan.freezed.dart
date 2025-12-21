// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowPlanModel {
  double get limit;
  double get burst;

  /// Create a copy of WorkflowPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowPlanModelCopyWith<WorkflowPlanModel> get copyWith =>
      _$WorkflowPlanModelCopyWithImpl<WorkflowPlanModel>(
          this as WorkflowPlanModel, _$identity);

  /// Serializes this WorkflowPlanModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowPlanModel &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.burst, burst) || other.burst == burst));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, limit, burst);

  @override
  String toString() {
    return 'WorkflowPlanModel(limit: $limit, burst: $burst)';
  }
}

/// @nodoc
abstract mixin class $WorkflowPlanModelCopyWith<$Res> {
  factory $WorkflowPlanModelCopyWith(
          WorkflowPlanModel value, $Res Function(WorkflowPlanModel) _then) =
      _$WorkflowPlanModelCopyWithImpl;
  @useResult
  $Res call({double limit, double burst});
}

/// @nodoc
class _$WorkflowPlanModelCopyWithImpl<$Res>
    implements $WorkflowPlanModelCopyWith<$Res> {
  _$WorkflowPlanModelCopyWithImpl(this._self, this._then);

  final WorkflowPlanModel _self;
  final $Res Function(WorkflowPlanModel) _then;

  /// Create a copy of WorkflowPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limit = null,
    Object? burst = null,
  }) {
    return _then(_self.copyWith(
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      burst: null == burst
          ? _self.burst
          : burst // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [WorkflowPlanModel].
extension WorkflowPlanModelPatterns on WorkflowPlanModel {
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
    TResult Function(_WorkflowPlanModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowPlanModel() when $default != null:
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
    TResult Function(_WorkflowPlanModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPlanModel():
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
    TResult? Function(_WorkflowPlanModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPlanModel() when $default != null:
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
    TResult Function(double limit, double burst)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowPlanModel() when $default != null:
        return $default(_that.limit, _that.burst);
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
    TResult Function(double limit, double burst) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPlanModel():
        return $default(_that.limit, _that.burst);
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
    TResult? Function(double limit, double burst)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowPlanModel() when $default != null:
        return $default(_that.limit, _that.burst);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowPlanModel extends WorkflowPlanModel {
  const _WorkflowPlanModel({this.limit = 0, this.burst = 0}) : super._();
  factory _WorkflowPlanModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowPlanModelFromJson(json);

  @override
  @JsonKey()
  final double limit;
  @override
  @JsonKey()
  final double burst;

  /// Create a copy of WorkflowPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowPlanModelCopyWith<_WorkflowPlanModel> get copyWith =>
      __$WorkflowPlanModelCopyWithImpl<_WorkflowPlanModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowPlanModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowPlanModel &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.burst, burst) || other.burst == burst));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, limit, burst);

  @override
  String toString() {
    return 'WorkflowPlanModel(limit: $limit, burst: $burst)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowPlanModelCopyWith<$Res>
    implements $WorkflowPlanModelCopyWith<$Res> {
  factory _$WorkflowPlanModelCopyWith(
          _WorkflowPlanModel value, $Res Function(_WorkflowPlanModel) _then) =
      __$WorkflowPlanModelCopyWithImpl;
  @override
  @useResult
  $Res call({double limit, double burst});
}

/// @nodoc
class __$WorkflowPlanModelCopyWithImpl<$Res>
    implements _$WorkflowPlanModelCopyWith<$Res> {
  __$WorkflowPlanModelCopyWithImpl(this._self, this._then);

  final _WorkflowPlanModel _self;
  final $Res Function(_WorkflowPlanModel) _then;

  /// Create a copy of WorkflowPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? limit = null,
    Object? burst = null,
  }) {
    return _then(_WorkflowPlanModel(
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      burst: null == burst
          ? _self.burst
          : burst // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
