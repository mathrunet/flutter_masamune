// GENERATED CODE - DO NOT MODIFY BY HAND

part of "csv_source_model_adapter_test.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestValueImpl _$$TestValueImplFromJson(Map<String, dynamic> json) =>
    _$TestValueImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      age: (json['age'] as num?)?.toInt(),
      percent: (json['percent'] as num?)?.toDouble(),
      flag: json['flag'] as bool? ?? false,
    );

Map<String, dynamic> _$$TestValueImplToJson(_$TestValueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'percent': instance.percent,
      'flag': instance.flag,
    };
