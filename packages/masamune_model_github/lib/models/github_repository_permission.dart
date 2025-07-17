// ignore: unused_import, unnecessary_import

// Flutter imports:

// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import

part "github_repository_permission.m.dart";
part "github_repository_permission.g.dart";
part "github_repository_permission.freezed.dart";

/// Immutable value.
@freezed
@formValue
@immutable
abstract class GithubRepositoryPermissionValue
    with _$GithubRepositoryPermissionValue {
  /// Immutable value.
  const factory GithubRepositoryPermissionValue({
    @Default(false) bool admin,
    @Default(false) bool push,
    @Default(false) bool pull,
  }) = _GithubRepositoryPermissionValue;
  const GithubRepositoryPermissionValue._();

  /// Convert from JSON.
  ///
  /// ```dart
  /// GithubRepositoryPermissionValue.fromJson(json);
  /// ```
  factory GithubRepositoryPermissionValue.fromJson(Map<String, Object?> json) =>
      _$GithubRepositoryPermissionValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(GithubRepositoryPermissionValue.form());     // Get the form controller.
  /// ```
  static const form = _$GithubRepositoryPermissionValueFormQuery();
}
