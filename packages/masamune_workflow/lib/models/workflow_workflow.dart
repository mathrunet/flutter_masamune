// ignore: unused_import, unnecessary_import
import "dart:convert";

// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_workflow/masamune_workflow.dart";

part "workflow_workflow.m.dart";
part "workflow_workflow.g.dart";
part "workflow_workflow.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/workflow")
abstract class WorkflowWorkflowModel with _$WorkflowWorkflowModel {
  /// Value for model.
  const factory WorkflowWorkflowModel({
    String? name,
    @refParam WorkflowProjectModelRef project,
    ModelLocale? locale,
    @refParam WorkflowOrganizationModelRef organization,
    @Default(WorkflowRepeat.none) WorkflowRepeat repeat,
    @jsonParam @Default([]) List<WorkflowActionCommandValue> actions,
    String? prompt,
    Map<String, dynamic>? materials,
    ModelTimestamp? nextTime,
    ModelTimestamp? startTime,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowWorkflowModel;
  const WorkflowWorkflowModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowWorkflowModel.fromJson(json);
  /// ```
  factory WorkflowWorkflowModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowWorkflowModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowWorkflowModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowWorkflowModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowWorkflowModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowWorkflowModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowWorkflowModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowWorkflowModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowWorkflowModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowWorkflowModel.form(WorkflowWorkflowModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowWorkflowModel.form(WorkflowWorkflowModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowWorkflowModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowWorkflowModel.
typedef WorkflowWorkflowModelKeys = _$WorkflowWorkflowModelKeys;

/// Alias for ModelRef&lt;WorkflowWorkflowModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowWorkflowModelDocument) WorkflowWorkflowModelRef workflow_workflow
/// ```
typedef WorkflowWorkflowModelRef = ModelRef<WorkflowWorkflowModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowWorkflowModel&gt;.
///
/// ```dart
/// WorkflowWorkflowModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowWorkflowModelRefPath = _$WorkflowWorkflowModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowWorkflowModelInitialCollection(
///       "xxx": WorkflowWorkflowModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowWorkflowModelInitialCollection
    = _$WorkflowWorkflowModelInitialCollection;

/// Document class for storing WorkflowWorkflowModel.
typedef WorkflowWorkflowModelDocument = _$WorkflowWorkflowModelDocument;

/// Collection class for storing WorkflowWorkflowModel.
typedef WorkflowWorkflowModelCollection = _$WorkflowWorkflowModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowWorkflowModel&gt;.
///
/// ```dart
/// WorkflowWorkflowModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowWorkflowModelMirrorRefPath
    = _$WorkflowWorkflowModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowWorkflowModelMirrorInitialCollection(
///       "xxx": WorkflowWorkflowModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowWorkflowModelMirrorInitialCollection
    = _$WorkflowWorkflowModelMirrorInitialCollection;

/// Document class for storing WorkflowWorkflowModel.
typedef WorkflowWorkflowModelMirrorDocument
    = _$WorkflowWorkflowModelMirrorDocument;

/// Collection class for storing WorkflowWorkflowModel.
typedef WorkflowWorkflowModelMirrorCollection
    = _$WorkflowWorkflowModelMirrorCollection;
