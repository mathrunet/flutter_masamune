// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_workflow/masamune_workflow.dart";
import "package:masamune_workflow/models/workflow_action_command.dart";

part "workflow_task_log.m.dart";
part "workflow_task_log.g.dart";
part "workflow_task_log.freezed.dart";
part "workflow_task_log.extensions.dart";

/// Immutable value.
@freezed
@formValue
@immutable
abstract class WorkflowTaskLogValue with _$WorkflowTaskLogValue {
  /// Immutable value.
  const factory WorkflowTaskLogValue({
    @Default(0) int time,
    String? message,
    @jsonParam WorkflowActionCommandValue? action,
    @Default(TaskLogPhase.start) TaskLogPhase phase,
    @Default({}) Map<String, dynamic> data,
  }) = _WorkflowTaskLogValue;
  const WorkflowTaskLogValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowTaskLogValue.fromJson(json);
  /// ```
  factory WorkflowTaskLogValue.fromJson(Map<String, Object?> json) =>
      _$WorkflowTaskLogValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(WorkflowTaskLogValue.form());     // Get the form controller.
  /// ```
  static const form = _$WorkflowTaskLogValueFormQuery();
}
