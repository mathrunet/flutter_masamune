// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_source_model_adapter_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TestValue _$$_TestValueFromJson(Map<String, dynamic> json) => _$_TestValue(
      id: json['id'] as String,
      name: json['name'] as String?,
      age: json['age'] as int?,
      percent: (json['percent'] as num?)?.toDouble(),
      flag: json['flag'] as bool? ?? false,
    );

Map<String, dynamic> _$$_TestValueToJson(_$_TestValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'percent': instance.percent,
      'flag': instance.flag,
    };
