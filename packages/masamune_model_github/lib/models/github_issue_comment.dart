// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

// ignore: unused_import, unnecessary_import

part "github_issue_comment.m.dart";
part "github_issue_comment.g.dart";
part "github_issue_comment.freezed.dart";

/// Model for managing Github issue comments.
///
/// GithubのIssueコメントを管理するためのモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/issue/:issue_id/comment",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubIssueCommentModel with _$GithubIssueCommentModel {
  /// Model for managing Github issue comments.
  ///
  /// GithubのIssueコメントを管理するためのモデル。
  const factory GithubIssueCommentModel({
    int? id,
    String? body,
    String? authorAssociation,
    @refParam GithubUserModelRef? user,
    ModelUri? url,
    ModelUri? htmlUrl,
    ModelUri? issueUrl,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubIssueCommentModel;
  const GithubIssueCommentModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubIssueCommentModel.fromJson(json);
  /// ```
  factory GithubIssueCommentModel.fromJson(Map<String, Object?> json) =>
      _$GithubIssueCommentModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubIssueCommentModel.document(id));       // Get the document.
  /// ref.app.model(GithubIssueCommentModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubIssueCommentModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubIssueCommentModel.collection());       // Get the collection.
  /// ref.app.model(GithubIssueCommentModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubIssueCommentModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubIssueCommentModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubIssueCommentModel.form(GithubIssueCommentModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubIssueCommentModel.form(GithubIssueCommentModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubIssueCommentModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubIssueCommentModel.
typedef GithubIssueCommentModelKeys = _$GithubIssueCommentModelKeys;

/// Alias for ModelRef&lt;GithubIssueCommentModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubIssueCommentModelDocument) GithubIssueCommentModelRef github_issue_comment
/// ```
typedef GithubIssueCommentModelRef = ModelRef<GithubIssueCommentModel>?;

/// It can be defined as an empty ModelRef&lt;GithubIssueCommentModel&gt;.
///
/// ```dart
/// GithubIssueCommentModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubIssueCommentModelRefPath = _$GithubIssueCommentModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubIssueCommentModelInitialCollection(
///       "xxx": GithubIssueCommentModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubIssueCommentModelInitialCollection
    = _$GithubIssueCommentModelInitialCollection;

/// Document class for storing GithubIssueCommentModel.
typedef GithubIssueCommentModelDocument = _$GithubIssueCommentModelDocument;

/// Collection class for storing GithubIssueCommentModel.
typedef GithubIssueCommentModelCollection = _$GithubIssueCommentModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubIssueCommentModel&gt;.
///
/// ```dart
/// GithubIssueCommentModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubIssueCommentModelMirrorRefPath
    = _$GithubIssueCommentModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubIssueCommentModelMirrorInitialCollection(
///       "xxx": GithubIssueCommentModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubIssueCommentModelMirrorInitialCollection
    = _$GithubIssueCommentModelMirrorInitialCollection;

/// Document class for storing GithubIssueCommentModel.
typedef GithubIssueCommentModelMirrorDocument
    = _$GithubIssueCommentModelMirrorDocument;

/// Collection class for storing GithubIssueCommentModel.
typedef GithubIssueCommentModelMirrorCollection
    = _$GithubIssueCommentModelMirrorCollection;
