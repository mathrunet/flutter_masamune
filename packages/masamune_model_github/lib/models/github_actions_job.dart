// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

part "github_actions_job.m.dart";
part "github_actions_job.g.dart";
part "github_actions_job.freezed.dart";

/// Value for model.
@freezed
@formValue
@immutable
@CollectionModelPath(
    "organization/:organization_id/repository/:repository_id/actions/:action_id/job",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubActionsJobModel with _$GithubActionsJobModel {
  /// Value for model.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GithubActionsJobModel({
    int? id,
    int? runId,
    int? runAttempt,
    String? name,
    String? runnerName,
    int? runnerId,
    int? runnerGroupId,
    String? status,
    String? conclusion,
    @Default(<String>[]) List<String> labels,
    @jsonParam GithubUserModel? runner,
    @Default(<GithubActionsStepValue>[])
    @jsonParam
    List<GithubActionsStepValue> steps,
    ModelUri? url,
    ModelUri? htmlUrl,
    ModelUri? logsUrl,
    ModelTimestamp? startedAt,
    ModelTimestamp? completedAt,
    @Default(false) bool fromServer,
  }) = _GithubActionsJobModel;
  const GithubActionsJobModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubActionsJobModel.fromJson(json);
  /// ```
  factory GithubActionsJobModel.fromJson(Map<String, Object?> json) =>
      _$GithubActionsJobModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubActionsJobModel.document(id));       // Get the document.
  /// ref.app.model(GithubActionsJobModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubActionsJobModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(GithubActionsJobModel.collection());       // Get the collection.
  /// ref.app.model(GithubActionsJobModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   GithubActionsJobModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$GithubActionsJobModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubActionsJobModel.form(GithubActionsJobModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubActionsJobModel.form(GithubActionsJobModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubActionsJobModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubActionsJobModel.
typedef GithubActionsJobModelKeys = _$GithubActionsJobModelKeys;

/// Alias for ModelRef&lt;GithubActionsJobModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubActionsJobModelDocument) GithubActionsJobModelRef github_actions_job
/// ```
typedef GithubActionsJobModelRef = ModelRef<GithubActionsJobModel>?;

/// It can be defined as an empty ModelRef&lt;GithubActionsJobModel&gt;.
///
/// ```dart
/// GithubActionsJobModelRefPath("xxx") // Define as a path.
/// ```
typedef GithubActionsJobModelRefPath = _$GithubActionsJobModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubActionsJobModelInitialCollection(
///       "xxx": GithubActionsJobModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubActionsJobModelInitialCollection
    = _$GithubActionsJobModelInitialCollection;

/// Document class for storing GithubActionsJobModel.
typedef GithubActionsJobModelDocument = _$GithubActionsJobModelDocument;

/// Collection class for storing GithubActionsJobModel.
typedef GithubActionsJobModelCollection = _$GithubActionsJobModelCollection;

/// It can be defined as an empty ModelRef&lt;GithubActionsJobModel&gt;.
///
/// ```dart
/// GithubActionsJobModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef GithubActionsJobModelMirrorRefPath
    = _$GithubActionsJobModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     GithubActionsJobModelMirrorInitialCollection(
///       "xxx": GithubActionsJobModel(...),
///     ),
///   ],
/// );
/// ```
typedef GithubActionsJobModelMirrorInitialCollection
    = _$GithubActionsJobModelMirrorInitialCollection;

/// Document class for storing GithubActionsJobModel.
typedef GithubActionsJobModelMirrorDocument
    = _$GithubActionsJobModelMirrorDocument;

/// Collection class for storing GithubActionsJobModel.
typedef GithubActionsJobModelMirrorCollection
    = _$GithubActionsJobModelMirrorCollection;

/// Value for representing each step executed within a Github Action job.
@freezed
@formValue
@immutable
abstract class GithubActionsStepValue with _$GithubActionsStepValue {
  /// Value for representing each step executed within a Github Action job.
  const factory GithubActionsStepValue({
    int? number,
    String? name,
    String? status,
    String? conclusion,
    ModelTimestamp? startedAt,
    ModelTimestamp? completedAt,
  }) = _GithubActionsStepValue;
  const GithubActionsStepValue._();

  /// Convert from JSON.
  factory GithubActionsStepValue.fromJson(Map<String, Object?> json) =>
      _$GithubActionsStepValueFromJson(json);

  /// Query for form value.
  static const form = _$GithubActionsStepValueFormQuery();
}
