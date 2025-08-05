// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

// ignore: unused_import, unnecessary_import

part "github_project.m.dart";
part "github_project.g.dart";
part "github_project.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/project",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubProjectModel with _$GithubProjectModel {
  /// Value for model.
  const factory GithubProjectModel({
    int? id,
    String? name,
    String? previousName,
    ModelUri? projectUrl,
    ModelUri? url,
  }) = _GithubProjectModel;
  const GithubProjectModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubProjectModel.fromJson(json);
  /// ```
  factory GithubProjectModel.fromJson(Map<String, Object?> json) =>
      _$GithubProjectModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubProjectModel.document(id));       // Get the document.
  /// ref.app.model(GithubProjectModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubProjectModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubProjectModel.collection());       // Get the collection.
  /// ref.app.model(GithubProjectModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubProjectModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubProjectModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubProjectModel.form(GithubProjectModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubProjectModel.form(GithubProjectModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubProjectModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubProjectModel.
typedef GithubProjectModelKeys = _$GithubProjectModelKeys;

/// Alias for ModelRef&lt;GithubProjectModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubProjectModelDocument) GithubProjectModelRef github_project
/// ```
typedef GithubProjectModelRef = ModelRef<GithubProjectModel>?;

/// It can be defined as an empty ModelRef&lt;GithubProjectModel&gt;.
///
/// ```dart
/// GithubProjectModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubProjectModelRefPath = _$GithubProjectModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubProjectModelInitialCollection(
///       "xxx": GithubProjectModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubProjectModelInitialCollection
    = _$GithubProjectModelInitialCollection;

/// Document class for storing GithubProjectModel.
typedef GithubProjectModelDocument = _$GithubProjectModelDocument;

/// Collection class for storing GithubProjectModel.
typedef GithubProjectModelCollection = _$GithubProjectModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubProjectModel&gt;.
///
/// ```dart
/// GithubProjectModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubProjectModelMirrorRefPath = _$GithubProjectModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubProjectModelMirrorInitialCollection(
///       "xxx": GithubProjectModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubProjectModelMirrorInitialCollection
    = _$GithubProjectModelMirrorInitialCollection;

/// Document class for storing GithubProjectModel.
typedef GithubProjectModelMirrorDocument = _$GithubProjectModelMirrorDocument;

/// Collection class for storing GithubProjectModel.
typedef GithubProjectModelMirrorCollection
    = _$GithubProjectModelMirrorCollection;
