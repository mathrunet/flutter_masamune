// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripeUserModel _$StripeUserModelFromJson(Map<String, dynamic> json) =>
    _StripeUserModel(
      userId: json['user'] as String,
      accountId: json['account'] as String?,
      customerId: json['customer'] as String?,
      defaultPayment: json['defaultPayment'] as String?,
      capablity: json['capability'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$StripeUserModelToJson(_StripeUserModel instance) =>
    <String, dynamic>{
      'user': instance.userId,
      'account': instance.accountId,
      'customer': instance.customerId,
      'defaultPayment': instance.defaultPayment,
      'capability': instance.capablity,
    };
