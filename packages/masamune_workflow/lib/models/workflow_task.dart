// ignore: unused_import, unnecessary_import

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_workflow/masamune_workflow.dart";

// ignore: unused_import, unnecessary_import

part "workflow_task.m.dart";
part "workflow_task.g.dart";
part "workflow_task.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/task")
abstract class WorkflowTaskModel with _$WorkflowTaskModel {
  /// Value for model.
  const factory WorkflowTaskModel({
    @refParam WorkflowWorkflowModelRef workflow,
    @refParam WorkflowOrganizationModelRef organization,
    @refParam WorkflowProjectModelRef project,
    ModelLocale? locale,
    @Default(WorkflowTaskStatus.waiting) WorkflowTaskStatus status,
    @jsonParam @Default([]) List<WorkflowActionCommandValue> actions,
    @refParam WorkflowActionModelRef? currentAction,
    @jsonParam WorkflowActionCommandValue? nextAction,
    Map<String, dynamic>? error,
    @jsonParam @Default([]) List<WorkflowTaskLogValue> log,
    String? prompt,
    Map<String, dynamic>? materials,
    Map<String, dynamic>? results,
    Map<String, dynamic>? assets,
    @searchParam String? search,
    @Default(0) double usage,
    ModelTimestamp? startTime,
    ModelTimestamp? finishedTime,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowTaskModel;
  const WorkflowTaskModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowTaskModel.fromJson(json);
  /// ```
  factory WorkflowTaskModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowTaskModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowTaskModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowTaskModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowTaskModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowTaskModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowTaskModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowTaskModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowTaskModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowTaskModel.form(WorkflowTaskModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowTaskModel.form(WorkflowTaskModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowTaskModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowTaskModel.
typedef WorkflowTaskModelKeys = _$WorkflowTaskModelKeys;

/// Alias for ModelRef&lt;WorkflowTaskModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowTaskModelDocument) WorkflowTaskModelRef workflow_task
/// ```
typedef WorkflowTaskModelRef = ModelRef<WorkflowTaskModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowTaskModel&gt;.
///
/// ```dart
/// WorkflowTaskModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowTaskModelRefPath = _$WorkflowTaskModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowTaskModelInitialCollection(
///       "xxx": WorkflowTaskModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowTaskModelInitialCollection
    = _$WorkflowTaskModelInitialCollection;

/// Document class for storing WorkflowTaskModel.
typedef WorkflowTaskModelDocument = _$WorkflowTaskModelDocument;

/// Collection class for storing WorkflowTaskModel.
typedef WorkflowTaskModelCollection = _$WorkflowTaskModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowTaskModel&gt;.
///
/// ```dart
/// WorkflowTaskModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowTaskModelMirrorRefPath = _$WorkflowTaskModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowTaskModelMirrorInitialCollection(
///       "xxx": WorkflowTaskModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowTaskModelMirrorInitialCollection
    = _$WorkflowTaskModelMirrorInitialCollection;

/// Document class for storing WorkflowTaskModel.
typedef WorkflowTaskModelMirrorDocument = _$WorkflowTaskModelMirrorDocument;

/// Collection class for storing WorkflowTaskModel.
typedef WorkflowTaskModelMirrorCollection = _$WorkflowTaskModelMirrorCollection;
