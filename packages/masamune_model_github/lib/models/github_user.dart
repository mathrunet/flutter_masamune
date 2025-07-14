// ignore: unused_import, unnecessary_import

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import


part "github_user.m.dart";
part "github_user.g.dart";
part "github_user.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath("owner")
abstract class GithubUserModel with _$GithubUserModel {
  /// Value for model.
  const factory GithubUserModel({
    int? id,
    String? login,
    String? name,
    String? company,
    String? blog,
    String? bio,
    String? location,
    String? email,
    String? xUsername,
    String? nodeId,
    String? type,
    @Default(false) bool siteAdmin,
    @Default(false) bool hirable,
    @Default(0) int publicReposCount,
    @Default(0) int publicGistsCount,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    ModelImageUri? avatarUrl,
    String? gravatarId,
    ModelUri? htmlUrl,
    ModelUri? userUrl,
    ModelUri? eventsUrl,
    ModelUri? followersUrl,
    ModelUri? followingUrl,
    ModelUri? gistsUrl,
    ModelUri? organizationsUrl,
    ModelUri? receivedEventsUrl,
    ModelUri? reposUrl,
    ModelUri? starredUrl,
    ModelUri? subscriptionsUrl,
    ModelTimestamp? starredAt,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
  }) = _GithubUserModel;
  const GithubUserModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubUserModel.fromJson(json);
  /// ```
  factory GithubUserModel.fromJson(Map<String, Object?> json) =>
      _$GithubUserModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubUserModel.document(id));       // Get the document.
  /// ref.app.model(GithubUserModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubUserModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubUserModel.collection());       // Get the collection.
  /// ref.app.model(GithubUserModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubUserModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubUserModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubUserModel.form(GithubUserModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubUserModel.form(GithubUserModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubUserModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubUserModel.
typedef GithubUserModelKeys = _$GithubUserModelKeys;

/// Alias for ModelRef&lt;GithubUserModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubUserModelDocument) GithubUserModelRef owner
/// ```
typedef GithubUserModelRef = ModelRef<GithubUserModel>?;

/// It can be defined as an empty ModelRef&lt;GithubUserModel&gt;.
///
/// ```dart
/// GithubUserModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubUserModelRefPath = _$GithubUserModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubUserModelInitialCollection(
///       "xxx": GithubUserModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubUserModelInitialCollection = _$GithubUserModelInitialCollection;

/// Document class for storing GithubUserModel.
typedef GithubUserModelDocument = _$GithubUserModelDocument;

/// Collection class for storing GithubUserModel.
typedef GithubUserModelCollection = _$GithubUserModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubUserModel&gt;.
///
/// ```dart
/// GithubUserModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubUserModelMirrorRefPath = _$GithubUserModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubUserModelMirrorInitialCollection(
///       "xxx": GithubUserModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubUserModelMirrorInitialCollection
    = _$GithubUserModelMirrorInitialCollection;

/// Document class for storing GithubUserModel.
typedef GithubUserModelMirrorDocument = _$GithubUserModelMirrorDocument;

/// Collection class for storing GithubUserModel.
typedef GithubUserModelMirrorCollection = _$GithubUserModelMirrorCollection;
