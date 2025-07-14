// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripeUserModel {
  @JsonKey(name: "user")
  String get userId;
  @JsonKey(name: "account")
  String? get accountId;
  @JsonKey(name: "customer")
  String? get customerId;
  @JsonKey(name: "defaultPayment")
  String? get defaultPayment;
  @JsonKey(name: "capability")
  DynamicMap get capablity;

  /// Create a copy of StripeUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StripeUserModelCopyWith<StripeUserModel> get copyWith =>
      _$StripeUserModelCopyWithImpl<StripeUserModel>(
          this as StripeUserModel, _$identity);

  /// Serializes this StripeUserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StripeUserModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.defaultPayment, defaultPayment) ||
                other.defaultPayment == defaultPayment) &&
            const DeepCollectionEquality().equals(other.capablity, capablity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, accountId, customerId,
      defaultPayment, const DeepCollectionEquality().hash(capablity));

  @override
  String toString() {
    return 'StripeUserModel(userId: $userId, accountId: $accountId, customerId: $customerId, defaultPayment: $defaultPayment, capablity: $capablity)';
  }
}

/// @nodoc
abstract mixin class $StripeUserModelCopyWith<$Res> {
  factory $StripeUserModelCopyWith(
          StripeUserModel value, $Res Function(StripeUserModel) _then) =
      _$StripeUserModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "user") String userId,
      @JsonKey(name: "account") String? accountId,
      @JsonKey(name: "customer") String? customerId,
      @JsonKey(name: "defaultPayment") String? defaultPayment,
      @JsonKey(name: "capability") Map<String, dynamic> capablity});
}

/// @nodoc
class _$StripeUserModelCopyWithImpl<$Res>
    implements $StripeUserModelCopyWith<$Res> {
  _$StripeUserModelCopyWithImpl(this._self, this._then);

  final StripeUserModel _self;
  final $Res Function(StripeUserModel) _then;

  /// Create a copy of StripeUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? accountId = freezed,
    Object? customerId = freezed,
    Object? defaultPayment = freezed,
    Object? capablity = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: freezed == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultPayment: freezed == defaultPayment
          ? _self.defaultPayment
          : defaultPayment // ignore: cast_nullable_to_non_nullable
              as String?,
      capablity: null == capablity
          ? _self.capablity!
          : capablity // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _StripeUserModel extends StripeUserModel {
  const _StripeUserModel(
      {@JsonKey(name: "user") required this.userId,
      @JsonKey(name: "account") this.accountId,
      @JsonKey(name: "customer") this.customerId,
      @JsonKey(name: "defaultPayment") this.defaultPayment,
      @JsonKey(name: "capability")
      final Map<String, dynamic> capablity = const {}})
      : _capablity = capablity,
        super._();
  factory _StripeUserModel.fromJson(Map<String, dynamic> json) =>
      _$StripeUserModelFromJson(json);

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

  /// Create a copy of StripeUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StripeUserModelCopyWith<_StripeUserModel> get copyWith =>
      __$StripeUserModelCopyWithImpl<_StripeUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StripeUserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StripeUserModel &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, accountId, customerId,
      defaultPayment, const DeepCollectionEquality().hash(_capablity));

  @override
  String toString() {
    return 'StripeUserModel(userId: $userId, accountId: $accountId, customerId: $customerId, defaultPayment: $defaultPayment, capablity: $capablity)';
  }
}

/// @nodoc
abstract mixin class _$StripeUserModelCopyWith<$Res>
    implements $StripeUserModelCopyWith<$Res> {
  factory _$StripeUserModelCopyWith(
          _StripeUserModel value, $Res Function(_StripeUserModel) _then) =
      __$StripeUserModelCopyWithImpl;
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
class __$StripeUserModelCopyWithImpl<$Res>
    implements _$StripeUserModelCopyWith<$Res> {
  __$StripeUserModelCopyWithImpl(this._self, this._then);

  final _StripeUserModel _self;
  final $Res Function(_StripeUserModel) _then;

  /// Create a copy of StripeUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? accountId = freezed,
    Object? customerId = freezed,
    Object? defaultPayment = freezed,
    Object? capablity = null,
  }) {
    return _then(_StripeUserModel(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: freezed == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultPayment: freezed == defaultPayment
          ? _self.defaultPayment
          : defaultPayment // ignore: cast_nullable_to_non_nullable
              as String?,
      capablity: null == capablity
          ? _self._capablity
          : capablity // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
