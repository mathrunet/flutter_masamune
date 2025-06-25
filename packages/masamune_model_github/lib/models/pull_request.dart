// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";


import "package:freezed_annotation/freezed_annotation.dart";

part "pull_request.m.dart";
part "pull_request.g.dart";
part "pull_request.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("pull_request")
abstract class PullRequestModel with _$PullRequestModel {
  /// Value for model.
  const factory PullRequestModel({
     // TODO: Set the data fields.
     
  }) = _PullRequestModel;
  const PullRequestModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// PullRequestModel.fromJson(json);
  /// ```
  factory PullRequestModel.fromJson(Map<String, Object?> json) => _$PullRequestModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(PullRequestModel.document(id));       // Get the document.
  /// ref.app.model(PullRequestModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$PullRequestModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(PullRequestModel.collection());       // Get the collection.
  /// ref.app.model(PullRequestModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   PullRequestModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$PullRequestModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(PullRequestModel.form(PullRequestModel()));    // Get the form controller in app scope.
  /// ref.page.form(PullRequestModel.form(PullRequestModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$PullRequestModelFormQuery();
}

/// [Enum] of the name of the value defined in PullRequestModel.
typedef PullRequestModelKeys = _$PullRequestModelKeys;

/// Alias for ModelRef&lt;PullRequestModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(PullRequestModelDocument) PullRequestModelRef pull_request
/// ```
typedef PullRequestModelRef = ModelRef<PullRequestModel>?;

/// It can be defined as an empty ModelRef&lt;PullRequestModel&gt;.
///
/// ```dart
/// PullRequestModelRefPath("xxx") // Define as a path.
/// ```
typedef PullRequestModelRefPath = _$PullRequestModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PullRequestModelInitialCollection(
///       "xxx": PullRequestModel(...),
///     ),
///   ],
/// );
/// ```
typedef PullRequestModelInitialCollection = _$PullRequestModelInitialCollection;

/// Document class for storing PullRequestModel.
typedef PullRequestModelDocument = _$PullRequestModelDocument;

/// Collection class for storing PullRequestModel.
typedef PullRequestModelCollection = _$PullRequestModelCollection;

/// It can be defined as an empty ModelRef&lt;PullRequestModel&gt;.
///
/// ```dart
/// PullRequestModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef PullRequestModelMirrorRefPath = _$PullRequestModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PullRequestModelMirrorInitialCollection(
///       "xxx": PullRequestModel(...),
///     ),
///   ],
/// );
/// ```
typedef PullRequestModelMirrorInitialCollection = _$PullRequestModelMirrorInitialCollection;

/// Document class for storing PullRequestModel.
typedef PullRequestModelMirrorDocument = _$PullRequestModelMirrorDocument;

/// Collection class for storing PullRequestModel.
typedef PullRequestModelMirrorCollection = _$PullRequestModelMirrorCollection;
