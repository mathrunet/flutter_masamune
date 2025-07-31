// ignore: unused_import, unnecessary_import

// Flutter imports:

// ignore_for_file: invalid_annotation_target

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";
import "package:masamune_model_github/models/github_project.dart";

// ignore: unused_import, unnecessary_import

part "github_pull_request_timeline.m.dart";
part "github_pull_request_timeline.g.dart";
part "github_pull_request_timeline.freezed.dart";

/// Model for managing Github pull request timelines.
///
/// GithubのPull Requestのタイムラインを管理するためのモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/pull_request/:pull_request_id/timeline",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubPullRequestTimelineModel
    with _$GithubPullRequestTimelineModel {
  /// Model for managing Github pull request timelines.
  ///
  /// GithubのPull Requestのタイムラインを管理するためのモデル。
  @JsonSerializable(explicitToJson: true)
  const factory GithubPullRequestTimelineModel({
    int? id,
    String? body,
    String? previousBody,
    String? diffHunk,
    String? path,
    int? position,
    int? originalPosition,
    String? commitId,
    String? originalCommitId,
    String? sha,
    String? state,
    int? reviewId,
    @Default(GithubTimelineEvent.unknown) GithubTimelineEvent event,
    @jsonParam GithubUserModel? user,
    @jsonParam GithubUserModel? from,
    @jsonParam GithubUserModel? to,
    @jsonParam GithubProjectModel? project,
    @jsonParam GithubMilestoneValue? milestone,
    @jsonParam GithubReactionValue? reaction,
    @jsonParam GithubIssueModel? issue,
    @jsonParam GithubPullRequestModel? pullRequest,
    @jsonParam GithubLabelValue? label,
    ModelUri? url,
    ModelUri? pullRequestUrl,
    ModelUri? commitUrl,
    ModelUri? links,
    ModelUri? issueUrl,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubPullRequestTimelineModel;
  const GithubPullRequestTimelineModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubPullRequestTimelineModel.fromJson(json);
  /// ```
  factory GithubPullRequestTimelineModel.fromJson(Map<String, Object?> json) =>
      _$GithubPullRequestTimelineModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubPullRequestTimelineModel.document(id));       // Get the document.
  /// ref.app.model(GithubPullRequestTimelineModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubPullRequestTimelineModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubPullRequestTimelineModel.collection());       // Get the collection.
  /// ref.app.model(GithubPullRequestTimelineModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubPullRequestTimelineModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubPullRequestTimelineModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubPullRequestTimelineModel.form(GithubPullRequestTimelineModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubPullRequestTimelineModel.form(GithubPullRequestTimelineModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubPullRequestTimelineModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubPullRequestTimelineModel.
typedef GithubPullRequestTimelineModelKeys
    = _$GithubPullRequestTimelineModelKeys;

/// Alias for ModelRef&lt;GithubPullRequestTimelineModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubPullRequestTimelineModelDocument) GithubPullRequestTimelineModelRef github_pull_request_comment
/// ```
typedef GithubPullRequestTimelineModelRef
    = ModelRef<GithubPullRequestTimelineModel>?;

/// It can be defined as an empty ModelRef&lt;GithubPullRequestTimelineModel&gt;.
///
/// ```dart
/// GithubPullRequestTimelineModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubPullRequestTimelineModelRefPath
    = _$GithubPullRequestTimelineModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubPullRequestTimelineModelInitialCollection(
///       "xxx": GithubPullRequestTimelineModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubPullRequestTimelineModelInitialCollection
    = _$GithubPullRequestTimelineModelInitialCollection;

/// Document class for storing GithubPullRequestTimelineModel.
typedef GithubPullRequestTimelineModelDocument
    = _$GithubPullRequestTimelineModelDocument;

/// Collection class for storing GithubPullRequestTimelineModel.
typedef GithubPullRequestTimelineModelCollection
    = _$GithubPullRequestTimelineModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubPullRequestTimelineModel&gt;.
///
/// ```dart
/// GithubPullRequestTimelineModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubPullRequestTimelineModelMirrorRefPath
    = _$GithubPullRequestTimelineModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubPullRequestTimelineModelMirrorInitialCollection(
///       "xxx": GithubPullRequestTimelineModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubPullRequestTimelineModelMirrorInitialCollection
    = _$GithubPullRequestTimelineModelMirrorInitialCollection;

/// Document class for storing GithubPullRequestTimelineModel.
typedef GithubPullRequestTimelineModelMirrorDocument
    = _$GithubPullRequestTimelineModelMirrorDocument;

/// Collection class for storing GithubPullRequestTimelineModel.
typedef GithubPullRequestTimelineModelMirrorCollection
    = _$GithubPullRequestTimelineModelMirrorCollection;
