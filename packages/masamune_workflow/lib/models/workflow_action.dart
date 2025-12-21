// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_workflow/masamune_workflow.dart";
import "package:masamune_workflow/models/workflow_action_command.dart";
import "package:masamune_workflow/models/workflow_organization.dart";
import "package:masamune_workflow/models/workflow_project.dart";
import "package:masamune_workflow/models/workflow_task.dart";
import "package:masamune_workflow/models/workflow_task_log.dart";
import "package:masamune_workflow/models/workflow_workflow.dart";

part "workflow_action.m.dart";
part "workflow_action.g.dart";
part "workflow_action.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/action")
abstract class WorkflowActionModel with _$WorkflowActionModel {
  /// Value for model.
  const factory WorkflowActionModel({
    @jsonParam required WorkflowActionCommandValue command,
    @refParam WorkflowTaskModelRef task,
    @refParam WorkflowWorkflowModelRef workflow,
    @refParam WorkflowOrganizationModelRef organization,
    @refParam WorkflowProjectModelRef project,
    @Default(WorkflowTaskStatus.waiting) WorkflowTaskStatus status,
    ModelLocale? locale,
    Map<String, dynamic>? error,
    String? prompt,
    @jsonParam @Default([]) List<WorkflowTaskLogValue> log,
    Map<String, dynamic>? materials,
    Map<String, dynamic>? results,
    Map<String, dynamic>? assets,
    @Default(0) double usage,
    String? search,
    String? token,
    ModelTimestamp? tokenExpiredTime,
    ModelTimestamp? startTime,
    ModelTimestamp? finishedTime,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowActionModel;
  const WorkflowActionModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowActionModel.fromJson(json);
  /// ```
  factory WorkflowActionModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowActionModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowActionModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowActionModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowActionModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowActionModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowActionModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowActionModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowActionModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowActionModel.form(WorkflowActionModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowActionModel.form(WorkflowActionModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowActionModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowActionModel.
typedef WorkflowActionModelKeys = _$WorkflowActionModelKeys;

/// Alias for ModelRef&lt;WorkflowActionModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowActionModelDocument) WorkflowActionModelRef workflow_action
/// ```
typedef WorkflowActionModelRef = ModelRef<WorkflowActionModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowActionModel&gt;.
///
/// ```dart
/// WorkflowActionModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowActionModelRefPath = _$WorkflowActionModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowActionModelInitialCollection(
///       "xxx": WorkflowActionModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowActionModelInitialCollection
    = _$WorkflowActionModelInitialCollection;

/// Document class for storing WorkflowActionModel.
typedef WorkflowActionModelDocument = _$WorkflowActionModelDocument;

/// Collection class for storing WorkflowActionModel.
typedef WorkflowActionModelCollection = _$WorkflowActionModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowActionModel&gt;.
///
/// ```dart
/// WorkflowActionModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowActionModelMirrorRefPath = _$WorkflowActionModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowActionModelMirrorInitialCollection(
///       "xxx": WorkflowActionModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowActionModelMirrorInitialCollection
    = _$WorkflowActionModelMirrorInitialCollection;

/// Document class for storing WorkflowActionModel.
typedef WorkflowActionModelMirrorDocument = _$WorkflowActionModelMirrorDocument;

/// Collection class for storing WorkflowActionModel.
typedef WorkflowActionModelMirrorCollection
    = _$WorkflowActionModelMirrorCollection;
