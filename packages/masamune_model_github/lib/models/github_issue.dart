// ignore: unused_import, unnecessary_import

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/models/github_label.dart";
import "package:masamune_model_github/models/github_reaction.dart";
import "package:masamune_model_github/models/github_repository.dart";
import "package:masamune_model_github/models/github_user.dart";

part "github_issue.m.dart";
part "github_issue.g.dart";
part "github_issue.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/issue")
abstract class GithubIssueModel with _$GithubIssueModel {
  /// Value for model.
  const factory GithubIssueModel({
    int? id,
    int? number,
    String? title,
    String? body,
    String? bodyHtml,
    String? bodyText,
    String? state,
    String? stateReason,
    String? activeLockReason,
    String? authorAssociation,
    String? nodeId,
    @Default(false) bool draft,
    @Default(false) bool locked,
    @Default(0) int commentsCount,
    @refParam GithubRepositoryModelRef? repository,
    @refParam GithubUserModelRef? user,
    @refParam GithubUserModelRef? assignee,
    @Default([]) @refParam List<GithubUserModelRef> assignees,
    @refParam GithubUserModelRef? closedBy,
    @jsonParam @Default(<GithubLabelValue>[]) List<GithubLabelValue> labels,
    ModelUri? url,
    ModelUri? htmlUrl,
    ModelUri? commentsUrl,
    ModelUri? eventsUrl,
    ModelUri? labelsUrl,
    ModelUri? repositoryUrl,
    ModelUri? timelineUrl,
    @jsonParam GithubReactionValue? reactions,
    ModelTimestamp? closedAt,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubIssueModel;
  const GithubIssueModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubIssueModel.fromJson(json);
  /// ```
  factory GithubIssueModel.fromJson(Map<String, Object?> json) =>
      _$GithubIssueModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubIssueModel.document(id));       // Get the document.
  /// ref.app.model(GithubIssueModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubIssueModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubIssueModel.collection());       // Get the collection.
  /// ref.app.model(GithubIssueModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubIssueModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubIssueModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubIssueModel.form(GithubIssueModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubIssueModel.form(GithubIssueModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubIssueModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubIssueModel.
typedef GithubIssueModelKeys = _$GithubIssueModelKeys;

/// Alias for ModelRef&lt;GithubIssueModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubIssueModelDocument) GithubIssueModelRef issue
/// ```
typedef GithubIssueModelRef = ModelRef<GithubIssueModel>?;

/// It can be defined as an empty ModelRef&lt;GithubIssueModel&gt;.
///
/// ```dart
/// GithubIssueModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubIssueModelRefPath = _$GithubIssueModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubIssueModelInitialCollection(
///       "xxx": GithubIssueModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubIssueModelInitialCollection = _$GithubIssueModelInitialCollection;

/// Document class for storing GithubIssueModel.
typedef GithubIssueModelDocument = _$GithubIssueModelDocument;

/// Collection class for storing GithubIssueModel.
typedef GithubIssueModelCollection = _$GithubIssueModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubIssueModel&gt;.
///
/// ```dart
/// GithubIssueModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubIssueModelMirrorRefPath = _$GithubIssueModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubIssueModelMirrorInitialCollection(
///       "xxx": GithubIssueModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubIssueModelMirrorInitialCollection
    = _$GithubIssueModelMirrorInitialCollection;

/// Document class for storing GithubIssueModel.
typedef GithubIssueModelMirrorDocument = _$GithubIssueModelMirrorDocument;

/// Collection class for storing GithubIssueModel.
typedef GithubIssueModelMirrorCollection = _$GithubIssueModelMirrorCollection;
