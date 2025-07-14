// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";

part "github_reaction.m.dart";
part "github_reaction.g.dart";
part "github_reaction.freezed.dart";

/// Immutable value.
@freezed
@formValue
@immutable
abstract class GithubReactionValue with _$GithubReactionValue {
  /// Immutable value.
  const factory GithubReactionValue({
    int? plusOne,
    int? minusOne,
    int? confused,
    int? eyes,
    int? heart,
    int? hooray,
    int? laugh,
    int? rocket,
    @Default(0) int totalCount,
    ModelUri? url,
  }) = _GithubReactionValue;
  const GithubReactionValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubReactionValue.fromJson(json);
  /// ```
  factory GithubReactionValue.fromJson(Map<String, Object?> json) =>
      _$GithubReactionValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(GithubReactionValue.form());     // Get the form controller.
  /// ```
  static const form = _$GithubReactionValueFormQuery();
}
