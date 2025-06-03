// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of "listenable_firestore_model_test.dart";

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
  String? get name => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<int> get ids => throw _privateConstructorUsedError;

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
  $Res call({String? name, String? text, List<int> ids});
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
    Object? name = freezed,
    Object? text = freezed,
    Object? ids = null,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      ids: null == ids
          ? _value.ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<int>,
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
  $Res call({String? name, String? text, List<int> ids});
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
    Object? name = freezed,
    Object? text = freezed,
    Object? ids = null,
  }) {
    return _then(_$TestValueImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      ids: null == ids
          ? _value._ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestValueImpl implements _TestValue {
  const _$TestValueImpl({this.name, this.text, final List<int> ids = const []})
      : _ids = ids;

  factory _$TestValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestValueImplFromJson(json);

  @override
  final String? name;
  @override
  final String? text;
  final List<int> _ids;
  @override
  @JsonKey()
  List<int> get ids {
    if (_ids is EqualUnmodifiableListView) return _ids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ids);
  }

  @override
  String toString() {
    return 'TestValue(name: $name, text: $text, ids: $ids)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestValueImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._ids, _ids));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, text, const DeepCollectionEquality().hash(_ids));

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
      {final String? name,
      final String? text,
      final List<int> ids}) = _$TestValueImpl;

  factory _TestValue.fromJson(Map<String, dynamic> json) =
      _$TestValueImpl.fromJson;

  @override
  String? get name;
  @override
  String? get text;
  @override
  List<int> get ids;

  /// Create a copy of TestValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestValueImplCopyWith<_$TestValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
