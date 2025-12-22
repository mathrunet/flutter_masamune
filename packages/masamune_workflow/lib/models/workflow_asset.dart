// ignore: unused_import, unnecessary_import

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_workflow/models/workflow_organization.dart";

// ignore: unused_import, unnecessary_import

part "workflow_asset.m.dart";
part "workflow_asset.g.dart";
part "workflow_asset.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/asset")
abstract class WorkflowAssetModel with _$WorkflowAssetModel {
  /// Value for model.
  const factory WorkflowAssetModel({
    @refParam WorkflowOrganizationModelRef organization,
    String? source,
    String? content,
    String? path,
    String? mimtType,
    ModelLocale? locale,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowAssetModel;
  const WorkflowAssetModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowAssetModel.fromJson(json);
  /// ```
  factory WorkflowAssetModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowAssetModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowAssetModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowAssetModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowAssetModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowAssetModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowAssetModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowAssetModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowAssetModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowAssetModel.form(WorkflowAssetModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowAssetModel.form(WorkflowAssetModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowAssetModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowAssetModel.
typedef WorkflowAssetModelKeys = _$WorkflowAssetModelKeys;

/// Alias for ModelRef&lt;WorkflowAssetModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowAssetModelDocument) WorkflowAssetModelRef workflow_asset
/// ```
typedef WorkflowAssetModelRef = ModelRef<WorkflowAssetModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowAssetModel&gt;.
///
/// ```dart
/// WorkflowAssetModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowAssetModelRefPath = _$WorkflowAssetModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowAssetModelInitialCollection(
///       "xxx": WorkflowAssetModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowAssetModelInitialCollection
    = _$WorkflowAssetModelInitialCollection;

/// Document class for storing WorkflowAssetModel.
typedef WorkflowAssetModelDocument = _$WorkflowAssetModelDocument;

/// Collection class for storing WorkflowAssetModel.
typedef WorkflowAssetModelCollection = _$WorkflowAssetModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowAssetModel&gt;.
///
/// ```dart
/// WorkflowAssetModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowAssetModelMirrorRefPath = _$WorkflowAssetModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowAssetModelMirrorInitialCollection(
///       "xxx": WorkflowAssetModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowAssetModelMirrorInitialCollection
    = _$WorkflowAssetModelMirrorInitialCollection;

/// Document class for storing WorkflowAssetModel.
typedef WorkflowAssetModelMirrorDocument = _$WorkflowAssetModelMirrorDocument;

/// Collection class for storing WorkflowAssetModel.
typedef WorkflowAssetModelMirrorCollection
    = _$WorkflowAssetModelMirrorCollection;
