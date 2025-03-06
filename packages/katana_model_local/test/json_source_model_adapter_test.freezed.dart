// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'json_source_model_adapter_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TestValue _$TestValueFromJson(Map<String, dynamic> json) {
  return _TestValue.fromJson(json);
}

/// @nodoc
mixin _$TestValue {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  double? get percent => throw _privateConstructorUsedError;
  bool get flag => throw _privateConstructorUsedError;

  /// Serializes this TestValue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestValueCopyWith<TestValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestValueCopyWith<$Res> {
  factory $TestValueCopyWith(TestValue value, $Res Function(TestValue) then) =
      _$TestValueCopyWithImpl<$Res, TestValue>;
  @useResult
  $Res call({String id, String? name, int? age, double? percent, bool flag});
}

/// @nodoc
class _$TestValueCopyWithImpl<$Res, $Val extends TestValue>
    implements $TestValueCopyWith<$Res> {
  _$TestValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? age = freezed,
    Object? percent = freezed,
    Object? flag = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      percent: freezed == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double?,
      flag: null == flag
          ? _value.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestValueImplCopyWith<$Res>
    implements $TestValueCopyWith<$Res> {
  factory _$$TestValueImplCopyWith(
          _$TestValueImpl value, $Res Function(_$TestValueImpl) then) =
      __$$TestValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? name, int? age, double? percent, bool flag});
}

/// @nodoc
class __$$TestValueImplCopyWithImpl<$Res>
    extends _$TestValueCopyWithImpl<$Res, _$TestValueImpl>
    implements _$$TestValueImplCopyWith<$Res> {
  __$$TestValueImplCopyWithImpl(
      _$TestValueImpl _value, $Res Function(_$TestValueImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? age = freezed,
    Object? percent = freezed,
    Object? flag = null,
  }) {
    return _then(_$TestValueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      percent: freezed == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double?,
      flag: null == flag
          ? _value.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestValueImpl implements _TestValue {
  const _$TestValueImpl(
      {required this.id, this.name, this.age, this.percent, this.flag = false});

  factory _$TestValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestValueImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final int? age;
  @override
  final double? percent;
  @override
  @JsonKey()
  final bool flag;

  @override
  String toString() {
    return 'TestValue(id: $id, name: $name, age: $age, percent: $percent, flag: $flag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestValueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.flag, flag) || other.flag == flag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, age, percent, flag);

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestValueImplCopyWith<_$TestValueImpl> get copyWith =>
      __$$TestValueImplCopyWithImpl<_$TestValueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestValueImplToJson(
      this,
    );
  }
}

abstract class _TestValue implements TestValue {
  const factory _TestValue(
      {required final String id,
      final String? name,
      final int? age,
      final double? percent,
      final bool flag}) = _$TestValueImpl;

  factory _TestValue.fromJson(Map<String, dynamic> json) =
      _$TestValueImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  int? get age;
  @override
  double? get percent;
  @override
  bool get flag;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestValueImplCopyWith<_$TestValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
