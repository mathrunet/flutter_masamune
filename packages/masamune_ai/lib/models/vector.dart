// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_ai/masamune_ai.dart";

part "vector.m.dart";
part "vector.g.dart";
part "vector.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("agent/:agent_id/vector",
    adapter: "AIMasamuneAdapter.primary.vectorModelAdapter")
abstract class VectorModel with _$VectorModel {
  /// Value for model.
  const factory VectorModel({
    required String agentId,
    required String content,
    required ModelVectorValue vector,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
  }) = _VectorModel;
  const VectorModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// VectorModel.fromJson(json);
  /// ```
  factory VectorModel.fromJson(Map<String, Object?> json) =>
      _$VectorModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(VectorModel.document(id));       // Get the document.
  /// ref.app.model(VectorModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$VectorModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(VectorModel.collection());       // Get the collection.
  /// ref.app.model(VectorModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   VectorModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$VectorModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(VectorModel.form(VectorModel()));    // Get the form controller in app scope.
  /// ref.page.form(VectorModel.form(VectorModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$VectorModelFormQuery();
}

/// [Enum] of the name of the value defined in VectorModel.
typedef VectorModelKeys = _$VectorModelKeys;

/// Alias for ModelRef&lt;VectorModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(VectorModelDocument) VectorModelRef vector
/// ```
typedef VectorModelRef = ModelRef<VectorModel>?;

/// It can be defined as an empty ModelRef&lt;VectorModel&gt;.
///
/// ```dart
/// VectorModelRefPath("xxx") // Define as a path.
/// ```
typedef VectorModelRefPath = _$VectorModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     VectorModelInitialCollection(
///       "xxx": VectorModel(...),
///     ),
///   ],
/// );
/// ```
typedef VectorModelInitialCollection = _$VectorModelInitialCollection;

/// Document class for storing VectorModel.
typedef VectorModelDocument = _$VectorModelDocument;

/// Collection class for storing VectorModel.
typedef VectorModelCollection = _$VectorModelCollection;

/// It can be defined as an empty ModelRef&lt;VectorModel&gt;.
///
/// ```dart
/// VectorModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef VectorModelMirrorRefPath = _$VectorModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     VectorModelMirrorInitialCollection(
///       "xxx": VectorModel(...),
///     ),
///   ],
/// );
/// ```
typedef VectorModelMirrorInitialCollection
    = _$VectorModelMirrorInitialCollection;

/// Document class for storing VectorModel.
typedef VectorModelMirrorDocument = _$VectorModelMirrorDocument;

/// Collection class for storing VectorModel.
typedef VectorModelMirrorCollection = _$VectorModelMirrorCollection;
