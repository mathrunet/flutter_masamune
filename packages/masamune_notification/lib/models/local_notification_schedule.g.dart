// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocalNotificationScheduleModel _$LocalNotificationScheduleModelFromJson(
        Map<String, dynamic> json) =>
    _LocalNotificationScheduleModel(
      id: (json['id'] as num?)?.toInt(),
      time: json['time'] == null
          ? const ModelTimestamp()
          : ModelTimestamp.fromJson(json['time'] as Map<String, dynamic>),
      repeat: $enumDecodeNullable(
              _$LocalNotificationRepeatSettingsEnumMap, json['repeat']) ??
          LocalNotificationRepeatSettings.none,
      title: json['title'] as String? ?? "",
      text: json['text'] as String? ?? "",
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$LocalNotificationScheduleModelToJson(
        _LocalNotificationScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'repeat': _$LocalNotificationRepeatSettingsEnumMap[instance.repeat]!,
      'title': instance.title,
      'text': instance.text,
      'data': instance.data,
    };

const _$LocalNotificationRepeatSettingsEnumMap = {
  LocalNotificationRepeatSettings.none: 'none',
  LocalNotificationRepeatSettings.daily: 'daily',
  LocalNotificationRepeatSettings.weekly: 'weekly',
  LocalNotificationRepeatSettings.monthly: 'monthly',
  LocalNotificationRepeatSettings.yearly: 'yearly',
};
