// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestValue _$TestValueFromJson(Map<String, dynamic> json) => _TestValue(
      name: json['name'] as String?,
      text: json['text'] as String?,
      ids: (json['ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TestValueToJson(_TestValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'ids': instance.ids,
    };

_UserValue _$UserValueFromJson(Map<String, dynamic> json) => _UserValue(
      name: json['name'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$UserValueToJson(_UserValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
    };

_ShopValue _$ShopValueFromJson(Map<String, dynamic> json) => _ShopValue(
      name: json['name'] as String?,
      text: json['text'] as String?,
      user: json['user'] == null
          ? null
          : ModelRefBase<UserValue>.fromJson(
              json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopValueToJson(_ShopValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'user': instance.user,
    };
