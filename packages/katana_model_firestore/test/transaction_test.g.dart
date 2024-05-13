// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestValueImpl _$$TestValueImplFromJson(Map<String, dynamic> json) =>
    _$TestValueImpl(
      name: json['name'] as String?,
      text: json['text'] as String?,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
    );

Map<String, dynamic> _$$TestValueImplToJson(_$TestValueImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'ids': instance.ids,
    };

_$UserValueImpl _$$UserValueImplFromJson(Map<String, dynamic> json) =>
    _$UserValueImpl(
      name: json['name'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$UserValueImplToJson(_$UserValueImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
    };

_$ShopValueImpl _$$ShopValueImplFromJson(Map<String, dynamic> json) =>
    _$ShopValueImpl(
      name: json['name'] as String?,
      text: json['text'] as String?,
      user: json['user'] == null
          ? null
          : ModelRefBase<UserValue>.fromJson(
              json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ShopValueImplToJson(_$ShopValueImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'user': instance.user,
    };
