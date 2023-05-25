// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StripePaymentModel _$$_StripePaymentModelFromJson(
        Map<String, dynamic> json) =>
    _$_StripePaymentModel(
      paymentId: json['id'] as String,
      type: json['type'] as String,
      expMonth: json['expMonth'] as int? ?? 1,
      expYear: json['expYear'] as int? ?? 2000,
      brand: json['brand'] as String,
      numberLast: json['numberLast'] as String,
      isDefault: json['default'] as bool? ?? false,
    );

Map<String, dynamic> _$$_StripePaymentModelToJson(
        _$_StripePaymentModel instance) =>
    <String, dynamic>{
      'id': instance.paymentId,
      'type': instance.type,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'brand': instance.brand,
      'numberLast': instance.numberLast,
      'default': instance.isDefault,
    };
