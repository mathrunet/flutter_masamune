// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PurchaseSubscriptionModel _$$_PurchaseSubscriptionModelFromJson(
        Map<String, dynamic> json) =>
    _$_PurchaseSubscriptionModel(
      expired: json['expired'] as bool? ?? true,
      token: json['token'] as String?,
      platform: json['platform'] as String?,
      productId: json['productId'] as String?,
      purchaseId: json['purchaseId'] as String?,
      packageName: json['packageName'] as String?,
      expiredTime: json['expiredTime'] as int?,
      orderId: json['orderId'] as String?,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$_PurchaseSubscriptionModelToJson(
        _$_PurchaseSubscriptionModel instance) =>
    <String, dynamic>{
      'expired': instance.expired,
      'token': instance.token,
      'platform': instance.platform,
      'productId': instance.productId,
      'purchaseId': instance.purchaseId,
      'packageName': instance.packageName,
      'expiredTime': instance.expiredTime,
      'orderId': instance.orderId,
      'userId': instance.userId,
    };
