// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseSubscriptionModel _$PurchaseSubscriptionModelFromJson(
        Map<String, dynamic> json) =>
    _PurchaseSubscriptionModel(
      userId: json['userId'] as String,
      expired: json['expired'] as bool? ?? true,
      token: json['token'] as String?,
      platform: json['platform'] as String?,
      productId: json['productId'] as String?,
      purchaseId: json['purchaseId'] as String?,
      packageName: json['packageName'] as String?,
      expiredTime: (json['expiredTime'] as num?)?.toInt(),
      orderId: json['orderId'] as String?,
    );

Map<String, dynamic> _$PurchaseSubscriptionModelToJson(
        _PurchaseSubscriptionModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'expired': instance.expired,
      'token': instance.token,
      'platform': instance.platform,
      'productId': instance.productId,
      'purchaseId': instance.purchaseId,
      'packageName': instance.packageName,
      'expiredTime': instance.expiredTime,
      'orderId': instance.orderId,
    };
