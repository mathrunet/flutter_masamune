// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_workflow/models/workflow_organization.dart";

part "workflow_usage.m.dart";
part "workflow_usage.g.dart";
part "workflow_usage.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/organization/:organization_id/usage")
abstract class WorkflowUsageModel with _$WorkflowUsageModel {
  /// Value for model.
  const factory WorkflowUsageModel({
    @refParam WorkflowOrganizationModelRef organization,
    @Default(0) double usage,
    String? latestPlan,
    @Default(0) double bucketBalance,
    ModelTimestamp? lastCheckTime,
    String? currentMonth,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowUsageModel;
  const WorkflowUsageModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowUsageModel.fromJson(json);
  /// ```
  factory WorkflowUsageModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowUsageModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowUsageModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowUsageModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowUsageModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowUsageModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowUsageModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowUsageModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowUsageModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowUsageModel.form(WorkflowUsageModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowUsageModel.form(WorkflowUsageModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowUsageModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowUsageModel.
typedef WorkflowUsageModelKeys = _$WorkflowUsageModelKeys;

/// Alias for ModelRef&lt;WorkflowUsageModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowUsageModelDocument) WorkflowUsageModelRef workflow_usage
/// ```
typedef WorkflowUsageModelRef = ModelRef<WorkflowUsageModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowUsageModel&gt;.
///
/// ```dart
/// WorkflowUsageModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowUsageModelRefPath = _$WorkflowUsageModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowUsageModelInitialCollection(
///       "xxx": WorkflowUsageModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowUsageModelInitialCollection
    = _$WorkflowUsageModelInitialCollection;

/// Document class for storing WorkflowUsageModel.
typedef WorkflowUsageModelDocument = _$WorkflowUsageModelDocument;

/// Collection class for storing WorkflowUsageModel.
typedef WorkflowUsageModelCollection = _$WorkflowUsageModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowUsageModel&gt;.
///
/// ```dart
/// WorkflowUsageModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowUsageModelMirrorRefPath = _$WorkflowUsageModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowUsageModelMirrorInitialCollection(
///       "xxx": WorkflowUsageModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowUsageModelMirrorInitialCollection
    = _$WorkflowUsageModelMirrorInitialCollection;

/// Document class for storing WorkflowUsageModel.
typedef WorkflowUsageModelMirrorDocument = _$WorkflowUsageModelMirrorDocument;

/// Collection class for storing WorkflowUsageModel.
typedef WorkflowUsageModelMirrorCollection
    = _$WorkflowUsageModelMirrorCollection;
