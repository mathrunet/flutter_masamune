// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

import "package:freezed_annotation/freezed_annotation.dart";

part "github_copilot_session_log.m.dart";
part "github_copilot_session_log.g.dart";
part "github_copilot_session_log.freezed.dart";

/// Model for managing Copilot session logs.
///
/// Copilotのセッションログを管理するモデル。
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/session/:session_id/log",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubCopilotSessionLogModel
    with _$GithubCopilotSessionLogModel {
  /// Model for managing Copilot session logs.
  ///
  /// Copilotのセッションログを管理するモデル。
  const factory GithubCopilotSessionLogModel({
    required String id,
    required String sessionId,
    required String message,
    String? level,
    Map<String, dynamic>? metadata,
    String? toolName,
    String? toolResult,
    @Default(ModelTimestamp()) ModelTimestamp timestamp,
    @Default(false) bool fromServer,
  }) = _GithubCopilotSessionLogModel;
  const GithubCopilotSessionLogModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubCopilotSessionLogModel.fromJson(json);
  /// ```
  factory GithubCopilotSessionLogModel.fromJson(Map<String, Object?> json) =>
      _$GithubCopilotSessionLogModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubCopilotSessionLogModel.document(id));       // Get the document.
  /// ref.app.model(GithubCopilotSessionLogModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubCopilotSessionLogModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubCopilotSessionLogModel.collection());       // Get the collection.
  /// ref.app.model(GithubCopilotSessionLogModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubCopilotSessionLogModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubCopilotSessionLogModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubCopilotSessionLogModel.form(GithubCopilotSessionLogModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubCopilotSessionLogModel.form(GithubCopilotSessionLogModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubCopilotSessionLogModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubCopilotSessionLogModel.
typedef GithubCopilotSessionLogModelKeys = _$GithubCopilotSessionLogModelKeys;

/// Alias for ModelRef&lt;GithubCopilotSessionLogModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubCopilotSessionLogModelDocument) GithubCopilotSessionLogModelRef github_copilot_session_log
/// ```
typedef GithubCopilotSessionLogModelRef
    = ModelRef<GithubCopilotSessionLogModel>?;

/// It can be defined as an empty ModelRef&lt;GithubCopilotSessionLogModel&gt;.
///
/// ```dart
/// GithubCopilotSessionLogModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubCopilotSessionLogModelRefPath
    = _$GithubCopilotSessionLogModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubCopilotSessionLogModelInitialCollection(
///       "xxx": GithubCopilotSessionLogModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubCopilotSessionLogModelInitialCollection
    = _$GithubCopilotSessionLogModelInitialCollection;

/// Document class for storing GithubCopilotSessionLogModel.
typedef GithubCopilotSessionLogModelDocument
    = _$GithubCopilotSessionLogModelDocument;

/// Collection class for storing GithubCopilotSessionLogModel.
typedef GithubCopilotSessionLogModelCollection
    = _$GithubCopilotSessionLogModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubCopilotSessionLogModel&gt;.
///
/// ```dart
/// GithubCopilotSessionLogModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubCopilotSessionLogModelMirrorRefPath
    = _$GithubCopilotSessionLogModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubCopilotSessionLogModelMirrorInitialCollection(
///       "xxx": GithubCopilotSessionLogModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubCopilotSessionLogModelMirrorInitialCollection
    = _$GithubCopilotSessionLogModelMirrorInitialCollection;

/// Document class for storing GithubCopilotSessionLogModel.
typedef GithubCopilotSessionLogModelMirrorDocument
    = _$GithubCopilotSessionLogModelMirrorDocument;

/// Collection class for storing GithubCopilotSessionLogModel.
typedef GithubCopilotSessionLogModelMirrorCollection
    = _$GithubCopilotSessionLogModelMirrorCollection;
