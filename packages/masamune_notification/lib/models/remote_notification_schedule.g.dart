// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_notification_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RemoteNotificationScheduleModel _$RemoteNotificationScheduleModelFromJson(
        Map<String, dynamic> json) =>
    _RemoteNotificationScheduleModel(
      command: ModelServerCommandRemoteNotificationSchedule.fromJson(
          json['command'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RemoteNotificationScheduleModelToJson(
        _RemoteNotificationScheduleModel instance) =>
    <String, dynamic>{
      'command': instance.command,
    };
