// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune_model_github/models/github_user.dart";

part "github_milestone.m.dart";
part "github_milestone.g.dart";
part "github_milestone.freezed.dart";

/// Immutable value.
@freezed
@formValue
@immutable
abstract class GithubMilestoneValue with _$GithubMilestoneValue {
  /// Immutable value.
  const factory GithubMilestoneValue({
    int? id,
    int? number,
    String? state,
    String? title,
    String? description,
    String? nodeId,
    @refParam GithubUserModelRef? creator,
    @Default(0) int openIssuesCount,
    @Default(0) int closedIssuesCount,
    ModelUri? url,
    ModelUri? htmlUrl,
    ModelUri? labelsUrl,
    ModelTimestamp? dueOn,
    ModelTimestamp? closedAt,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
    @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
  }) = _GithubMilestoneValue;
  const GithubMilestoneValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubMilestoneValue.fromJson(json);
  /// ```
  factory GithubMilestoneValue.fromJson(Map<String, Object?> json) =>
      _$GithubMilestoneValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(GithubMilestoneValue.form());     // Get the form controller.
  /// ```
  static const form = _$GithubMilestoneValueFormQuery();
}
