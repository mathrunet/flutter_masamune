// ignore: unused_import, unnecessary_import

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_workflow/models/workflow_organization.dart";

// ignore: unused_import, unnecessary_import

part "workflow_certificate.m.dart";
part "workflow_certificate.g.dart";
part "workflow_certificate.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "plugins/workflow/organization/:organization_id/certificate")
abstract class WorkflowCertificateModel with _$WorkflowCertificateModel {
  /// Value for model.
  const factory WorkflowCertificateModel({
    @refParam WorkflowOrganizationModelRef organization,
    String? token,
    @Default([]) List<String> scope,
    ModelTimestamp? expiredTime,
    @Default(ModelTimestamp.now()) ModelTimestamp createdTime,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedTime,
  }) = _WorkflowCertificateModel;
  const WorkflowCertificateModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowCertificateModel.fromJson(json);
  /// ```
  factory WorkflowCertificateModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowCertificateModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowCertificateModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowCertificateModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowCertificateModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowCertificateModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowCertificateModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowCertificateModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowCertificateModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowCertificateModel.form(WorkflowCertificateModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowCertificateModel.form(WorkflowCertificateModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowCertificateModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowCertificateModel.
typedef WorkflowCertificateModelKeys = _$WorkflowCertificateModelKeys;

/// Alias for ModelRef&lt;WorkflowCertificateModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowCertificateModelDocument) WorkflowCertificateModelRef workflow_certificate
/// ```
typedef WorkflowCertificateModelRef = ModelRef<WorkflowCertificateModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowCertificateModel&gt;.
///
/// ```dart
/// WorkflowCertificateModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowCertificateModelRefPath = _$WorkflowCertificateModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowCertificateModelInitialCollection(
///       "xxx": WorkflowCertificateModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowCertificateModelInitialCollection
    = _$WorkflowCertificateModelInitialCollection;

/// Document class for storing WorkflowCertificateModel.
typedef WorkflowCertificateModelDocument = _$WorkflowCertificateModelDocument;

/// Collection class for storing WorkflowCertificateModel.
typedef WorkflowCertificateModelCollection
    = _$WorkflowCertificateModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowCertificateModel&gt;.
///
/// ```dart
/// WorkflowCertificateModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowCertificateModelMirrorRefPath
    = _$WorkflowCertificateModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowCertificateModelMirrorInitialCollection(
///       "xxx": WorkflowCertificateModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowCertificateModelMirrorInitialCollection
    = _$WorkflowCertificateModelMirrorInitialCollection;

/// Document class for storing WorkflowCertificateModel.
typedef WorkflowCertificateModelMirrorDocument
    = _$WorkflowCertificateModelMirrorDocument;

/// Collection class for storing WorkflowCertificateModel.
typedef WorkflowCertificateModelMirrorCollection
    = _$WorkflowCertificateModelMirrorCollection;
