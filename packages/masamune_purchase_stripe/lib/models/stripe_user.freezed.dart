// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StripeUserModel _$StripeUserModelFromJson(Map<String, dynamic> json) {
  return _StripeUserModel.fromJson(json);
}

/// @nodoc
mixin _$StripeUserModel {
  @JsonKey(name: "user")
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: "account")
  String? get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: "customer")
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: "defaultPayment")
  String? get defaultPayment => throw _privateConstructorUsedError;
  @JsonKey(name: "capability")
  Map<String, dynamic> get capablity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StripeUserModelCopyWith<StripeUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripeUserModelCopyWith<$Res> {
  factory $StripeUserModelCopyWith(
          StripeUserModel value, $Res Function(StripeUserModel) then) =
      _$StripeUserModelCopyWithImpl<$Res, StripeUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "user") String userId,
      @JsonKey(name: "account") String? accountId,
      @JsonKey(name: "customer") String? customerId,
      @JsonKey(name: "defaultPayment") String? defaultPayment,
      @JsonKey(name: "capability") Map<String, dynamic> capablity});
}

/// @nodoc
class _$StripeUserModelCopyWithImpl<$Res, $Val extends StripeUserModel>
    implements $StripeUserModelCopyWith<$Res> {
  _$StripeUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? accountId = freezed,
    Object? customerId = freezed,
    Object? defaultPayment = freezed,
    Object? capablity = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultPayment: freezed == defaultPayment
          ? _value.defaultPayment
          : defaultPayment // ignore: cast_nullable_to_non_nullable
              as String?,
      capablity: null == capablity
          ? _value.capablity
          : capablity // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StripeUserModelCopyWith<$Res>
    implements $StripeUserModelCopyWith<$Res> {
  factory _$$_StripeUserModelCopyWith(
          _$_StripeUserModel value, $Res Function(_$_StripeUserModel) then) =
      __$$_StripeUserModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "user") String userId,
      @JsonKey(name: "account") String? accountId,
      @JsonKey(name: "customer") String? customerId,
      @JsonKey(name: "defaultPayment") String? defaultPayment,
      @JsonKey(name: "capability") Map<String, dynamic> capablity});
}

/// @nodoc
class __$$_StripeUserModelCopyWithImpl<$Res>
    extends _$StripeUserModelCopyWithImpl<$Res, _$_StripeUserModel>
    implements _$$_StripeUserModelCopyWith<$Res> {
  __$$_StripeUserModelCopyWithImpl(
      _$_StripeUserModel _value, $Res Function(_$_StripeUserModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? accountId = freezed,
    Object? customerId = freezed,
    Object? defaultPayment = freezed,
    Object? capablity = null,
  }) {
    return _then(_$_StripeUserModel(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultPayment: freezed == defaultPayment
          ? _value.defaultPayment
          : defaultPayment // ignore: cast_nullable_to_non_nullable
              as String?,
      capablity: null == capablity
          ? _value._capablity
          : capablity // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StripeUserModel extends _StripeUserModel {
  const _$_StripeUserModel(
      {@JsonKey(name: "user") required this.userId,
      @JsonKey(name: "account") this.accountId,
      @JsonKey(name: "customer") this.customerId,
      @JsonKey(name: "defaultPayment") this.defaultPayment,
      @JsonKey(name: "capability")
      final Map<String, dynamic> capablity = const {}})
      : _capablity = capablity,
        super._();

  factory _$_StripeUserModel.fromJson(Map<String, dynamic> json) =>
      _$$_StripeUserModelFromJson(json);

  @override
  @JsonKey(name: "user")
  final String userId;
  @override
  @JsonKey(name: "account")
  final String? accountId;
  @override
  @JsonKey(name: "customer")
  final String? customerId;
  @override
  @JsonKey(name: "defaultPayment")
  final String? defaultPayment;
  final Map<String, dynamic> _capablity;
  @override
  @JsonKey(name: "capability")
  Map<String, dynamic> get capablity {
    if (_capablity is EqualUnmodifiableMapView) return _capablity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_capablity);
  }

  @override
  String toString() {
    return 'StripeUserModel(userId: $userId, accountId: $accountId, customerId: $customerId, defaultPayment: $defaultPayment, capablity: $capablity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StripeUserModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.defaultPayment, defaultPayment) ||
                other.defaultPayment == defaultPayment) &&
            const DeepCollectionEquality()
                .equals(other._capablity, _capablity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, accountId, customerId,
      defaultPayment, const DeepCollectionEquality().hash(_capablity));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StripeUserModelCopyWith<_$_StripeUserModel> get copyWith =>
      __$$_StripeUserModelCopyWithImpl<_$_StripeUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StripeUserModelToJson(
      this,
    );
  }
}

abstract class _StripeUserModel extends StripeUserModel {
  const factory _StripeUserModel(
          {@JsonKey(name: "user") required final String userId,
          @JsonKey(name: "account") final String? accountId,
          @JsonKey(name: "customer") final String? customerId,
          @JsonKey(name: "defaultPayment") final String? defaultPayment,
          @JsonKey(name: "capability") final Map<String, dynamic> capablity}) =
      _$_StripeUserModel;
  const _StripeUserModel._() : super._();

  factory _StripeUserModel.fromJson(Map<String, dynamic> json) =
      _$_StripeUserModel.fromJson;

  @override
  @JsonKey(name: "user")
  String get userId;
  @override
  @JsonKey(name: "account")
  String? get accountId;
  @override
  @JsonKey(name: "customer")
  String? get customerId;
  @override
  @JsonKey(name: "defaultPayment")
  String? get defaultPayment;
  @override
  @JsonKey(name: "capability")
  Map<String, dynamic> get capablity;
  @override
  @JsonKey(ignore: true)
  _$$_StripeUserModelCopyWith<_$_StripeUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}
