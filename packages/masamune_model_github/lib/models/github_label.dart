// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import

part "github_label.m.dart";
part "github_label.g.dart";
part "github_label.freezed.dart";

/// Model for managing Github labels.
///
/// Githubのラベルを管理するためのモデル。
@freezed
@formValue
@immutable
abstract class GithubLabelValue with _$GithubLabelValue {
  /// Model for managing Github labels.
  ///
  /// Githubのラベルを管理するためのモデル。
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
