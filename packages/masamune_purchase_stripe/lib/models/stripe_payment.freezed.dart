// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StripePaymentModel _$StripePaymentModelFromJson(Map<String, dynamic> json) {
  return _StripePaymentModel.fromJson(json);
}

/// @nodoc
mixin _$StripePaymentModel {
  @JsonKey(name: "id")
  String get paymentId => throw _privateConstructorUsedError;
  @JsonKey(name: "type")
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: "expMonth")
  int get expMonth => throw _privateConstructorUsedError;
  @JsonKey(name: "expYear")
  int get expYear => throw _privateConstructorUsedError;
  @JsonKey(name: "brand")
  String get brand => throw _privateConstructorUsedError;
  @JsonKey(name: "numberLast")
  String get numberLast => throw _privateConstructorUsedError;
  @JsonKey(name: "default")
  bool get isDefault => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StripePaymentModelCopyWith<StripePaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripePaymentModelCopyWith<$Res> {
  factory $StripePaymentModelCopyWith(
          StripePaymentModel value, $Res Function(StripePaymentModel) then) =
      _$StripePaymentModelCopyWithImpl<$Res, StripePaymentModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") String paymentId,
      @JsonKey(name: "type") String type,
      @JsonKey(name: "expMonth") int expMonth,
      @JsonKey(name: "expYear") int expYear,
      @JsonKey(name: "brand") String brand,
      @JsonKey(name: "numberLast") String numberLast,
      @JsonKey(name: "default") bool isDefault});
}

/// @nodoc
class _$StripePaymentModelCopyWithImpl<$Res, $Val extends StripePaymentModel>
    implements $StripePaymentModelCopyWith<$Res> {
  _$StripePaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentId = null,
    Object? type = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? brand = null,
    Object? numberLast = null,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      paymentId: null == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      numberLast: null == numberLast
          ? _value.numberLast
          : numberLast // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StripePaymentModelCopyWith<$Res>
    implements $StripePaymentModelCopyWith<$Res> {
  factory _$$_StripePaymentModelCopyWith(_$_StripePaymentModel value,
          $Res Function(_$_StripePaymentModel) then) =
      __$$_StripePaymentModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") String paymentId,
      @JsonKey(name: "type") String type,
      @JsonKey(name: "expMonth") int expMonth,
      @JsonKey(name: "expYear") int expYear,
      @JsonKey(name: "brand") String brand,
      @JsonKey(name: "numberLast") String numberLast,
      @JsonKey(name: "default") bool isDefault});
}

/// @nodoc
class __$$_StripePaymentModelCopyWithImpl<$Res>
    extends _$StripePaymentModelCopyWithImpl<$Res, _$_StripePaymentModel>
    implements _$$_StripePaymentModelCopyWith<$Res> {
  __$$_StripePaymentModelCopyWithImpl(
      _$_StripePaymentModel _value, $Res Function(_$_StripePaymentModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentId = null,
    Object? type = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? brand = null,
    Object? numberLast = null,
    Object? isDefault = null,
  }) {
    return _then(_$_StripePaymentModel(
      paymentId: null == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      numberLast: null == numberLast
          ? _value.numberLast
          : numberLast // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StripePaymentModel extends _StripePaymentModel {
  const _$_StripePaymentModel(
      {@JsonKey(name: "id") required this.paymentId,
      @JsonKey(name: "type") required this.type,
      @JsonKey(name: "expMonth") this.expMonth = 1,
      @JsonKey(name: "expYear") this.expYear = 2000,
      @JsonKey(name: "brand") required this.brand,
      @JsonKey(name: "numberLast") required this.numberLast,
      @JsonKey(name: "default") this.isDefault = false})
      : super._();

  factory _$_StripePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$$_StripePaymentModelFromJson(json);

  @override
  @JsonKey(name: "id")
  final String paymentId;
  @override
  @JsonKey(name: "type")
  final String type;
  @override
  @JsonKey(name: "expMonth")
  final int expMonth;
  @override
  @JsonKey(name: "expYear")
  final int expYear;
  @override
  @JsonKey(name: "brand")
  final String brand;
  @override
  @JsonKey(name: "numberLast")
  final String numberLast;
  @override
  @JsonKey(name: "default")
  final bool isDefault;

  @override
  String toString() {
    return 'StripePaymentModel(paymentId: $paymentId, type: $type, expMonth: $expMonth, expYear: $expYear, brand: $brand, numberLast: $numberLast, isDefault: $isDefault)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StripePaymentModel &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.expMonth, expMonth) ||
                other.expMonth == expMonth) &&
            (identical(other.expYear, expYear) || other.expYear == expYear) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.numberLast, numberLast) ||
                other.numberLast == numberLast) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, paymentId, type, expMonth,
      expYear, brand, numberLast, isDefault);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StripePaymentModelCopyWith<_$_StripePaymentModel> get copyWith =>
      __$$_StripePaymentModelCopyWithImpl<_$_StripePaymentModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StripePaymentModelToJson(
      this,
    );
  }
}

abstract class _StripePaymentModel extends StripePaymentModel {
  const factory _StripePaymentModel(
      {@JsonKey(name: "id") required final String paymentId,
      @JsonKey(name: "type") required final String type,
      @JsonKey(name: "expMonth") final int expMonth,
      @JsonKey(name: "expYear") final int expYear,
      @JsonKey(name: "brand") required final String brand,
      @JsonKey(name: "numberLast") required final String numberLast,
      @JsonKey(name: "default") final bool isDefault}) = _$_StripePaymentModel;
  const _StripePaymentModel._() : super._();

  factory _StripePaymentModel.fromJson(Map<String, dynamic> json) =
      _$_StripePaymentModel.fromJson;

  @override
  @JsonKey(name: "id")
  String get paymentId;
  @override
  @JsonKey(name: "type")
  String get type;
  @override
  @JsonKey(name: "expMonth")
  int get expMonth;
  @override
  @JsonKey(name: "expYear")
  int get expYear;
  @override
  @JsonKey(name: "brand")
  String get brand;
  @override
  @JsonKey(name: "numberLast")
  String get numberLast;
  @override
  @JsonKey(name: "default")
  bool get isDefault;
  @override
  @JsonKey(ignore: true)
  _$$_StripePaymentModelCopyWith<_$_StripePaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}
