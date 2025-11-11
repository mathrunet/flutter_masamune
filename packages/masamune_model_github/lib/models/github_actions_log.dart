// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

part "github_actions_log.m.dart";
part "github_actions_log.g.dart";
part "github_actions_log.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/actions/:action_id/job/:job_id/log",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubActionsLogModel with _$GithubActionsLogModel {
  /// Value for model.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GithubActionsLogModel({
    int? runId,
    int? jobId,
    int? chunk,
    String? name,
    ModelUri? downloadUrl,
    @Default("") String text,
    ModelTimestamp? createdAt,
    @Default(false) bool fromServer,
  }) = _GithubActionsLogModel;
  const GithubActionsLogModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubActionsLogModel.fromJson(json);
  /// ```
  factory GithubActionsLogModel.fromJson(Map<String, Object?> json) =>
      _$GithubActionsLogModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubActionsLogModel.document(id));       // Get the document.
  /// ref.app.model(GithubActionsLogModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubActionsLogModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubActionsLogModel.collection());       // Get the collection.
  /// ref.app.model(GithubActionsLogModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubActionsLogModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubActionsLogModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubActionsLogModel.form(GithubActionsLogModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubActionsLogModel.form(GithubActionsLogModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubActionsLogModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubActionsLogModel.
typedef GithubActionsLogModelKeys = _$GithubActionsLogModelKeys;

/// Alias for ModelRef&lt;GithubActionsLogModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubActionsLogModelDocument) GithubActionsLogModelRef github_actions_log
/// ```
typedef GithubActionsLogModelRef = ModelRef<GithubActionsLogModel>?;

/// It can be defined as an empty ModelRef&lt;GithubActionsLogModel&gt;.
///
/// ```dart
/// GithubActionsLogModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubActionsLogModelRefPath = _$GithubActionsLogModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubActionsLogModelInitialCollection(
///       "xxx": GithubActionsLogModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubActionsLogModelInitialCollection
    = _$GithubActionsLogModelInitialCollection;

/// Document class for storing GithubActionsLogModel.
typedef GithubActionsLogModelDocument = _$GithubActionsLogModelDocument;

/// Collection class for storing GithubActionsLogModel.
typedef GithubActionsLogModelCollection = _$GithubActionsLogModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubActionsLogModel&gt;.
///
/// ```dart
/// GithubActionsLogModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubActionsLogModelMirrorRefPath
    = _$GithubActionsLogModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubActionsLogModelMirrorInitialCollection(
///       "xxx": GithubActionsLogModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubActionsLogModelMirrorInitialCollection
    = _$GithubActionsLogModelMirrorInitialCollection;

/// Document class for storing GithubActionsLogModel.
typedef GithubActionsLogModelMirrorDocument
    = _$GithubActionsLogModelMirrorDocument;

/// Collection class for storing GithubActionsLogModel.
typedef GithubActionsLogModelMirrorCollection
    = _$GithubActionsLogModelMirrorCollection;
