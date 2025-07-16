// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_model_github/models/github_commit.dart";

part "github_branch.m.dart";
part "github_branch.g.dart";
part "github_branch.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/branch")
abstract class GithubBranchModel with _$GithubBranchModel {
  /// Value for model.
  const factory GithubBranchModel({
    String? name,
    @jsonParam GithubCommitModel? commit,
    @refParam GithubBranchModelRef baseRef,
    @Default(false) bool fromServer,
  }) = _GithubBranchModel;
  const GithubBranchModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubBranchModel.fromJson(json);
  /// ```
  factory GithubBranchModel.fromJson(Map<String, Object?> json) =>
      _$GithubBranchModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubBranchModel.document(id));       // Get the document.
  /// ref.app.model(GithubBranchModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubBranchModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubBranchModel.collection());       // Get the collection.
  /// ref.app.model(GithubBranchModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubBranchModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubBranchModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubBranchModel.form(GithubBranchModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubBranchModel.form(GithubBranchModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubBranchModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubBranchModel.
typedef GithubBranchModelKeys = _$GithubBranchModelKeys;

/// Alias for ModelRef&lt;GithubBranchModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubBranchModelDocument) GithubBranchModelRef github_branch
/// ```
typedef GithubBranchModelRef = ModelRef<GithubBranchModel>?;

/// It can be defined as an empty ModelRef&lt;GithubBranchModel&gt;.
///
/// ```dart
/// GithubBranchModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubBranchModelRefPath = _$GithubBranchModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubBranchModelInitialCollection(
///       "xxx": GithubBranchModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubBranchModelInitialCollection
    = _$GithubBranchModelInitialCollection;

/// Document class for storing GithubBranchModel.
typedef GithubBranchModelDocument = _$GithubBranchModelDocument;

/// Collection class for storing GithubBranchModel.
typedef GithubBranchModelCollection = _$GithubBranchModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubBranchModel&gt;.
///
/// ```dart
/// GithubBranchModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubBranchModelMirrorRefPath = _$GithubBranchModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubBranchModelMirrorInitialCollection(
///       "xxx": GithubBranchModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubBranchModelMirrorInitialCollection
    = _$GithubBranchModelMirrorInitialCollection;

/// Document class for storing GithubBranchModel.
typedef GithubBranchModelMirrorDocument = _$GithubBranchModelMirrorDocument;

/// Collection class for storing GithubBranchModel.
typedef GithubBranchModelMirrorCollection = _$GithubBranchModelMirrorCollection;
