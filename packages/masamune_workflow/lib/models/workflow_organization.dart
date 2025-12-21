// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";

part "workflow_organization.m.dart";
part "workflow_organization.g.dart";
part "workflow_organization.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/organization")
abstract class WorkflowOrganizationModel with _$WorkflowOrganizationModel {
  /// Value for model.
  const factory WorkflowOrganizationModel({
    String? name,
    String? description,
    String? icon,
    String? ownerId,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowOrganizationModel;
  const WorkflowOrganizationModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowOrganizationModel.fromJson(json);
  /// ```
  factory WorkflowOrganizationModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowOrganizationModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowOrganizationModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowOrganizationModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowOrganizationModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowOrganizationModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowOrganizationModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowOrganizationModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowOrganizationModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowOrganizationModel.form(WorkflowOrganizationModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowOrganizationModel.form(WorkflowOrganizationModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowOrganizationModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowOrganizationModel.
typedef WorkflowOrganizationModelKeys = _$WorkflowOrganizationModelKeys;

/// Alias for ModelRef&lt;WorkflowOrganizationModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowOrganizationModelDocument) WorkflowOrganizationModelRef workflow_organization
/// ```
typedef WorkflowOrganizationModelRef = ModelRef<WorkflowOrganizationModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowOrganizationModel&gt;.
///
/// ```dart
/// WorkflowOrganizationModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowOrganizationModelRefPath = _$WorkflowOrganizationModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowOrganizationModelInitialCollection(
///       "xxx": WorkflowOrganizationModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowOrganizationModelInitialCollection
    = _$WorkflowOrganizationModelInitialCollection;

/// Document class for storing WorkflowOrganizationModel.
typedef WorkflowOrganizationModelDocument = _$WorkflowOrganizationModelDocument;

/// Collection class for storing WorkflowOrganizationModel.
typedef WorkflowOrganizationModelCollection
    = _$WorkflowOrganizationModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowOrganizationModel&gt;.
///
/// ```dart
/// WorkflowOrganizationModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowOrganizationModelMirrorRefPath
    = _$WorkflowOrganizationModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowOrganizationModelMirrorInitialCollection(
///       "xxx": WorkflowOrganizationModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowOrganizationModelMirrorInitialCollection
    = _$WorkflowOrganizationModelMirrorInitialCollection;

/// Document class for storing WorkflowOrganizationModel.
typedef WorkflowOrganizationModelMirrorDocument
    = _$WorkflowOrganizationModelMirrorDocument;

/// Collection class for storing WorkflowOrganizationModel.
typedef WorkflowOrganizationModelMirrorCollection
    = _$WorkflowOrganizationModelMirrorCollection;
