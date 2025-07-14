// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripePaymentModel _$StripePaymentModelFromJson(Map<String, dynamic> json) =>
    _StripePaymentModel(
      paymentId: json['id'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String,
      numberLast: json['numberLast'] as String,
      expMonth: (json['expMonth'] as num?)?.toInt() ?? 1,
      expYear: (json['expYear'] as num?)?.toInt() ?? 2000,
      isDefault: json['default'] as bool? ?? false,
    );

Map<String, dynamic> _$StripePaymentModelToJson(_StripePaymentModel instance) =>
    <String, dynamic>{
      'id': instance.paymentId,
      'type': instance.type,
      'brand': instance.brand,
      'numberLast': instance.numberLast,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'default': instance.isDefault,
    };
