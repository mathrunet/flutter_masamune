// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PurchaseUserModel _$PurchaseUserModelFromJson(Map<String, dynamic> json) {
  return _PurchaseUserModel.fromJson(json);
}

/// @nodoc
mixin _$PurchaseUserModel {
  double get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseUserModelCopyWith<PurchaseUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseUserModelCopyWith<$Res> {
  factory $PurchaseUserModelCopyWith(
          PurchaseUserModel value, $Res Function(PurchaseUserModel) then) =
      _$PurchaseUserModelCopyWithImpl<$Res, PurchaseUserModel>;
  @useResult
  $Res call({double value});
}

/// @nodoc
class _$PurchaseUserModelCopyWithImpl<$Res, $Val extends PurchaseUserModel>
    implements $PurchaseUserModelCopyWith<$Res> {
  _$PurchaseUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseUserModelImplCopyWith<$Res>
    implements $PurchaseUserModelCopyWith<$Res> {
  factory _$$PurchaseUserModelImplCopyWith(_$PurchaseUserModelImpl value,
          $Res Function(_$PurchaseUserModelImpl) then) =
      __$$PurchaseUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double value});
}

/// @nodoc
class __$$PurchaseUserModelImplCopyWithImpl<$Res>
    extends _$PurchaseUserModelCopyWithImpl<$Res, _$PurchaseUserModelImpl>
    implements _$$PurchaseUserModelImplCopyWith<$Res> {
  __$$PurchaseUserModelImplCopyWithImpl(_$PurchaseUserModelImpl _value,
      $Res Function(_$PurchaseUserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$PurchaseUserModelImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseUserModelImpl extends _PurchaseUserModel {
  const _$PurchaseUserModelImpl({this.value = 0.0}) : super._();

  factory _$PurchaseUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseUserModelImplFromJson(json);

  @override
  @JsonKey()
  final double value;

  @override
  String toString() {
    return 'PurchaseUserModel(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseUserModelImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseUserModelImplCopyWith<_$PurchaseUserModelImpl> get copyWith =>
      __$$PurchaseUserModelImplCopyWithImpl<_$PurchaseUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseUserModelImplToJson(
      this,
    );
  }
}

abstract class _PurchaseUserModel extends PurchaseUserModel {
  const factory _PurchaseUserModel({final double value}) =
      _$PurchaseUserModelImpl;
  const _PurchaseUserModel._() : super._();

  factory _PurchaseUserModel.fromJson(Map<String, dynamic> json) =
      _$PurchaseUserModelImpl.fromJson;

  @override
  double get value;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseUserModelImplCopyWith<_$PurchaseUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
