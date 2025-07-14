// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_query_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestValue _$TestValueFromJson(Map<String, dynamic> json) => _TestValue(
      name: json['name'] as String,
      en: $enumDecodeNullable(_$TestEnumEnumMap, json['en']),
    );

Map<String, dynamic> _$TestValueToJson(_TestValue instance) =>
    <String, dynamic>{
      'name': instance.name,
      'en': _$TestEnumEnumMap[instance.en],
    };

const _$TestEnumEnumMap = {
  TestEnum.a: 'a',
  TestEnum.b: 'b',
  TestEnum.c: 'c',
};
