// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_workflow/models/workflow_organization.dart";

part "workflow_project.m.dart";
part "workflow_project.g.dart";
part "workflow_project.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/project")
abstract class WorkflowProjectModel with _$WorkflowProjectModel {
  /// Value for model.
  const factory WorkflowProjectModel({
    String? name,
    String? description,
    String? concept,
    String? goal,
    String? target,
    ModelLocale? locale,
    Map<String, dynamic>? kpi,
    @refParam WorkflowOrganizationModelRef organization,
    String? icon,
    String? googleAccessToken,
    String? googleRefreshToken,
    String? googleServiceAccount,
    String? githubPersonalAccessToken,
    String? appstoreIssuerId,
    String? appstoreAuthKeyId,
    String? appstoreAuthKey,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowProjectModel;
  const WorkflowProjectModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowProjectModel.fromJson(json);
  /// ```
  factory WorkflowProjectModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowProjectModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowProjectModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowProjectModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowProjectModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowProjectModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowProjectModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowProjectModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowProjectModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowProjectModel.form(WorkflowProjectModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowProjectModel.form(WorkflowProjectModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowProjectModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowProjectModel.
typedef WorkflowProjectModelKeys = _$WorkflowProjectModelKeys;

/// Alias for ModelRef&lt;WorkflowProjectModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowProjectModelDocument) WorkflowProjectModelRef workflow_project
/// ```
typedef WorkflowProjectModelRef = ModelRef<WorkflowProjectModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowProjectModel&gt;.
///
/// ```dart
/// WorkflowProjectModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowProjectModelRefPath = _$WorkflowProjectModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowProjectModelInitialCollection(
///       "xxx": WorkflowProjectModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowProjectModelInitialCollection
    = _$WorkflowProjectModelInitialCollection;

/// Document class for storing WorkflowProjectModel.
typedef WorkflowProjectModelDocument = _$WorkflowProjectModelDocument;

/// Collection class for storing WorkflowProjectModel.
typedef WorkflowProjectModelCollection = _$WorkflowProjectModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowProjectModel&gt;.
///
/// ```dart
/// WorkflowProjectModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowProjectModelMirrorRefPath = _$WorkflowProjectModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowProjectModelMirrorInitialCollection(
///       "xxx": WorkflowProjectModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowProjectModelMirrorInitialCollection
    = _$WorkflowProjectModelMirrorInitialCollection;

/// Document class for storing WorkflowProjectModel.
typedef WorkflowProjectModelMirrorDocument
    = _$WorkflowProjectModelMirrorDocument;

/// Collection class for storing WorkflowProjectModel.
typedef WorkflowProjectModelMirrorCollection
    = _$WorkflowProjectModelMirrorCollection;
