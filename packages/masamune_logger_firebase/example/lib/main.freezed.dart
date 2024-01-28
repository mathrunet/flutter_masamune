// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AnalyticsValue _$AnalyticsValueFromJson(Map<String, dynamic> json) {
  return _AnalyticsValue.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsValue {
  String get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnalyticsValueCopyWith<AnalyticsValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsValueCopyWith<$Res> {
  factory $AnalyticsValueCopyWith(
          AnalyticsValue value, $Res Function(AnalyticsValue) then) =
      _$AnalyticsValueCopyWithImpl<$Res, AnalyticsValue>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class _$AnalyticsValueCopyWithImpl<$Res, $Val extends AnalyticsValue>
    implements $AnalyticsValueCopyWith<$Res> {
  _$AnalyticsValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsValueImplCopyWith<$Res>
    implements $AnalyticsValueCopyWith<$Res> {
  factory _$$AnalyticsValueImplCopyWith(_$AnalyticsValueImpl value,
          $Res Function(_$AnalyticsValueImpl) then) =
      __$$AnalyticsValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$AnalyticsValueImplCopyWithImpl<$Res>
    extends _$AnalyticsValueCopyWithImpl<$Res, _$AnalyticsValueImpl>
    implements _$$AnalyticsValueImplCopyWith<$Res> {
  __$$AnalyticsValueImplCopyWithImpl(
      _$AnalyticsValueImpl _value, $Res Function(_$AnalyticsValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$AnalyticsValueImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsValueImpl extends _AnalyticsValue {
  const _$AnalyticsValueImpl({required this.userId}) : super._();

  factory _$AnalyticsValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsValueImplFromJson(json);

  @override
  final String userId;

  @override
  String toString() {
    return 'AnalyticsValue(userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsValueImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsValueImplCopyWith<_$AnalyticsValueImpl> get copyWith =>
      __$$AnalyticsValueImplCopyWithImpl<_$AnalyticsValueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsValueImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsValue extends AnalyticsValue {
  const factory _AnalyticsValue({required final String userId}) =
      _$AnalyticsValueImpl;
  const _AnalyticsValue._() : super._();

  factory _AnalyticsValue.fromJson(Map<String, dynamic> json) =
      _$AnalyticsValueImpl.fromJson;

  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$AnalyticsValueImplCopyWith<_$AnalyticsValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
