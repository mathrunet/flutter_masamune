// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_task_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowTaskLogValue _$WorkflowTaskLogValueFromJson(
        Map<String, dynamic> json) =>
    _WorkflowTaskLogValue(
      time: (json['time'] as num?)?.toInt() ?? 0,
      message: json['message'] as String?,
      action: json['action'] == null
          ? null
          : WorkflowActionCommandValue.fromJson(
              json['action'] as Map<String, dynamic>),
      phase: $enumDecodeNullable(_$TaskLogPhaseEnumMap, json['phase']) ??
          TaskLogPhase.start,
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$WorkflowTaskLogValueToJson(
        _WorkflowTaskLogValue instance) =>
    <String, dynamic>{
      'time': instance.time,
      'message': instance.message,
      'action': instance.action,
      'phase': _$TaskLogPhaseEnumMap[instance.phase]!,
      'data': instance.data,
    };

const _$TaskLogPhaseEnumMap = {
  TaskLogPhase.start: 'start',
  TaskLogPhase.end: 'end',
  TaskLogPhase.error: 'error',
  TaskLogPhase.warning: 'warning',
  TaskLogPhase.info: 'info',
};
