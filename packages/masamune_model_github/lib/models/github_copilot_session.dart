// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

import "package:freezed_annotation/freezed_annotation.dart";

part "github_copilot_session.m.dart";
part "github_copilot_session.g.dart";
part "github_copilot_session.freezed.dart";

/// Model for managing Copilot sessions.
///
/// Copilotのセッションを管理するモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/session",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubCopilotSessionModel with _$GithubCopilotSessionModel {
  /// Model for managing Copilot sessions.
  ///
  /// Copilotのセッションを管理するモデル。
  const factory GithubCopilotSessionModel({
    required String id,
    required String state,
    String? name,
    String? resourceType,
    String? resourceId,
    String? userId,
    String? agentId,
    String? errorMessage,
    String? errorCode,
    int? pullRequestNumber,
    String? pullRequestUrl,
    String? pullRequestId,
    String? pullRequestBaseRef,
    ModelTimestamp? completedAt,
    @Default(ModelTimestamp()) ModelTimestamp createdAt,
    @Default(ModelTimestamp()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubCopilotSessionModel;
  const GithubCopilotSessionModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubCopilotSessionModel.fromJson(json);
  /// ```
  factory GithubCopilotSessionModel.fromJson(Map<String, Object?> json) =>
      _$GithubCopilotSessionModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubCopilotSessionModel.document(id));       // Get the document.
  /// ref.app.model(GithubCopilotSessionModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubCopilotSessionModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubCopilotSessionModel.collection());       // Get the collection.
  /// ref.app.model(GithubCopilotSessionModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubCopilotSessionModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubCopilotSessionModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubCopilotSessionModel.form(GithubCopilotSessionModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubCopilotSessionModel.form(GithubCopilotSessionModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubCopilotSessionModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubCopilotSessionModel.
typedef GithubCopilotSessionModelKeys = _$GithubCopilotSessionModelKeys;

/// Alias for ModelRef&lt;GithubCopilotSessionModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubCopilotSessionModelDocument) GithubCopilotSessionModelRef github_copilot_session
/// ```
typedef GithubCopilotSessionModelRef = ModelRef<GithubCopilotSessionModel>?;

/// It can be defined as an empty ModelRef&lt;GithubCopilotSessionModel&gt;.
///
/// ```dart
/// GithubCopilotSessionModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubCopilotSessionModelRefPath = _$GithubCopilotSessionModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubCopilotSessionModelInitialCollection(
///       "xxx": GithubCopilotSessionModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubCopilotSessionModelInitialCollection
    = _$GithubCopilotSessionModelInitialCollection;

/// Document class for storing GithubCopilotSessionModel.
typedef GithubCopilotSessionModelDocument = _$GithubCopilotSessionModelDocument;

/// Collection class for storing GithubCopilotSessionModel.
typedef GithubCopilotSessionModelCollection
    = _$GithubCopilotSessionModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubCopilotSessionModel&gt;.
///
/// ```dart
/// GithubCopilotSessionModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubCopilotSessionModelMirrorRefPath
    = _$GithubCopilotSessionModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubCopilotSessionModelMirrorInitialCollection(
///       "xxx": GithubCopilotSessionModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubCopilotSessionModelMirrorInitialCollection
    = _$GithubCopilotSessionModelMirrorInitialCollection;

/// Document class for storing GithubCopilotSessionModel.
typedef GithubCopilotSessionModelMirrorDocument
    = _$GithubCopilotSessionModelMirrorDocument;

/// Collection class for storing GithubCopilotSessionModel.
typedef GithubCopilotSessionModelMirrorCollection
    = _$GithubCopilotSessionModelMirrorCollection;
