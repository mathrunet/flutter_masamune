// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_field_value_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestValueImpl _$$TestValueImplFromJson(Map<String, dynamic> json) =>
    _$TestValueImpl(
      dateTime: json['dateTime'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(json['dateTime'] as Map<String, dynamic>),
      date: json['date'] == null
          ? const ModelDate()
          : ModelDate.fromJson(json['date'] as Map<String, dynamic>),
      time: json['time'] == null
          ? const ModelTime()
          : ModelTime.fromJson(json['time'] as Map<String, dynamic>),
      timeRange: json['timeRange'] == null
          ? const ModelTimeRange.fromModelTime(
              start: ModelTime.time(10, 0), end: ModelTime.time(11, 0))
          : ModelTimeRange.fromJson(json['timeRange'] as Map<String, dynamic>),
      timestampRange: json['timestampRange'] == null
          ? const ModelTimestampRange.fromModelTimestamp(
              start: ModelTimestamp.dateTime(2022, 1, 1),
              end: ModelTimestamp.dateTime(2022, 1, 2))
          : ModelTimestampRange.fromJson(
              json['timestampRange'] as Map<String, dynamic>),
      dateRange: json['dateRange'] == null
          ? const ModelDateRange.fromModelDate(
              start: ModelDate.date(2022, 1, 1),
              end: ModelDate.date(2022, 1, 2))
          : ModelDateRange.fromJson(json['dateRange'] as Map<String, dynamic>),
      counter: json['counter'] == null
          ? const ModelCounter(0)
          : ModelCounter.fromJson(json['counter'] as Map<String, dynamic>),
      uri: json['uri'] == null
          ? const ModelUri()
          : ModelUri.fromJson(json['uri'] as Map<String, dynamic>),
      image: json['image'] == null
          ? const ModelImageUri()
          : ModelImageUri.fromJson(json['image'] as Map<String, dynamic>),
      video: json['video'] == null
          ? const ModelVideoUri()
          : ModelVideoUri.fromJson(json['video'] as Map<String, dynamic>),
      geo: json['geo'] == null
          ? const ModelGeoValue()
          : ModelGeoValue.fromJson(json['geo'] as Map<String, dynamic>),
      search: json['search'] == null
          ? const ModelSearch([])
          : ModelSearch.fromJson(json['search'] as Map<String, dynamic>),
      locale: json['locale'] == null
          ? const ModelLocale()
          : ModelLocale.fromJson(json['locale'] as Map<String, dynamic>),
      localized: json['localized'] == null
          ? const ModelLocalizedValue()
          : ModelLocalizedValue.fromJson(
              json['localized'] as Map<String, dynamic>),
      videoMap: (json['videoMap'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, ModelVideoUri.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      imageList: (json['imageList'] as List<dynamic>?)
              ?.map((e) => ModelImageUri.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      localizedMap: (json['localizedMap'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ModelLocalizedValue.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      localizedList: (json['localizedList'] as List<dynamic>?)
              ?.map((e) =>
                  ModelLocalizedValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TestValueImplToJson(_$TestValueImpl instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime,
      'date': instance.date,
      'time': instance.time,
      'timeRange': instance.timeRange,
      'timestampRange': instance.timestampRange,
      'dateRange': instance.dateRange,
      'counter': instance.counter,
      'uri': instance.uri,
      'image': instance.image,
      'video': instance.video,
      'geo': instance.geo,
      'search': instance.search,
      'locale': instance.locale,
      'localized': instance.localized,
      'videoMap': instance.videoMap,
      'imageList': instance.imageList,
      'localizedMap': instance.localizedMap,
      'localizedList': instance.localizedList,
    };
