// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_workflow/masamune_workflow.dart";
import "package:masamune_workflow/models/workflow_organization.dart";

part "workflow_organization_member.m.dart";
part "workflow_organization_member.g.dart";
part "workflow_organization_member.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/organization/:organization_id/member")
abstract class WorkflowOrganizationMemberModel
    with _$WorkflowOrganizationMemberModel {
  /// Value for model.
  const factory WorkflowOrganizationMemberModel({
    required WorkflowRole role,
    String? userId,
    @refParam WorkflowOrganizationModelRef organization,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowOrganizationMemberModel;
  const WorkflowOrganizationMemberModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowOrganizationMemberModel.fromJson(json);
  /// ```
  factory WorkflowOrganizationMemberModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowOrganizationMemberModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowOrganizationMemberModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowOrganizationMemberModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowOrganizationMemberModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowOrganizationMemberModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowOrganizationMemberModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowOrganizationMemberModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowOrganizationMemberModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowOrganizationMemberModel.form(WorkflowOrganizationMemberModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowOrganizationMemberModel.form(WorkflowOrganizationMemberModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowOrganizationMemberModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowOrganizationMemberModel.
typedef WorkflowOrganizationMemberModelKeys
    = _$WorkflowOrganizationMemberModelKeys;

/// Alias for ModelRef&lt;WorkflowOrganizationMemberModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowOrganizationMemberModelDocument) WorkflowOrganizationMemberModelRef workflow_organization_member
/// ```
typedef WorkflowOrganizationMemberModelRef
    = ModelRef<WorkflowOrganizationMemberModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowOrganizationMemberModel&gt;.
///
/// ```dart
/// WorkflowOrganizationMemberModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowOrganizationMemberModelRefPath
    = _$WorkflowOrganizationMemberModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowOrganizationMemberModelInitialCollection(
///       "xxx": WorkflowOrganizationMemberModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowOrganizationMemberModelInitialCollection
    = _$WorkflowOrganizationMemberModelInitialCollection;

/// Document class for storing WorkflowOrganizationMemberModel.
typedef WorkflowOrganizationMemberModelDocument
    = _$WorkflowOrganizationMemberModelDocument;

/// Collection class for storing WorkflowOrganizationMemberModel.
typedef WorkflowOrganizationMemberModelCollection
    = _$WorkflowOrganizationMemberModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowOrganizationMemberModel&gt;.
///
/// ```dart
/// WorkflowOrganizationMemberModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowOrganizationMemberModelMirrorRefPath
    = _$WorkflowOrganizationMemberModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowOrganizationMemberModelMirrorInitialCollection(
///       "xxx": WorkflowOrganizationMemberModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowOrganizationMemberModelMirrorInitialCollection
    = _$WorkflowOrganizationMemberModelMirrorInitialCollection;

/// Document class for storing WorkflowOrganizationMemberModel.
typedef WorkflowOrganizationMemberModelMirrorDocument
    = _$WorkflowOrganizationMemberModelMirrorDocument;

/// Collection class for storing WorkflowOrganizationMemberModel.
typedef WorkflowOrganizationMemberModelMirrorCollection
    = _$WorkflowOrganizationMemberModelMirrorCollection;
