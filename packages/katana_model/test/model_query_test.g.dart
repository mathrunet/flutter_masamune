// GENERATED CODE - DO NOT MODIFY BY HAND

part of "model_query_test.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestValueImpl _$$TestValueImplFromJson(Map<String, dynamic> json) =>
    _$TestValueImpl(
      name: json['name'] as String,
      en: $enumDecodeNullable(_$TestEnumEnumMap, json['en']),
    );

Map<String, dynamic> _$$TestValueImplToJson(_$TestValueImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'en': _$TestEnumEnumMap[instance.en],
    };

const _$TestEnumEnumMap = {
  TestEnum.a: 'a',
  TestEnum.b: 'b',
  TestEnum.c: 'c',
};
