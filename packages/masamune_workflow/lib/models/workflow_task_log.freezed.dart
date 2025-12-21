// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_task_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowTaskLogValue {
  int get time;
  String? get message;
  @jsonParam
  WorkflowActionCommandValue? get action;
  TaskLogPhase get phase;
  Map<String, dynamic> get data;

  /// Create a copy of WorkflowTaskLogValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowTaskLogValueCopyWith<WorkflowTaskLogValue> get copyWith =>
      _$WorkflowTaskLogValueCopyWithImpl<WorkflowTaskLogValue>(
          this as WorkflowTaskLogValue, _$identity);

  /// Serializes this WorkflowTaskLogValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowTaskLogValue &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, time, message, action, phase,
      const DeepCollectionEquality().hash(data));

  @override
  String toString() {
    return 'WorkflowTaskLogValue(time: $time, message: $message, action: $action, phase: $phase, data: $data)';
  }
}

/// @nodoc
abstract mixin class $WorkflowTaskLogValueCopyWith<$Res> {
  factory $WorkflowTaskLogValueCopyWith(WorkflowTaskLogValue value,
          $Res Function(WorkflowTaskLogValue) _then) =
      _$WorkflowTaskLogValueCopyWithImpl;
  @useResult
  $Res call(
      {int time,
      String? message,
      @jsonParam WorkflowActionCommandValue? action,
      TaskLogPhase phase,
      Map<String, dynamic> data});

  $WorkflowActionCommandValueCopyWith<$Res>? get action;
}

/// @nodoc
class _$WorkflowTaskLogValueCopyWithImpl<$Res>
    implements $WorkflowTaskLogValueCopyWith<$Res> {
  _$WorkflowTaskLogValueCopyWithImpl(this._self, this._then);

  final WorkflowTaskLogValue _self;
  final $Res Function(WorkflowTaskLogValue) _then;

  /// Create a copy of WorkflowTaskLogValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? message = freezed,
    Object? action = freezed,
    Object? phase = null,
    Object? data = null,
  }) {
    return _then(_self.copyWith(
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      action: freezed == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as WorkflowActionCommandValue?,
      phase: null == phase
          ? _self.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as TaskLogPhase,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of WorkflowTaskLogValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowActionCommandValueCopyWith<$Res>? get action {
    if (_self.action == null) {
      return null;
    }

    return $WorkflowActionCommandValueCopyWith<$Res>(_self.action!, (value) {
      return _then(_self.copyWith(action: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WorkflowTaskLogValue].
extension WorkflowTaskLogValuePatterns on WorkflowTaskLogValue {
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
    TResult Function(_WorkflowTaskLogValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskLogValue() when $default != null:
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
    TResult Function(_WorkflowTaskLogValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskLogValue():
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
    TResult? Function(_WorkflowTaskLogValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskLogValue() when $default != null:
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
            int time,
            String? message,
            @jsonParam WorkflowActionCommandValue? action,
            TaskLogPhase phase,
            Map<String, dynamic> data)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskLogValue() when $default != null:
        return $default(
            _that.time, _that.message, _that.action, _that.phase, _that.data);
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
            int time,
            String? message,
            @jsonParam WorkflowActionCommandValue? action,
            TaskLogPhase phase,
            Map<String, dynamic> data)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskLogValue():
        return $default(
            _that.time, _that.message, _that.action, _that.phase, _that.data);
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
            int time,
            String? message,
            @jsonParam WorkflowActionCommandValue? action,
            TaskLogPhase phase,
            Map<String, dynamic> data)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowTaskLogValue() when $default != null:
        return $default(
            _that.time, _that.message, _that.action, _that.phase, _that.data);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowTaskLogValue extends WorkflowTaskLogValue {
  const _WorkflowTaskLogValue(
      {this.time = 0,
      this.message,
      @jsonParam this.action,
      this.phase = TaskLogPhase.start,
      final Map<String, dynamic> data = const {}})
      : _data = data,
        super._();
  factory _WorkflowTaskLogValue.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTaskLogValueFromJson(json);

  @override
  @JsonKey()
  final int time;
  @override
  final String? message;
  @override
  @jsonParam
  final WorkflowActionCommandValue? action;
  @override
  @JsonKey()
  final TaskLogPhase phase;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  /// Create a copy of WorkflowTaskLogValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowTaskLogValueCopyWith<_WorkflowTaskLogValue> get copyWith =>
      __$WorkflowTaskLogValueCopyWithImpl<_WorkflowTaskLogValue>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowTaskLogValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowTaskLogValue &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, time, message, action, phase,
      const DeepCollectionEquality().hash(_data));

  @override
  String toString() {
    return 'WorkflowTaskLogValue(time: $time, message: $message, action: $action, phase: $phase, data: $data)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowTaskLogValueCopyWith<$Res>
    implements $WorkflowTaskLogValueCopyWith<$Res> {
  factory _$WorkflowTaskLogValueCopyWith(_WorkflowTaskLogValue value,
          $Res Function(_WorkflowTaskLogValue) _then) =
      __$WorkflowTaskLogValueCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int time,
      String? message,
      @jsonParam WorkflowActionCommandValue? action,
      TaskLogPhase phase,
      Map<String, dynamic> data});

  @override
  $WorkflowActionCommandValueCopyWith<$Res>? get action;
}

/// @nodoc
class __$WorkflowTaskLogValueCopyWithImpl<$Res>
    implements _$WorkflowTaskLogValueCopyWith<$Res> {
  __$WorkflowTaskLogValueCopyWithImpl(this._self, this._then);

  final _WorkflowTaskLogValue _self;
  final $Res Function(_WorkflowTaskLogValue) _then;

  /// Create a copy of WorkflowTaskLogValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? time = null,
    Object? message = freezed,
    Object? action = freezed,
    Object? phase = null,
    Object? data = null,
  }) {
    return _then(_WorkflowTaskLogValue(
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      action: freezed == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as WorkflowActionCommandValue?,
      phase: null == phase
          ? _self.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as TaskLogPhase,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of WorkflowTaskLogValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowActionCommandValueCopyWith<$Res>? get action {
    if (_self.action == null) {
      return null;
    }

    return $WorkflowActionCommandValueCopyWith<$Res>(_self.action!, (value) {
      return _then(_self.copyWith(action: value));
    });
  }
}

// dart format on
