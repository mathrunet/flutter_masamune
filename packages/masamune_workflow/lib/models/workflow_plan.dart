// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";

part "workflow_plan.m.dart";
part "workflow_plan.g.dart";
part "workflow_plan.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/plan")
abstract class WorkflowPlanModel with _$WorkflowPlanModel {
  /// Value for model.
  const factory WorkflowPlanModel({
    @Default(0) double limit,
    @Default(0) double burst,
  }) = _WorkflowPlanModel;
  const WorkflowPlanModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowPlanModel.fromJson(json);
  /// ```
  factory WorkflowPlanModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowPlanModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowPlanModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowPlanModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowPlanModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowPlanModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowPlanModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowPlanModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowPlanModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowPlanModel.form(WorkflowPlanModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowPlanModel.form(WorkflowPlanModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowPlanModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowPlanModel.
typedef WorkflowPlanModelKeys = _$WorkflowPlanModelKeys;

/// Alias for ModelRef&lt;WorkflowPlanModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowPlanModelDocument) WorkflowPlanModelRef workflow_plan
/// ```
typedef WorkflowPlanModelRef = ModelRef<WorkflowPlanModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowPlanModel&gt;.
///
/// ```dart
/// WorkflowPlanModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowPlanModelRefPath = _$WorkflowPlanModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowPlanModelInitialCollection(
///       "xxx": WorkflowPlanModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowPlanModelInitialCollection
    = _$WorkflowPlanModelInitialCollection;

/// Document class for storing WorkflowPlanModel.
typedef WorkflowPlanModelDocument = _$WorkflowPlanModelDocument;

/// Collection class for storing WorkflowPlanModel.
typedef WorkflowPlanModelCollection = _$WorkflowPlanModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowPlanModel&gt;.
///
/// ```dart
/// WorkflowPlanModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowPlanModelMirrorRefPath = _$WorkflowPlanModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowPlanModelMirrorInitialCollection(
///       "xxx": WorkflowPlanModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowPlanModelMirrorInitialCollection
    = _$WorkflowPlanModelMirrorInitialCollection;

/// Document class for storing WorkflowPlanModel.
typedef WorkflowPlanModelMirrorDocument = _$WorkflowPlanModelMirrorDocument;

/// Collection class for storing WorkflowPlanModel.
typedef WorkflowPlanModelMirrorCollection = _$WorkflowPlanModelMirrorCollection;
