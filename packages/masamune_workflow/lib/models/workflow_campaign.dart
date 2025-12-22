// ignore: unused_import, unnecessary_import

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_workflow/models/workflow_organization.dart";

// ignore: unused_import, unnecessary_import

part "workflow_campaign.m.dart";
part "workflow_campaign.g.dart";
part "workflow_campaign.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/campaign")
abstract class WorkflowCampaignModel with _$WorkflowCampaignModel {
  /// Value for model.
  const factory WorkflowCampaignModel({
    @refParam WorkflowOrganizationModelRef organization,
    @Default(0) double limit,
    ModelTimestamp? expiredTime,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowCampaignModel;
  const WorkflowCampaignModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowCampaignModel.fromJson(json);
  /// ```
  factory WorkflowCampaignModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowCampaignModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowCampaignModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowCampaignModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowCampaignModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowCampaignModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowCampaignModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowCampaignModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowCampaignModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowCampaignModel.form(WorkflowCampaignModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowCampaignModel.form(WorkflowCampaignModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowCampaignModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowCampaignModel.
typedef WorkflowCampaignModelKeys = _$WorkflowCampaignModelKeys;

/// Alias for ModelRef&lt;WorkflowCampaignModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowCampaignModelDocument) WorkflowCampaignModelRef workflow_campaign
/// ```
typedef WorkflowCampaignModelRef = ModelRef<WorkflowCampaignModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowCampaignModel&gt;.
///
/// ```dart
/// WorkflowCampaignModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowCampaignModelRefPath = _$WorkflowCampaignModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowCampaignModelInitialCollection(
///       "xxx": WorkflowCampaignModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowCampaignModelInitialCollection
    = _$WorkflowCampaignModelInitialCollection;

/// Document class for storing WorkflowCampaignModel.
typedef WorkflowCampaignModelDocument = _$WorkflowCampaignModelDocument;

/// Collection class for storing WorkflowCampaignModel.
typedef WorkflowCampaignModelCollection = _$WorkflowCampaignModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowCampaignModel&gt;.
///
/// ```dart
/// WorkflowCampaignModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowCampaignModelMirrorRefPath
    = _$WorkflowCampaignModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowCampaignModelMirrorInitialCollection(
///       "xxx": WorkflowCampaignModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowCampaignModelMirrorInitialCollection
    = _$WorkflowCampaignModelMirrorInitialCollection;

/// Document class for storing WorkflowCampaignModel.
typedef WorkflowCampaignModelMirrorDocument
    = _$WorkflowCampaignModelMirrorDocument;

/// Collection class for storing WorkflowCampaignModel.
typedef WorkflowCampaignModelMirrorCollection
    = _$WorkflowCampaignModelMirrorCollection;
