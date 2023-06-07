// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_field_value_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TestValue _$$_TestValueFromJson(Map<String, dynamic> json) => _$_TestValue(
      time: json['time'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(json['time'] as Map<String, dynamic>),
      counter: json['counter'] == null
          ? const ModelCounter(0)
          : ModelCounter.fromJson(json['counter'] as Map<String, dynamic>),
      uri: json['uri'] == null
          ? const ModelUri()
          : ModelUri.fromJson(json['uri'] as Map<String, dynamic>),
      geo: json['geo'] == null
          ? const ModelGeoValue()
          : ModelGeoValue.fromJson(json['geo'] as Map<String, dynamic>),
      search: json['search'] == null
          ? const ModelSearch([])
          : ModelSearch.fromJson(json['search'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_TestValueToJson(_$_TestValue instance) =>
    <String, dynamic>{
      'time': instance.time,
      'counter': instance.counter,
      'uri': instance.uri,
      'geo': instance.geo,
      'search': instance.search,
    };
