// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StripeUserModel _$$_StripeUserModelFromJson(Map<String, dynamic> json) =>
    _$_StripeUserModel(
      userId: json['user'] as String,
      accountId: json['account'] as String,
      customerId: json['customer'] as String,
      defaultPayment: json['defaultPayment'] as String?,
      capablity: json['capability'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$_StripeUserModelToJson(_$_StripeUserModel instance) =>
    <String, dynamic>{
      'user': instance.userId,
      'account': instance.accountId,
      'customer': instance.customerId,
      'defaultPayment': instance.defaultPayment,
      'capability': instance.capablity,
    };
