// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_workflow/models/workflow_organization.dart";
import "package:masamune_workflow/models/workflow_project.dart";

part "workflow_page.m.dart";
part "workflow_page.g.dart";
part "workflow_page.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/page")
abstract class WorkflowPageModel with _$WorkflowPageModel {
  /// Value for model.
  const factory WorkflowPageModel({
    @refParam WorkflowOrganizationModelRef organization,
    @refParam WorkflowProjectModelRef project,
    String? content,
    String? path,
    ModelLocale? locale,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowPageModel;
  const WorkflowPageModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowPageModel.fromJson(json);
  /// ```
  factory WorkflowPageModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowPageModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowPageModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowPageModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowPageModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowPageModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowPageModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowPageModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowPageModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowPageModel.form(WorkflowPageModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowPageModel.form(WorkflowPageModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowPageModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowPageModel.
typedef WorkflowPageModelKeys = _$WorkflowPageModelKeys;

/// Alias for ModelRef&lt;WorkflowPageModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowPageModelDocument) WorkflowPageModelRef workflow_page
/// ```
typedef WorkflowPageModelRef = ModelRef<WorkflowPageModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowPageModel&gt;.
///
/// ```dart
/// WorkflowPageModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowPageModelRefPath = _$WorkflowPageModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowPageModelInitialCollection(
///       "xxx": WorkflowPageModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowPageModelInitialCollection
    = _$WorkflowPageModelInitialCollection;

/// Document class for storing WorkflowPageModel.
typedef WorkflowPageModelDocument = _$WorkflowPageModelDocument;

/// Collection class for storing WorkflowPageModel.
typedef WorkflowPageModelCollection = _$WorkflowPageModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowPageModel&gt;.
///
/// ```dart
/// WorkflowPageModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowPageModelMirrorRefPath = _$WorkflowPageModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowPageModelMirrorInitialCollection(
///       "xxx": WorkflowPageModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowPageModelMirrorInitialCollection
    = _$WorkflowPageModelMirrorInitialCollection;

/// Document class for storing WorkflowPageModel.
typedef WorkflowPageModelMirrorDocument = _$WorkflowPageModelMirrorDocument;

/// Collection class for storing WorkflowPageModel.
typedef WorkflowPageModelMirrorCollection = _$WorkflowPageModelMirrorCollection;
