// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'json_source_model_adapter_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestValue {
  String get id;
  String? get name;
  int? get age;
  double? get percent;
  bool get flag;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestValueCopyWith<TestValue> get copyWith =>
      _$TestValueCopyWithImpl<TestValue>(this as TestValue, _$identity);

  /// Serializes this TestValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestValue &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.flag, flag) || other.flag == flag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, age, percent, flag);

  @override
  String toString() {
    return 'TestValue(id: $id, name: $name, age: $age, percent: $percent, flag: $flag)';
  }
}

/// @nodoc
abstract mixin class $TestValueCopyWith<$Res> {
  factory $TestValueCopyWith(TestValue value, $Res Function(TestValue) _then) =
      _$TestValueCopyWithImpl;
  @useResult
  $Res call({String id, String? name, int? age, double? percent, bool flag});
}

/// @nodoc
class _$TestValueCopyWithImpl<$Res> implements $TestValueCopyWith<$Res> {
  _$TestValueCopyWithImpl(this._self, this._then);

  final TestValue _self;
  final $Res Function(TestValue) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      percent: freezed == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double?,
      flag: null == flag
          ? _self.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TestValue implements TestValue {
  const _TestValue(
      {required this.id, this.name, this.age, this.percent, this.flag = false});
  factory _TestValue.fromJson(Map<String, dynamic> json) =>
      _$TestValueFromJson(json);

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

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestValueCopyWith<_TestValue> get copyWith =>
      __$TestValueCopyWithImpl<_TestValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestValue &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.flag, flag) || other.flag == flag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, age, percent, flag);

  @override
  String toString() {
    return 'TestValue(id: $id, name: $name, age: $age, percent: $percent, flag: $flag)';
  }
}

/// @nodoc
abstract mixin class _$TestValueCopyWith<$Res>
    implements $TestValueCopyWith<$Res> {
  factory _$TestValueCopyWith(
          _TestValue value, $Res Function(_TestValue) _then) =
      __$TestValueCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String? name, int? age, double? percent, bool flag});
}

/// @nodoc
class __$TestValueCopyWithImpl<$Res> implements _$TestValueCopyWith<$Res> {
  __$TestValueCopyWithImpl(this._self, this._then);

  final _TestValue _self;
  final $Res Function(_TestValue) _then;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? age = freezed,
    Object? percent = freezed,
    Object? flag = null,
  }) {
    return _then(_TestValue(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      percent: freezed == percent
          ? _self.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double?,
      flag: null == flag
          ? _self.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
