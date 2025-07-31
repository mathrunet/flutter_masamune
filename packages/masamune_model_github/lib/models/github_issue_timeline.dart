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

part "github_issue_timeline.m.dart";
part "github_issue_timeline.g.dart";
part "github_issue_timeline.freezed.dart";

/// Model for managing Github issue timelines.
///
/// GithubのIssueのタイムラインを管理するためのモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/issue/:issue_id/timeline",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubIssueTimelineModel with _$GithubIssueTimelineModel {
  /// Model for managing Github issue timelines.
  ///
  /// GithubのIssueのタイムラインを管理するためのモデル。
  @JsonSerializable(explicitToJson: true)
  const factory GithubIssueTimelineModel({
    int? id,
    String? body,
    String? previousBody,
    String? authorAssociation,
    String? commitId,
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
    ModelUri? commitUrl,
    ModelUri? htmlUrl,
    ModelUri? issueUrl,
    ModelUri? links,
    ModelUri? pullRequestUrl,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubIssueTimelineModel;
  const GithubIssueTimelineModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubIssueTimelineModel.fromJson(json);
  /// ```
  factory GithubIssueTimelineModel.fromJson(Map<String, Object?> json) =>
      _$GithubIssueTimelineModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubIssueTimelineModel.document(id));       // Get the document.
  /// ref.app.model(GithubIssueTimelineModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubIssueTimelineModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubIssueTimelineModel.collection());       // Get the collection.
  /// ref.app.model(GithubIssueTimelineModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubIssueTimelineModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubIssueTimelineModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubIssueTimelineModel.form(GithubIssueTimelineModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubIssueTimelineModel.form(GithubIssueTimelineModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubIssueTimelineModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubIssueTimelineModel.
typedef GithubIssueTimelineModelKeys = _$GithubIssueTimelineModelKeys;

/// Alias for ModelRef&lt;GithubIssueTimelineModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubIssueTimelineModelDocument) GithubIssueTimelineModelRef github_issue_comment
/// ```
typedef GithubIssueTimelineModelRef = ModelRef<GithubIssueTimelineModel>?;

/// It can be defined as an empty ModelRef&lt;GithubIssueTimelineModel&gt;.
///
/// ```dart
/// GithubIssueTimelineModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubIssueTimelineModelRefPath = _$GithubIssueTimelineModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubIssueTimelineModelInitialCollection(
///       "xxx": GithubIssueTimelineModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubIssueTimelineModelInitialCollection
    = _$GithubIssueTimelineModelInitialCollection;

/// Document class for storing GithubIssueTimelineModel.
typedef GithubIssueTimelineModelDocument = _$GithubIssueTimelineModelDocument;

/// Collection class for storing GithubIssueTimelineModel.
typedef GithubIssueTimelineModelCollection
    = _$GithubIssueTimelineModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubIssueTimelineModel&gt;.
///
/// ```dart
/// GithubIssueTimelineModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubIssueTimelineModelMirrorRefPath
    = _$GithubIssueTimelineModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubIssueTimelineModelMirrorInitialCollection(
///       "xxx": GithubIssueTimelineModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubIssueTimelineModelMirrorInitialCollection
    = _$GithubIssueTimelineModelMirrorInitialCollection;

/// Document class for storing GithubIssueTimelineModel.
typedef GithubIssueTimelineModelMirrorDocument
    = _$GithubIssueTimelineModelMirrorDocument;

/// Collection class for storing GithubIssueTimelineModel.
typedef GithubIssueTimelineModelMirrorCollection
    = _$GithubIssueTimelineModelMirrorCollection;
