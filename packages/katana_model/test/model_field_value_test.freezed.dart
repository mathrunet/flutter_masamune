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
  ModelUri get uri => throw _privateConstructorUsedError;
  ModelGeoValue get geo => throw _privateConstructorUsedError;
  ModelSearch get search => throw _privateConstructorUsedError;

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
  $Res call(
      {ModelTimestamp time,
      ModelCounter counter,
      ModelUri uri,
      ModelGeoValue geo,
      ModelSearch search});
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
    Object? uri = null,
    Object? geo = null,
    Object? search = null,
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
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as ModelUri,
      geo: null == geo
          ? _value.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as ModelGeoValue,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as ModelSearch,
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
  $Res call(
      {ModelTimestamp time,
      ModelCounter counter,
      ModelUri uri,
      ModelGeoValue geo,
      ModelSearch search});
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
    Object? uri = null,
    Object? geo = null,
    Object? search = null,
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
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as ModelUri,
      geo: null == geo
          ? _value.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as ModelGeoValue,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as ModelSearch,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TestValue implements _TestValue {
  const _$_TestValue(
      {this.time = const ModelTimestamp(),
      this.counter = const ModelCounter(0),
      this.uri = const ModelUri(),
      this.geo = const ModelGeoValue(),
      this.search = const ModelSearch([])});

  factory _$_TestValue.fromJson(Map<String, dynamic> json) =>
      _$$_TestValueFromJson(json);

  @override
  @JsonKey()
  final ModelTimestamp time;
  @override
  @JsonKey()
  final ModelCounter counter;
  @override
  @JsonKey()
  final ModelUri uri;
  @override
  @JsonKey()
  final ModelGeoValue geo;
  @override
  @JsonKey()
  final ModelSearch search;

  @override
  String toString() {
    return 'TestValue(time: $time, counter: $counter, uri: $uri, geo: $geo, search: $search)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TestValue &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.counter, counter) || other.counter == counter) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.geo, geo) || other.geo == geo) &&
            (identical(other.search, search) || other.search == search));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, time, counter, uri, geo, search);

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
      {final ModelTimestamp time,
      final ModelCounter counter,
      final ModelUri uri,
      final ModelGeoValue geo,
      final ModelSearch search}) = _$_TestValue;

  factory _TestValue.fromJson(Map<String, dynamic> json) =
      _$_TestValue.fromJson;

  @override
  ModelTimestamp get time;
  @override
  ModelCounter get counter;
  @override
  ModelUri get uri;
  @override
  ModelGeoValue get geo;
  @override
  ModelSearch get search;
  @override
  @JsonKey(ignore: true)
  _$$_TestValueCopyWith<_$_TestValue> get copyWith =>
      throw _privateConstructorUsedError;
}
