// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runtime_model_test.dart';

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
