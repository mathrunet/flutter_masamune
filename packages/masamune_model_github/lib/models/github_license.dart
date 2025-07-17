// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import

part "github_license.m.dart";
part "github_license.g.dart";
part "github_license.freezed.dart";

/// Immutable value.
@freezed
@formValue
@immutable
abstract class GithubLicenseValue with _$GithubLicenseValue {
  /// Immutable value.
  const factory GithubLicenseValue({
    String? key,
    String? name,
    String? spdxId,
    ModelUri? url,
    String? nodeId,
  }) = _GithubLicenseValue;
  const GithubLicenseValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubLicenseValue.fromJson(json);
  /// ```
  factory GithubLicenseValue.fromJson(Map<String, Object?> json) =>
      _$GithubLicenseValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(GithubLicenseValue.form());     // Get the form controller.
  /// ```
  static const form = _$GithubLicenseValueFormQuery();
}
