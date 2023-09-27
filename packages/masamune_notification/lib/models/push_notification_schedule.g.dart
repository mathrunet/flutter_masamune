// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PushNotificationScheduleModel _$$_PushNotificationScheduleModelFromJson(
        Map<String, dynamic> json) =>
    _$_PushNotificationScheduleModel(
      time: ModelTimestamp.fromJson(json['time'] as Map<String, dynamic>),
      title: json['title'] as String,
      text: json['text'] as String,
      channelId: json['channelId'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      token: json['token'] as String?,
      topic: json['topic'] as String?,
    );

Map<String, dynamic> _$$_PushNotificationScheduleModelToJson(
        _$_PushNotificationScheduleModel instance) =>
    <String, dynamic>{
      'time': instance.time,
      'title': instance.title,
      'text': instance.text,
      'channelId': instance.channelId,
      'data': instance.data,
      'token': instance.token,
      'topic': instance.topic,
    };
