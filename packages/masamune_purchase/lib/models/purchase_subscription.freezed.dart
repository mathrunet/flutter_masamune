// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseSubscriptionModel {
  String get userId;
  bool get expired;
  String? get token;
  String? get platform;
  String? get productId;
  String? get purchaseId;
  String? get packageName;
  int? get expiredTime;
  String? get orderId;

  /// Create a copy of PurchaseSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseSubscriptionModelCopyWith<PurchaseSubscriptionModel> get copyWith =>
      _$PurchaseSubscriptionModelCopyWithImpl<PurchaseSubscriptionModel>(
          this as PurchaseSubscriptionModel, _$identity);

  /// Serializes this PurchaseSubscriptionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseSubscriptionModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.expired, expired) || other.expired == expired) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.expiredTime, expiredTime) ||
                other.expiredTime == expiredTime) &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, expired, token, platform,
      productId, purchaseId, packageName, expiredTime, orderId);

  @override
  String toString() {
    return 'PurchaseSubscriptionModel(userId: $userId, expired: $expired, token: $token, platform: $platform, productId: $productId, purchaseId: $purchaseId, packageName: $packageName, expiredTime: $expiredTime, orderId: $orderId)';
  }
}

/// @nodoc
abstract mixin class $PurchaseSubscriptionModelCopyWith<$Res> {
  factory $PurchaseSubscriptionModelCopyWith(PurchaseSubscriptionModel value,
          $Res Function(PurchaseSubscriptionModel) _then) =
      _$PurchaseSubscriptionModelCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      bool expired,
      String? token,
      String? platform,
      String? productId,
      String? purchaseId,
      String? packageName,
      int? expiredTime,
      String? orderId});
}

/// @nodoc
class _$PurchaseSubscriptionModelCopyWithImpl<$Res>
    implements $PurchaseSubscriptionModelCopyWith<$Res> {
  _$PurchaseSubscriptionModelCopyWithImpl(this._self, this._then);

  final PurchaseSubscriptionModel _self;
  final $Res Function(PurchaseSubscriptionModel) _then;

  /// Create a copy of PurchaseSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? expired = null,
    Object? token = freezed,
    Object? platform = freezed,
    Object? productId = freezed,
    Object? purchaseId = freezed,
    Object? packageName = freezed,
    Object? expiredTime = freezed,
    Object? orderId = freezed,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      expired: null == expired
          ? _self.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as bool,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: freezed == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseId: freezed == purchaseId
          ? _self.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      packageName: freezed == packageName
          ? _self.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String?,
      expiredTime: freezed == expiredTime
          ? _self.expiredTime
          : expiredTime // ignore: cast_nullable_to_non_nullable
              as int?,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseSubscriptionModel extends PurchaseSubscriptionModel {
  const _PurchaseSubscriptionModel(
      {required this.userId,
      this.expired = true,
      this.token,
      this.platform,
      this.productId,
      this.purchaseId,
      this.packageName,
      this.expiredTime,
      this.orderId})
      : super._();
  factory _PurchaseSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSubscriptionModelFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool expired;
  @override
  final String? token;
  @override
  final String? platform;
  @override
  final String? productId;
  @override
  final String? purchaseId;
  @override
  final String? packageName;
  @override
  final int? expiredTime;
  @override
  final String? orderId;

  /// Create a copy of PurchaseSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseSubscriptionModelCopyWith<_PurchaseSubscriptionModel>
      get copyWith =>
          __$PurchaseSubscriptionModelCopyWithImpl<_PurchaseSubscriptionModel>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseSubscriptionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseSubscriptionModel &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.expired, expired) || other.expired == expired) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.expiredTime, expiredTime) ||
                other.expiredTime == expiredTime) &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, expired, token, platform,
      productId, purchaseId, packageName, expiredTime, orderId);

  @override
  String toString() {
    return 'PurchaseSubscriptionModel(userId: $userId, expired: $expired, token: $token, platform: $platform, productId: $productId, purchaseId: $purchaseId, packageName: $packageName, expiredTime: $expiredTime, orderId: $orderId)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseSubscriptionModelCopyWith<$Res>
    implements $PurchaseSubscriptionModelCopyWith<$Res> {
  factory _$PurchaseSubscriptionModelCopyWith(_PurchaseSubscriptionModel value,
          $Res Function(_PurchaseSubscriptionModel) _then) =
      __$PurchaseSubscriptionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      bool expired,
      String? token,
      String? platform,
      String? productId,
      String? purchaseId,
      String? packageName,
      int? expiredTime,
      String? orderId});
}

/// @nodoc
class __$PurchaseSubscriptionModelCopyWithImpl<$Res>
    implements _$PurchaseSubscriptionModelCopyWith<$Res> {
  __$PurchaseSubscriptionModelCopyWithImpl(this._self, this._then);

  final _PurchaseSubscriptionModel _self;
  final $Res Function(_PurchaseSubscriptionModel) _then;

  /// Create a copy of PurchaseSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? expired = null,
    Object? token = freezed,
    Object? platform = freezed,
    Object? productId = freezed,
    Object? purchaseId = freezed,
    Object? packageName = freezed,
    Object? expiredTime = freezed,
    Object? orderId = freezed,
  }) {
    return _then(_PurchaseSubscriptionModel(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      expired: null == expired
          ? _self.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as bool,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: freezed == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseId: freezed == purchaseId
          ? _self.purchaseId
          : purchaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      packageName: freezed == packageName
          ? _self.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String?,
      expiredTime: freezed == expiredTime
          ? _self.expiredTime
          : expiredTime // ignore: cast_nullable_to_non_nullable
              as int?,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
