// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TestValue _$$_TestValueFromJson(Map<String, dynamic> json) => _$_TestValue(
      name: json['name'] as String?,
      text: json['text'] as String?,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
    );

Map<String, dynamic> _$$_TestValueToJson(_$_TestValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'ids': instance.ids,
    };

_$_UserValue _$$_UserValueFromJson(Map<String, dynamic> json) => _$_UserValue(
      name: json['name'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$_UserValueToJson(_$_UserValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
    };

_$_ShopValue _$$_ShopValueFromJson(Map<String, dynamic> json) => _$_ShopValue(
      name: json['name'] as String?,
      text: json['text'] as String?,
      user: json['user'] == null
          ? null
          : ModelRefBase<UserValue>.fromJson(
              json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ShopValueToJson(_$_ShopValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'user': instance.user,
    };
