// GENERATED CODE - DO NOT MODIFY BY HAND

part of "stripe_user.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StripeUserModelImpl _$$StripeUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StripeUserModelImpl(
      userId: json['user'] as String,
      accountId: json['account'] as String?,
      customerId: json['customer'] as String?,
      defaultPayment: json['defaultPayment'] as String?,
      capablity: json['capability'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$StripeUserModelImplToJson(
        _$StripeUserModelImpl instance) =>
    <String, dynamic>{
      'user': instance.userId,
      'account': instance.accountId,
      'customer': instance.customerId,
      'defaultPayment': instance.defaultPayment,
      'capability': instance.capablity,
    };
