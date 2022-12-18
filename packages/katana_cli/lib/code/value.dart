part of katana_cli;

/// Immutable value code base.
///
/// Immutableな値のコードベース。
class ValueCliCode extends CliCode {
  /// Immutable value code base.
  ///
  /// Immutableな値のコードベース。
  const ValueCliCode();

  @override
  String get name => "value";

  @override
  String get prefix => "value";

  @override
  String get directory => "lib/models";

  @override
  String get description =>
      "Create an Immutable data class that can be used in various places. The class name will be [(filename)Value]. 様々なところで利用可能なImmutableなデータクラスを作成します。クラス名は[(ファイル名)Value]となります。";

  @override
  String import(String path, String baseName, String className) {
    return """
// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
import 'package:freezed_annotation/freezed_annotation.dart';

part '$baseName.m.dart';
part '$baseName.g.dart';
part '$baseName.freezed.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Immutable value.
@freezed
@formValue
@immutable
class ${className}Value with _\$${className}Value {
  const factory ${className}Value({
     // TODO: Set the data schema.
     \${2}
  }) = _${className}Value;
  const ${className}Value._();

  factory ${className}Value.fromJson(Map<String, Object?> json) => _\$${className}ValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(${className}Value.form());     // Get the form controller.
  /// ```
  static const form = _\$${className}ValueFormQuery();
}
""";
  }
}
