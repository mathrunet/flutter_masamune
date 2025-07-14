// ignore: unused_import, unnecessary_import

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";
import "package:masamune_model_github/models/github_label.dart";
import "package:masamune_model_github/models/github_milestone.dart";
import "package:masamune_model_github/models/github_pull_request_head.dart";
import "package:masamune_model_github/models/github_repository.dart";
import "package:masamune_model_github/models/github_user.dart";

part "github_pull_request.m.dart";
part "github_pull_request.g.dart";
part "github_pull_request.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/pull_request")
abstract class GithubPullRequestModel with _$GithubPullRequestModel {
  /// Value for model.
  const factory GithubPullRequestModel({
    int? id,
    String? nodeId,
    int? number,
    String? state,
    String? title,
    String? body,
    String? mergeCommitSha,
    String? mergeableState,
    String? authorAssociation,
    @Default(false) bool draft,
    @Default(false) bool merged,
    @Default(false) bool mergeable,
    @Default(false) bool rebaseable,
    @Default(false) bool maintainerCanModify,
    @Default(0) int commentsCount,
    @Default(0) int commitsCount,
    @Default(0) int additionsCount,
    @Default(0) int deletionsCount,
    @Default(0) int changedFilesCount,
    @Default(0) int reviewCommentCount,
    @refParam GithubRepositoryModelRef? repository,
    @refParam GithubUserModelRef? user,
    @refParam GithubUserModelRef? mergedBy,
    @Default([]) @refParam List<GithubUserModelRef> requestedReviewers,
    @jsonParam @Default(<GithubLabelValue>[]) List<GithubLabelValue> labels,
    @jsonParam GithubPullRequestHeadValue? head,
    @jsonParam GithubPullRequestHeadValue? base,
    @jsonParam GithubMilestoneValue? milestone,
    ModelUri? htmlUrl,
    ModelUri? diffUrl,
    ModelUri? patchUrl,
    ModelTimestamp? closedAt,
    ModelTimestamp? mergedAt,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
  }) = _GithubPullRequestModel;
  const GithubPullRequestModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubPullRequestModel.fromJson(json);
  /// ```
  factory GithubPullRequestModel.fromJson(Map<String, Object?> json) =>
      _$GithubPullRequestModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubPullRequestModel.document(id));       // Get the document.
  /// ref.app.model(GithubPullRequestModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubPullRequestModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubPullRequestModel.collection());       // Get the collection.
  /// ref.app.model(GithubPullRequestModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubPullRequestModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubPullRequestModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubPullRequestModel.form(GithubPullRequestModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubPullRequestModel.form(GithubPullRequestModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubPullRequestModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubPullRequestModel.
typedef GithubPullRequestModelKeys = _$GithubPullRequestModelKeys;

/// Alias for ModelRef&lt;GithubPullRequestModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubPullRequestModelDocument) GithubPullRequestModelRef pull_request
/// ```
typedef GithubPullRequestModelRef = ModelRef<GithubPullRequestModel>?;

/// It can be defined as an empty ModelRef&lt;GithubPullRequestModel&gt;.
///
/// ```dart
/// GithubPullRequestModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubPullRequestModelRefPath = _$GithubPullRequestModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubPullRequestModelInitialCollection(
///       "xxx": GithubPullRequestModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubPullRequestModelInitialCollection
    = _$GithubPullRequestModelInitialCollection;

/// Document class for storing GithubPullRequestModel.
typedef GithubPullRequestModelDocument = _$GithubPullRequestModelDocument;

/// Collection class for storing GithubPullRequestModel.
typedef GithubPullRequestModelCollection = _$GithubPullRequestModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubPullRequestModel&gt;.
///
/// ```dart
/// GithubPullRequestModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubPullRequestModelMirrorRefPath
    = _$GithubPullRequestModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubPullRequestModelMirrorInitialCollection(
///       "xxx": GithubPullRequestModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubPullRequestModelMirrorInitialCollection
    = _$GithubPullRequestModelMirrorInitialCollection;

/// Document class for storing GithubPullRequestModel.
typedef GithubPullRequestModelMirrorDocument
    = _$GithubPullRequestModelMirrorDocument;

/// Collection class for storing GithubPullRequestModel.
typedef GithubPullRequestModelMirrorCollection
    = _$GithubPullRequestModelMirrorCollection;
