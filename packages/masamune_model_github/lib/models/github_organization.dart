// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import
import "package:masamune_model_github/masamune_model_github.dart";

part "github_organization.m.dart";
part "github_organization.g.dart";
part "github_organization.freezed.dart";

/// Model for managing Github organizations.
///
/// GithubのOrganizationを管理するためのモデル。
@freezed
@formValue
@immutable
@CollectionModelPath("organization",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubOrganizationModel with _$GithubOrganizationModel {
  /// Model for managing Github organizations.
  ///
  /// GithubのOrganizationを管理するためのモデル。
  const factory GithubOrganizationModel({
    int? id,
    String? name,
    String? login,
    String? company,
    String? blog,
    String? location,
    String? email,
    @Default(0) int publicReposCount,
    @Default(0) int publicGistsCount,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    ModelUri? htmlUrl,
    ModelImageUri? avatarUrl,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
  }) = _GithubOrganizationModel;
  const GithubOrganizationModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubOrganizationModel.fromJson(json);
  /// ```
  factory GithubOrganizationModel.fromJson(Map<String, Object?> json) =>
      _$GithubOrganizationModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubOrganizationModel.document(id));       // Get the document.
  /// ref.app.model(GithubOrganizationModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubOrganizationModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubOrganizationModel.collection());       // Get the collection.
  /// ref.app.model(GithubOrganizationModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubOrganizationModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubOrganizationModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubOrganizationModel.form(GithubOrganizationModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubOrganizationModel.form(GithubOrganizationModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubOrganizationModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubOrganizationModel.
typedef GithubOrganizationModelKeys = _$GithubOrganizationModelKeys;

/// Alias for ModelRef&lt;GithubOrganizationModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubOrganizationModelDocument) GithubOrganizationModelRef organization
/// ```
typedef GithubOrganizationModelRef = ModelRef<GithubOrganizationModel>?;

/// It can be defined as an empty ModelRef&lt;GithubOrganizationModel&gt;.
///
/// ```dart
/// GithubOrganizationModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubOrganizationModelRefPath = _$GithubOrganizationModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubOrganizationModelInitialCollection(
///       "xxx": GithubOrganizationModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubOrganizationModelInitialCollection
    = _$GithubOrganizationModelInitialCollection;

/// Document class for storing GithubOrganizationModel.
typedef GithubOrganizationModelDocument = _$GithubOrganizationModelDocument;

/// Collection class for storing GithubOrganizationModel.
typedef GithubOrganizationModelCollection = _$GithubOrganizationModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubOrganizationModel&gt;.
///
/// ```dart
/// GithubOrganizationModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubOrganizationModelMirrorRefPath
    = _$GithubOrganizationModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubOrganizationModelMirrorInitialCollection(
///       "xxx": GithubOrganizationModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubOrganizationModelMirrorInitialCollection
    = _$GithubOrganizationModelMirrorInitialCollection;

/// Document class for storing GithubOrganizationModel.
typedef GithubOrganizationModelMirrorDocument
    = _$GithubOrganizationModelMirrorDocument;

/// Collection class for storing GithubOrganizationModel.
typedef GithubOrganizationModelMirrorCollection
    = _$GithubOrganizationModelMirrorCollection;
