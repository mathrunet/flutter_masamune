// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vector_runtime_model_test.dart';

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
