// ignore: unused_import, unnecessary_import

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import


part "workflow_address.m.dart";
part "workflow_address.g.dart";
part "workflow_address.freezed.dart";

/// Address Model for Companies and Developers
///
/// 企業や開発者のアドレスモデル。
@freezed
@formValue
@immutable
@CollectionModelPath("plugins/workflow/address")
abstract class WorkflowAddressModel with _$WorkflowAddressModel {
  /// Address Model for Companies and Developers
  ///
  /// 企業や開発者のアドレスモデル。
  const factory WorkflowAddressModel({
    @Default(0) int appCount,
    @Default([]) List<String> appNames,
    @Default([]) List<String> appSummaries,
    @Default(ModelTimestamp()) ModelTimestamp collectedTime,
    @Default(ModelTimestamp()) ModelTimestamp updatedTime,
    String? developerId,
    String? developerName,
    String? email,
    String? privacyPolicyUrl,
    String? source,
    @Default([]) List<String> contactPageUrls,
  }) = _WorkflowAddressModel;
  const WorkflowAddressModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// WorkflowAddressModel.fromJson(json);
  /// ```
  factory WorkflowAddressModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowAddressModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(WorkflowAddressModel.document(id));       // Get the document.
  /// ref.app.model(WorkflowAddressModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$WorkflowAddressModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(WorkflowAddressModel.collection());       // Get the collection.
  /// ref.app.model(WorkflowAddressModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   WorkflowAddressModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$WorkflowAddressModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(WorkflowAddressModel.form(WorkflowAddressModel()));    // Get the form controller in app scope.
  /// ref.page.form(WorkflowAddressModel.form(WorkflowAddressModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$WorkflowAddressModelFormQuery();
}

/// [Enum] of the name of the value defined in WorkflowAddressModel.
typedef WorkflowAddressModelKeys = _$WorkflowAddressModelKeys;

/// Alias for ModelRef&lt;WorkflowAddressModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(WorkflowAddressModelDocument) WorkflowAddressModelRef workflow_address
/// ```
typedef WorkflowAddressModelRef = ModelRef<WorkflowAddressModel>?;

/// It can be defined as an empty ModelRef&lt;WorkflowAddressModel&gt;.
///
/// ```dart
/// WorkflowAddressModelRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowAddressModelRefPath = _$WorkflowAddressModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowAddressModelInitialCollection(
///       "xxx": WorkflowAddressModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowAddressModelInitialCollection
    = _$WorkflowAddressModelInitialCollection;

/// Document class for storing WorkflowAddressModel.
typedef WorkflowAddressModelDocument = _$WorkflowAddressModelDocument;

/// Collection class for storing WorkflowAddressModel.
typedef WorkflowAddressModelCollection = _$WorkflowAddressModelCollection;

/// It can be defined as an empty ModelRef&lt;WorkflowAddressModel&gt;.
///
/// ```dart
/// WorkflowAddressModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef WorkflowAddressModelMirrorRefPath = _$WorkflowAddressModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     WorkflowAddressModelMirrorInitialCollection(
///       "xxx": WorkflowAddressModel(...),
///     ),
///   ],
/// );
/// ```
typedef WorkflowAddressModelMirrorInitialCollection
    = _$WorkflowAddressModelMirrorInitialCollection;

/// Document class for storing WorkflowAddressModel.
typedef WorkflowAddressModelMirrorDocument
    = _$WorkflowAddressModelMirrorDocument;

/// Collection class for storing WorkflowAddressModel.
typedef WorkflowAddressModelMirrorCollection
    = _$WorkflowAddressModelMirrorCollection;
