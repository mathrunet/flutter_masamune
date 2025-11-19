// ignore: unused_import, unnecessary_import

// ignore_for_file: invalid_annotation_target

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/masamune_model_github.dart";

// ignore: unused_import, unnecessary_import

part "github_compare.m.dart";
part "github_compare.g.dart";
part "github_compare.freezed.dart";

/// Model for managing Github branch comparisons.
///
/// Githubのブランチ比較を管理するためのモデル。
@freezed
@formValue
@immutable
@DocumentModelPath(
    "organization/:organization_id/repository/:repository_id/compare/:compare_id",
    adapter: "GithubModelMasamuneAdapter.primary.modelAdapter")
abstract class GithubCompareModel with _$GithubCompareModel {
  /// Model for managing Github branch comparisons.
  ///
  /// Githubのブランチ比較を管理するためのモデル。
  @JsonSerializable(explicitToJson: true)
  const factory GithubCompareModel({
    /// Comparison status (behind, ahead, identical, diverged)
    String? status,

    /// How many commits ahead
    @Default(0) int aheadBy,

    /// How many commits behind
    @Default(0) int behindBy,

    /// Total commits in comparison
    @Default(0) int totalCommits,

    /// Merge base commit (divergence point)
    @jsonParam GithubCommitModel? mergeBaseCommit,

    /// Base commit
    @jsonParam GithubCommitModel? baseCommit,

    /// Commits in the comparison
    @jsonParam @Default([]) List<GithubCommitModel> commits,

    /// URL for diff
    ModelUri? diffUrl,

    /// URL for patch
    ModelUri? patchUrl,

    /// HTML URL
    ModelUri? htmlUrl,

    /// Permalink URL
    ModelUri? permalinkUrl,
    @Default(false) bool fromServer,
  }) = _GithubCompareModel;
  const GithubCompareModel._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubCompareModel.fromJson(json);
  /// ```
  factory GithubCompareModel.fromJson(Map<String, Object?> json) =>
      _$GithubCompareModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(GithubCompareModel.document(id));       // Get the document.
  /// ref.app.model(GithubCompareModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$GithubCompareModelDocumentQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(GithubCompareModel.form(GithubCompareModel()));    // Get the form controller in app scope.
  /// ref.page.form(GithubCompareModel.form(GithubCompareModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$GithubCompareModelFormQuery();
}

/// [Enum] of the name of the value defined in GithubCompareModel.
typedef GithubCompareModelKeys = _$GithubCompareModelKeys;

/// Alias for ModelRef&lt;GithubCompareModel&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(GithubCompareModelDocument) GithubCompareModelRef github_compare
/// ```
typedef GithubCompareModelRef = ModelRef<GithubCompareModel>?;
