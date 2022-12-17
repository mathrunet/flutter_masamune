// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_field_value_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TestValue _$TestValueFromJson(Map<String, dynamic> json) {
  return _TestValue.fromJson(json);
}

/// @nodoc
mixin _$TestValue {
  ModelTimestamp get time => throw _privateConstructorUsedError;
  ModelCounter get counter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TestValueCopyWith<TestValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestValueCopyWith<$Res> {
  factory $TestValueCopyWith(TestValue value, $Res Function(TestValue) then) =
      _$TestValueCopyWithImpl<$Res, TestValue>;
  @useResult
  $Res call({ModelTimestamp time, ModelCounter counter});
}

/// @nodoc
class _$TestValueCopyWithImpl<$Res, $Val extends TestValue>
    implements $TestValueCopyWith<$Res> {
  _$TestValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? counter = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      counter: null == counter
          ? _value.counter
          : counter // ignore: cast_nullable_to_non_nullable
              as ModelCounter,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TestValueCopyWith<$Res> implements $TestValueCopyWith<$Res> {
  factory _$$_TestValueCopyWith(
          _$_TestValue value, $Res Function(_$_TestValue) then) =
      __$$_TestValueCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ModelTimestamp time, ModelCounter counter});
}

/// @nodoc
class __$$_TestValueCopyWithImpl<$Res>
    extends _$TestValueCopyWithImpl<$Res, _$_TestValue>
    implements _$$_TestValueCopyWith<$Res> {
  __$$_TestValueCopyWithImpl(
      _$_TestValue _value, $Res Function(_$_TestValue) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? counter = null,
  }) {
    return _then(_$_TestValue(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      counter: null == counter
          ? _value.counter
          : counter // ignore: cast_nullable_to_non_nullable
              as ModelCounter,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TestValue implements _TestValue {
  const _$_TestValue(
      {this.time = const ModelTimestamp(),
      this.counter = const ModelCounter(0)});

  factory _$_TestValue.fromJson(Map<String, dynamic> json) =>
      _$$_TestValueFromJson(json);

  @override
  @JsonKey()
  final ModelTimestamp time;
  @override
  @JsonKey()
  final ModelCounter counter;

  @override
  String toString() {
    return 'TestValue(time: $time, counter: $counter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TestValue &&
            const DeepCollectionEquality().equals(other.time, time) &&
            const DeepCollectionEquality().equals(other.counter, counter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(time),
      const DeepCollectionEquality().hash(counter));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TestValueCopyWith<_$_TestValue> get copyWith =>
      __$$_TestValueCopyWithImpl<_$_TestValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TestValueToJson(
      this,
    );
  }
}

abstract class _TestValue implements TestValue {
  const factory _TestValue(
      {final ModelTimestamp time, final ModelCounter counter}) = _$_TestValue;

  factory _TestValue.fromJson(Map<String, dynamic> json) =
      _$_TestValue.fromJson;

  @override
  ModelTimestamp get time;
  @override
  ModelCounter get counter;
  @override
  @JsonKey(ignore: true)
  _$$_TestValueCopyWith<_$_TestValue> get copyWith =>
      throw _privateConstructorUsedError;
}
