// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_action_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowActionCommandValue _$WorkflowActionCommandValueFromJson(
        Map<String, dynamic> json) =>
    _WorkflowActionCommandValue(
      command: json['command'] as String,
      index: (json['index'] as num).toInt(),
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$WorkflowActionCommandValueToJson(
        _WorkflowActionCommandValue instance) =>
    <String, dynamic>{
      'command': instance.command,
      'index': instance.index,
      'data': instance.data,
    };
