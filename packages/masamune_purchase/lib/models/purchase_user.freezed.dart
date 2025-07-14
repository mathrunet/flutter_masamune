// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseUserModel {
  double get value;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseUserModelCopyWith<PurchaseUserModel> get copyWith =>
      _$PurchaseUserModelCopyWithImpl<PurchaseUserModel>(
          this as PurchaseUserModel, _$identity);

  /// Serializes this PurchaseUserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseUserModel &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'PurchaseUserModel(value: $value)';
  }
}

/// @nodoc
abstract mixin class $PurchaseUserModelCopyWith<$Res> {
  factory $PurchaseUserModelCopyWith(
          PurchaseUserModel value, $Res Function(PurchaseUserModel) _then) =
      _$PurchaseUserModelCopyWithImpl;
  @useResult
  $Res call({double value});
}

/// @nodoc
class _$PurchaseUserModelCopyWithImpl<$Res>
    implements $PurchaseUserModelCopyWith<$Res> {
  _$PurchaseUserModelCopyWithImpl(this._self, this._then);

  final PurchaseUserModel _self;
  final $Res Function(PurchaseUserModel) _then;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_self.copyWith(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseUserModel extends PurchaseUserModel {
  const _PurchaseUserModel({this.value = 0.0}) : super._();
  factory _PurchaseUserModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseUserModelFromJson(json);

  @override
  @JsonKey()
  final double value;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseUserModelCopyWith<_PurchaseUserModel> get copyWith =>
      __$PurchaseUserModelCopyWithImpl<_PurchaseUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseUserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseUserModel &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'PurchaseUserModel(value: $value)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseUserModelCopyWith<$Res>
    implements $PurchaseUserModelCopyWith<$Res> {
  factory _$PurchaseUserModelCopyWith(
          _PurchaseUserModel value, $Res Function(_PurchaseUserModel) _then) =
      __$PurchaseUserModelCopyWithImpl;
  @override
  @useResult
  $Res call({double value});
}

/// @nodoc
class __$PurchaseUserModelCopyWithImpl<$Res>
    implements _$PurchaseUserModelCopyWith<$Res> {
  __$PurchaseUserModelCopyWithImpl(this._self, this._then);

  final _PurchaseUserModel _self;
  final $Res Function(_PurchaseUserModel) _then;

  /// Create a copy of PurchaseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(_PurchaseUserModel(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
