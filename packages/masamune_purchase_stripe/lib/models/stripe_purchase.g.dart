// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripePurchaseModel _$StripePurchaseModelFromJson(Map<String, dynamic> json) =>
    _StripePurchaseModel(
      userId: json['user'] as String,
      orderId: json['orderId'] as String,
      purchaseId: json['purchaseId'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
      customerId: json['customer'] as String,
      clientSecret: json['clientSecret'] as String,
      createdTime:
          ModelTimestamp.fromJson(json['createdTime'] as Map<String, dynamic>),
      updatedTime:
          ModelTimestamp.fromJson(json['updatedTime'] as Map<String, dynamic>),
      confirm: json['confirm'] as bool? ?? false,
      verified: json['verify'] as bool? ?? false,
      captured: json['capture'] as bool? ?? false,
      success: json['success'] as bool? ?? false,
      canceled: json['cancel'] as bool? ?? false,
      error: json['error'] as bool? ?? false,
      refund: json['refund'] as bool? ?? false,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      application: json['application'] as String?,
      applicationFeeAmount:
          (json['applicationFeeAmount'] as num?)?.toDouble() ?? 0.0,
      transferAmount: (json['transferAmount'] as num?)?.toDouble() ?? 0.0,
      transferDistination: json['transferDistination'] as String? ?? "",
      currency: json['currency'] as String? ?? "jpy",
      emailFrom: json['emailFrom'] as String?,
      emailTo: json['emailTo'] as String?,
      emailTitle: json['emailTitle'] as String?,
      emailContent: json['emailContent'] as String?,
      locale: json['locale'] as String?,
      cancelAtPeriodEnd: json['cancel_at_period_end'] as bool? ?? false,
    );

Map<String, dynamic> _$StripePurchaseModelToJson(
        _StripePurchaseModel instance) =>
    <String, dynamic>{
      'user': instance.userId,
      'orderId': instance.orderId,
      'purchaseId': instance.purchaseId,
      'paymentMethodId': instance.paymentMethodId,
      'customer': instance.customerId,
      'clientSecret': instance.clientSecret,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
      'confirm': instance.confirm,
      'verify': instance.verified,
      'capture': instance.captured,
      'success': instance.success,
      'cancel': instance.canceled,
      'error': instance.error,
      'refund': instance.refund,
      'amount': instance.amount,
      'application': instance.application,
      'applicationFeeAmount': instance.applicationFeeAmount,
      'transferAmount': instance.transferAmount,
      'transferDistination': instance.transferDistination,
      'currency': instance.currency,
      'emailFrom': instance.emailFrom,
      'emailTo': instance.emailTo,
      'emailTitle': instance.emailTitle,
      'emailContent': instance.emailContent,
      'locale': instance.locale,
      'cancel_at_period_end': instance.cancelAtPeriodEnd,
    };
