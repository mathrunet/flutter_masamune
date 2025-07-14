// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

import "package:freezed_annotation/freezed_annotation.dart";

part "github_label.m.dart";
part "github_label.g.dart";
part "github_label.freezed.dart";

/// Immutable value.
@freezed
@formValue
@immutable
abstract class GithubLabelValue with _$GithubLabelValue {
  /// Immutable value.
  const factory GithubLabelValue({
    String? name,
    String? color,
    String? description,
  }) = _GithubLabelValue;
  const GithubLabelValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubLabelValue.fromJson(json);
  /// ```
  factory GithubLabelValue.fromJson(Map<String, Object?> json) =>
      _$GithubLabelValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(GithubLabelValue.form());     // Get the form controller.
  /// ```
  static const form = _$GithubLabelValueFormQuery();
}
