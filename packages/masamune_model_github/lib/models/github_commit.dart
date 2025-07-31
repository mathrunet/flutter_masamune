// ignore: unused_import, unnecessary_import

// ignore_for_file: invalid_annotation_target

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

// ignore: unused_import, unnecessary_import

part "github_commit.m.dart";
part "github_commit.g.dart";
part "github_commit.freezed.dart";

/// Model for managing Github commits.
///
/// Githubのコミットを管理するためのモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/branch/:branch_id/commit",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubCommitModel with _$GithubCommitModel {
  /// Model for managing Github commits.
  ///
  /// Githubのコミットを管理するためのモデル。
  @JsonSerializable(explicitToJson: true)
  const factory GithubCommitModel({
    String? sha,
    String? message,
    @Default(0) int commentCount,
    @Default(0) int additionsCount,
    @Default(0) int deletionsCount,
    @Default(0) int totalCount,
    ModelUri? url,
    ModelUri? htmlUrl,
    ModelUri? commentsUrl,
    @refParam GithubUserModelRef? author,
    @refParam GithubUserModelRef? committer,
    ModelTimestamp? authorDate,
    ModelTimestamp? committerDate,
    @jsonParam @Default([]) List<GithubCommitModel> parents,
    @jsonParam @Default([]) List<GithubContentModel> contents,
    @Default(false) bool fromServer,
  }) = _GithubCommitModel;
  const GithubCommitModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubCommitModel.fromJson(json);
  /// ```
  factory GithubCommitModel.fromJson(Map<String, Object?> json) =>
      _$GithubCommitModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubCommitModel.document(id));       // Get the document.
  /// ref.app.model(GithubCommitModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubCommitModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubCommitModel.collection());       // Get the collection.
  /// ref.app.model(GithubCommitModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubCommitModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubCommitModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubCommitModel.form(GithubCommitModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubCommitModel.form(GithubCommitModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubCommitModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubCommitModel.
typedef GithubCommitModelKeys = _$GithubCommitModelKeys;

/// Alias for ModelRef&lt;GithubCommitModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubCommitModelDocument) GithubCommitModelRef github_commit
/// ```
typedef GithubCommitModelRef = ModelRef<GithubCommitModel>?;

/// It can be defined as an empty ModelRef&lt;GithubCommitModel&gt;.
///
/// ```dart
/// GithubCommitModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubCommitModelRefPath = _$GithubCommitModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubCommitModelInitialCollection(
///       "xxx": GithubCommitModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubCommitModelInitialCollection
    = _$GithubCommitModelInitialCollection;

/// Document class for storing GithubCommitModel.
typedef GithubCommitModelDocument = _$GithubCommitModelDocument;

/// Collection class for storing GithubCommitModel.
typedef GithubCommitModelCollection = _$GithubCommitModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubCommitModel&gt;.
///
/// ```dart
/// GithubCommitModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubCommitModelMirrorRefPath = _$GithubCommitModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubCommitModelMirrorInitialCollection(
///       "xxx": GithubCommitModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubCommitModelMirrorInitialCollection
    = _$GithubCommitModelMirrorInitialCollection;

/// Document class for storing GithubCommitModel.
typedef GithubCommitModelMirrorDocument = _$GithubCommitModelMirrorDocument;

/// Collection class for storing GithubCommitModel.
typedef GithubCommitModelMirrorCollection = _$GithubCommitModelMirrorCollection;
