// GENERATED CODE - DO NOT MODIFY BY HAND

part of "searchable_runtime_model_test.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestValueImpl _$$TestValueImplFromJson(Map<String, dynamic> json) =>
    _$TestValueImpl(
      name: json['name'] as String?,
      text: json['text'] as String?,
      ids: (json['ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TestValueImplToJson(_$TestValueImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'ids': instance.ids,
    };
