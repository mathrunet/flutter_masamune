// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_action_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowActionCommandValue {
  String get command;
  int get index;
  Map<String, dynamic> get data;

  /// Create a copy of WorkflowActionCommandValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowActionCommandValueCopyWith<WorkflowActionCommandValue>
      get copyWith =>
          _$WorkflowActionCommandValueCopyWithImpl<WorkflowActionCommandValue>(
              this as WorkflowActionCommandValue, _$identity);

  /// Serializes this WorkflowActionCommandValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowActionCommandValue &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.index, index) || other.index == index) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, command, index, const DeepCollectionEquality().hash(data));

  @override
  String toString() {
    return 'WorkflowActionCommandValue(command: $command, index: $index, data: $data)';
  }
}

/// @nodoc
abstract mixin class $WorkflowActionCommandValueCopyWith<$Res> {
  factory $WorkflowActionCommandValueCopyWith(WorkflowActionCommandValue value,
          $Res Function(WorkflowActionCommandValue) _then) =
      _$WorkflowActionCommandValueCopyWithImpl;
  @useResult
  $Res call({String command, int index, Map<String, dynamic> data});
}

/// @nodoc
class _$WorkflowActionCommandValueCopyWithImpl<$Res>
    implements $WorkflowActionCommandValueCopyWith<$Res> {
  _$WorkflowActionCommandValueCopyWithImpl(this._self, this._then);

  final WorkflowActionCommandValue _self;
  final $Res Function(WorkflowActionCommandValue) _then;

  /// Create a copy of WorkflowActionCommandValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
    Object? index = null,
    Object? data = null,
  }) {
    return _then(_self.copyWith(
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WorkflowActionCommandValue].
extension WorkflowActionCommandValuePatterns on WorkflowActionCommandValue {
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
    TResult Function(_WorkflowActionCommandValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionCommandValue() when $default != null:
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
    TResult Function(_WorkflowActionCommandValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionCommandValue():
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
    TResult? Function(_WorkflowActionCommandValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionCommandValue() when $default != null:
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
    TResult Function(String command, int index, Map<String, dynamic> data)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionCommandValue() when $default != null:
        return $default(_that.command, _that.index, _that.data);
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
    TResult Function(String command, int index, Map<String, dynamic> data)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionCommandValue():
        return $default(_that.command, _that.index, _that.data);
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
    TResult? Function(String command, int index, Map<String, dynamic> data)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowActionCommandValue() when $default != null:
        return $default(_that.command, _that.index, _that.data);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowActionCommandValue extends WorkflowActionCommandValue {
  const _WorkflowActionCommandValue(
      {required this.command,
      required this.index,
      final Map<String, dynamic> data = const {}})
      : _data = data,
        super._();
  factory _WorkflowActionCommandValue.fromJson(Map<String, dynamic> json) =>
      _$WorkflowActionCommandValueFromJson(json);

  @override
  final String command;
  @override
  final int index;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  /// Create a copy of WorkflowActionCommandValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowActionCommandValueCopyWith<_WorkflowActionCommandValue>
      get copyWith => __$WorkflowActionCommandValueCopyWithImpl<
          _WorkflowActionCommandValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowActionCommandValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowActionCommandValue &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.index, index) || other.index == index) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, command, index, const DeepCollectionEquality().hash(_data));

  @override
  String toString() {
    return 'WorkflowActionCommandValue(command: $command, index: $index, data: $data)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowActionCommandValueCopyWith<$Res>
    implements $WorkflowActionCommandValueCopyWith<$Res> {
  factory _$WorkflowActionCommandValueCopyWith(
          _WorkflowActionCommandValue value,
          $Res Function(_WorkflowActionCommandValue) _then) =
      __$WorkflowActionCommandValueCopyWithImpl;
  @override
  @useResult
  $Res call({String command, int index, Map<String, dynamic> data});
}

/// @nodoc
class __$WorkflowActionCommandValueCopyWithImpl<$Res>
    implements _$WorkflowActionCommandValueCopyWith<$Res> {
  __$WorkflowActionCommandValueCopyWithImpl(this._self, this._then);

  final _WorkflowActionCommandValue _self;
  final $Res Function(_WorkflowActionCommandValue) _then;

  /// Create a copy of WorkflowActionCommandValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? command = null,
    Object? index = null,
    Object? data = null,
  }) {
    return _then(_WorkflowActionCommandValue(
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
