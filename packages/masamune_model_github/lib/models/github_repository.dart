// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

// ignore: unused_import, unnecessary_import

part "github_repository.m.dart";
part "github_repository.g.dart";
part "github_repository.freezed.dart";

/// Model for managing Github repositories.
///
/// Githubのリポジトリを管理するためのモデル。
@freezed
@formValue
@immutable
@CollectionModelPath("organization/:organization_id/repository",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubRepositoryModel with _$GithubRepositoryModel {
  /// Model for managing Github repositories.
  ///
  /// Githubのリポジトリを管理するためのモデル。
  const factory GithubRepositoryModel({
    int? id,
    String? name,
    String? fullName,
    @refParam GithubUserModelRef owner,
    @refParam GithubOrganizationModelRef organization,
    ModelLocale? language,
    @jsonParam GithubLicenseValue? license,
    @jsonParam GithubRepositoryPermissionValue? permissions,
    @Default(false) bool isPrivate,
    @Default(false) bool isFork,
    @Default(false) bool isTemplate,
    String? description,
    String? masterBranch,
    String? mergeCommitMessage,
    String? mergeCommitTitle,
    String? squashMergeCommitMessage,
    String? squashMergeCommitTitle,
    String? nodeId,
    String? tempCloneToken,
    String? visibility,
    @Default([]) List<String> topics,
    @Default(false) bool archived,
    @Default(false) bool disabled,
    @Default(false) bool hasIssues,
    @Default(false) bool hasWiki,
    @Default(false) bool hasDownloads,
    @Default(false) bool hasPages,
    @Default(false) bool hasDiscussions,
    @Default(false) bool hasProjects,
    @Default(false) bool allowAutoMerge,
    @Default(false) bool allowForking,
    @Default(false) bool allowMergeCommit,
    @Default(false) bool allowRebaseMerge,
    @Default(false) bool allowSquashMerge,
    @Default(false) bool allowUpdateBranch,
    @Default(false) bool anonymousAccessEnabled,
    @Default(false) bool deleteBranchOnMerge,
    @Default(false) bool webCommitSignoffRequired,
    @Default(0) int size,
    @Default(0) int stargazersCount,
    @Default(0) int watchersCount,
    @Default(0) int forksCount,
    @Default(0) int openIssuesCount,
    @Default(0) int subscribersCount,
    @Default(0) int networkCount,
    ModelUri? htmlUrl,
    ModelUri? cloneUrl,
    ModelUri? sshUrl,
    ModelUri? svnUrl,
    ModelUri? gitUrl,
    ModelUri? homepageUrl,
    ModelUri? archiveUrl,
    ModelUri? assigneesUrl,
    ModelUri? blobsUrl,
    ModelUri? branchesUrl,
    ModelUri? collaboratorsUrl,
    ModelUri? commentsUrl,
    ModelUri? commitsUrl,
    ModelUri? compareUrl,
    ModelUri? contentsUrl,
    ModelUri? contributorsUrl,
    ModelUri? deploymentsUrl,
    ModelUri? downloadsUrl,
    ModelUri? eventsUrl,
    ModelUri? forksUrl,
    ModelUri? gitCommitsUrl,
    ModelUri? gitRefsUrl,
    ModelUri? gitTagsUrl,
    ModelUri? hooksUrl,
    ModelUri? issueCommentUrl,
    ModelUri? issueEventsUrl,
    ModelUri? issuesUrl,
    ModelUri? keysUrl,
    ModelUri? labelsUrl,
    ModelUri? languagesUrl,
    ModelUri? mergesUrl,
    ModelUri? milestonesUrl,
    ModelUri? mirrorUrl,
    ModelUri? notificationsUrl,
    ModelUri? pullsUrl,
    ModelUri? releasesUrl,
    ModelUri? stargazersUrl,
    ModelUri? statusesUrl,
    ModelUri? subscribersUrl,
    ModelUri? subscriptionUrl,
    ModelUri? tagsUrl,
    ModelUri? teamsUrl,
    ModelUri? treesUrl,
    @refParam GithubRepositoryModelRef? templateRepository,
    ModelTimestamp? starredAt,
    ModelTimestamp? pushedAt,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubRepositoryModel;
  const GithubRepositoryModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubRepositoryModel.fromJson(json);
  /// ```
  factory GithubRepositoryModel.fromJson(Map<String, Object?> json) =>
      _$GithubRepositoryModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubRepositoryModel.document(id));       // Get the document.
  /// ref.app.model(GithubRepositoryModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubRepositoryModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubRepositoryModel.collection());       // Get the collection.
  /// ref.app.model(GithubRepositoryModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubRepositoryModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubRepositoryModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubRepositoryModel.form(GithubRepositoryModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubRepositoryModel.form(GithubRepositoryModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubRepositoryModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubRepositoryModel.
typedef GithubRepositoryModelKeys = _$GithubRepositoryModelKeys;

/// Alias for ModelRef&lt;GithubRepositoryModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubRepositoryModelDocument) GithubRepositoryModelRef repository
/// ```
typedef GithubRepositoryModelRef = ModelRef<GithubRepositoryModel>?;

/// It can be defined as an empty ModelRef&lt;GithubRepositoryModel&gt;.
///
/// ```dart
/// GithubRepositoryModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubRepositoryModelRefPath = _$GithubRepositoryModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubRepositoryModelInitialCollection(
///       "xxx": GithubRepositoryModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubRepositoryModelInitialCollection
    = _$GithubRepositoryModelInitialCollection;

/// Document class for storing GithubRepositoryModel.
typedef GithubRepositoryModelDocument = _$GithubRepositoryModelDocument;

/// Collection class for storing GithubRepositoryModel.
typedef GithubRepositoryModelCollection = _$GithubRepositoryModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubRepositoryModel&gt;.
///
/// ```dart
/// GithubRepositoryModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubRepositoryModelMirrorRefPath
    = _$GithubRepositoryModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubRepositoryModelMirrorInitialCollection(
///       "xxx": GithubRepositoryModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubRepositoryModelMirrorInitialCollection
    = _$GithubRepositoryModelMirrorInitialCollection;

/// Document class for storing GithubRepositoryModel.
typedef GithubRepositoryModelMirrorDocument
    = _$GithubRepositoryModelMirrorDocument;

/// Collection class for storing GithubRepositoryModel.
typedef GithubRepositoryModelMirrorCollection
    = _$GithubRepositoryModelMirrorCollection;
