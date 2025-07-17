// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/models/github_repository.dart";
import "package:masamune_model_github/models/github_user.dart";

// ignore: unused_import, unnecessary_import

part "github_pull_request_head.m.dart";
part "github_pull_request_head.g.dart";
part "github_pull_request_head.freezed.dart";

/// Immutable value.
@freezed
@formValue
@immutable
abstract class GithubPullRequestHeadValue with _$GithubPullRequestHeadValue {
  /// Immutable value.
  const factory GithubPullRequestHeadValue({
    String? label,
    String? ref,
    String? sha,
    @refParam GithubUserModelRef? user,
    @refParam GithubRepositoryModelRef? repo,
  }) = _GithubPullRequestHeadValue;
  const GithubPullRequestHeadValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubPullRequestHeadValue.fromJson(json);
  /// ```
  factory GithubPullRequestHeadValue.fromJson(Map<String, Object?> json) =>
      _$GithubPullRequestHeadValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(GithubPullRequestHeadValue.form());     // Get the form controller.
  /// ```
  static const form = _$GithubPullRequestHeadValueFormQuery();
}
