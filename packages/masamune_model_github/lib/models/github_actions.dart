// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

part "github_actions.m.dart";
part "github_actions.g.dart";
part "github_actions.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/actions",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubActionsModel with _$GithubActionsModel {
  /// Value for model.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GithubActionsModel({
    int? id,
    int? workflowId,
    int? runNumber,
    int? runAttempt,
    String? name,
    String? displayTitle,
    String? event,
    String? status,
    String? conclusion,
    String? headBranch,
    String? headSha,
    String? path,
    @jsonParam GithubUserModel? actor,
    @jsonParam GithubUserModel? triggeringActor,
    @refParam GithubRepositoryModelRef? repository,
    ModelUri? url,
    ModelUri? htmlUrl,
    ModelUri? jobsUrl,
    ModelUri? logsUrl,
    ModelUri? artifactsUrl,
    ModelUri? cancelUrl,
    ModelUri? rerunUrl,
    ModelUri? workflowUrl,
    ModelUri? checkSuiteUrl,
    ModelUri? previousAttemptUrl,
    ModelTimestamp? runStartedAt,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
    @Default(false) bool fromServer,
  }) = _GithubActionsModel;
  const GithubActionsModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubActionsModel.fromJson(json);
  /// ```
  factory GithubActionsModel.fromJson(Map<String, Object?> json) =>
      _$GithubActionsModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubActionsModel.document(id));       // Get the document.
  /// ref.app.model(GithubActionsModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubActionsModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubActionsModel.collection());       // Get the collection.
  /// ref.app.model(GithubActionsModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubActionsModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubActionsModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubActionsModel.form(GithubActionsModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubActionsModel.form(GithubActionsModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubActionsModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubActionsModel.
typedef GithubActionsModelKeys = _$GithubActionsModelKeys;

/// Alias for ModelRef&lt;GithubActionsModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubActionsModelDocument) GithubActionsModelRef github_actions
/// ```
typedef GithubActionsModelRef = ModelRef<GithubActionsModel>?;

/// It can be defined as an empty ModelRef&lt;GithubActionsModel&gt;.
///
/// ```dart
/// GithubActionsModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubActionsModelRefPath = _$GithubActionsModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubActionsModelInitialCollection(
///       "xxx": GithubActionsModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubActionsModelInitialCollection
    = _$GithubActionsModelInitialCollection;

/// Document class for storing GithubActionsModel.
typedef GithubActionsModelDocument = _$GithubActionsModelDocument;

/// Collection class for storing GithubActionsModel.
typedef GithubActionsModelCollection = _$GithubActionsModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubActionsModel&gt;.
///
/// ```dart
/// GithubActionsModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubActionsModelMirrorRefPath = _$GithubActionsModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubActionsModelMirrorInitialCollection(
///       "xxx": GithubActionsModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubActionsModelMirrorInitialCollection
    = _$GithubActionsModelMirrorInitialCollection;

/// Document class for storing GithubActionsModel.
typedef GithubActionsModelMirrorDocument = _$GithubActionsModelMirrorDocument;

/// Collection class for storing GithubActionsModel.
typedef GithubActionsModelMirrorCollection
    = _$GithubActionsModelMirrorCollection;
