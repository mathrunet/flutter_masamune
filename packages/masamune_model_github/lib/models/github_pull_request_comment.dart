// ignore: unused_import, unnecessary_import

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/models/github_user.dart";

// ignore: unused_import, unnecessary_import

part "github_pull_request_comment.m.dart";
part "github_pull_request_comment.g.dart";
part "github_pull_request_comment.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/pull_request/:pull_request_id/comment")
abstract class GithubPullRequestCommentModel
    with _$GithubPullRequestCommentModel {
  /// Value for model.
  const factory GithubPullRequestCommentModel({
    int? id,
    String? body,
    String? diffHunk,
    String? path,
    int? position,
    int? originalPosition,
    String? commitId,
    String? originalCommitId,
    @refParam GithubUserModelRef? user,
    ModelUri? url,
    ModelUri? pullRequestUrl,
    ModelUri? links,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubPullRequestCommentModel;
  const GithubPullRequestCommentModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubPullRequestCommentModel.fromJson(json);
  /// ```
  factory GithubPullRequestCommentModel.fromJson(Map<String, Object?> json) =>
      _$GithubPullRequestCommentModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubPullRequestCommentModel.document(id));       // Get the document.
  /// ref.app.model(GithubPullRequestCommentModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubPullRequestCommentModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubPullRequestCommentModel.collection());       // Get the collection.
  /// ref.app.model(GithubPullRequestCommentModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubPullRequestCommentModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubPullRequestCommentModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubPullRequestCommentModel.form(GithubPullRequestCommentModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubPullRequestCommentModel.form(GithubPullRequestCommentModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubPullRequestCommentModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubPullRequestCommentModel.
typedef GithubPullRequestCommentModelKeys = _$GithubPullRequestCommentModelKeys;

/// Alias for ModelRef&lt;GithubPullRequestCommentModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubPullRequestCommentModelDocument) GithubPullRequestCommentModelRef github_pull_request_comment
/// ```
typedef GithubPullRequestCommentModelRef
    = ModelRef<GithubPullRequestCommentModel>?;

/// It can be defined as an empty ModelRef&lt;GithubPullRequestCommentModel&gt;.
///
/// ```dart
/// GithubPullRequestCommentModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubPullRequestCommentModelRefPath
    = _$GithubPullRequestCommentModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubPullRequestCommentModelInitialCollection(
///       "xxx": GithubPullRequestCommentModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubPullRequestCommentModelInitialCollection
    = _$GithubPullRequestCommentModelInitialCollection;

/// Document class for storing GithubPullRequestCommentModel.
typedef GithubPullRequestCommentModelDocument
    = _$GithubPullRequestCommentModelDocument;

/// Collection class for storing GithubPullRequestCommentModel.
typedef GithubPullRequestCommentModelCollection
    = _$GithubPullRequestCommentModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubPullRequestCommentModel&gt;.
///
/// ```dart
/// GithubPullRequestCommentModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubPullRequestCommentModelMirrorRefPath
    = _$GithubPullRequestCommentModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubPullRequestCommentModelMirrorInitialCollection(
///       "xxx": GithubPullRequestCommentModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubPullRequestCommentModelMirrorInitialCollection
    = _$GithubPullRequestCommentModelMirrorInitialCollection;

/// Document class for storing GithubPullRequestCommentModel.
typedef GithubPullRequestCommentModelMirrorDocument
    = _$GithubPullRequestCommentModelMirrorDocument;

/// Collection class for storing GithubPullRequestCommentModel.
typedef GithubPullRequestCommentModelMirrorCollection
    = _$GithubPullRequestCommentModelMirrorCollection;
