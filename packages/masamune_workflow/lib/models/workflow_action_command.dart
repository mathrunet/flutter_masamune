// ignore: unused_import, unnecessary_import

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import

part "workflow_action_command.m.dart";
part "workflow_action_command.g.dart";
part "workflow_action_command.freezed.dart";

/// Immutable value for workflow action command.
///
/// ワークフローアクションコマンドのイミュータブルな値。
@freezed
@formValue
@immutable
abstract class WorkflowActionCommandValue with _$WorkflowActionCommandValue {
  /// Immutable value for workflow action command.
  ///
  /// ワークフローアクションコマンドのイミュータブルな値。
  const factory WorkflowActionCommandValue({
    required String command,
    required int index,
    @Default({}) Map<String, dynamic> data,
  }) = _WorkflowActionCommandValue;
  const WorkflowActionCommandValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowActionCommandValue.fromJson(json);
  /// ```
  factory WorkflowActionCommandValue.fromJson(Map<String, Object?> json) =>
      _$WorkflowActionCommandValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(WorkflowActionCommandValue.form());     // Get the form controller.
  /// ```
  static const form = _$WorkflowActionCommandValueFormQuery();
}
