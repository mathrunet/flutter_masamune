part of "code.dart";

/// Create a base class for Immutable values.
///
/// Immutableな値のベースクラスを作成します。
class CodeValueCliCommand extends CliCodeCommand {
  /// Create a base class for Immutable values.
  ///
  /// Immutableな値のベースクラスを作成します。
  const CodeValueCliCommand();

  @override
  String get name => "value";

  @override
  String get prefix => "value";

  @override
  String get directory => "lib/models";

  @override
  String get description =>
      "Create a base class for Immutable value in `$directory/(filepath).dart`. Immutableな値のベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code value [model_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code value [path]\r\n",
      );
      return;
    }
    label("Create a Immutable value class in `$directory/$path.dart`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path);
    await const CodeValueExtensionCliCommand()
        .generateDartCode("$directory/$path.extensions", path);
  }

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
part '$baseName.extensions.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Immutable value.
@freezed
@formValue
@immutable
abstract class ${className}Value with _\$${className}Value {
  const factory ${className}Value({
     // TODO: Set the data schema.
     \${2}
  }) = _${className}Value;
  const ${className}Value._();

  factory ${className}Value.fromJson(Map<String, Object?> json) => _\$${className}ValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.form(${className}Value.form());     // Get the form controller.
  /// ```
  static const form = _\$${className}ValueFormQuery();
}
""";
  }
}

/// Generates code to define an Extension corresponding to [CodeValueCliCommand].
///
/// [CodeValueCliCommand]に対応するExtensionを記載するコードを生成します。
class CodeValueExtensionCliCommand extends CliCode {
  /// Generates code to define an Extension corresponding to [CodeDocumentCliCommand].
  ///
  /// [CodeValueCliCommand]に対応するExtensionを記載するコードを生成します。
  const CodeValueExtensionCliCommand();

  @override
  String get name => "main";

  @override
  String get prefix => "main";

  @override
  String get directory => "lib/models";

  @override
  String get description => "";

  @override
  String import(String path, String baseName, String className) {
    return """
part of '$baseName.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Extension for ${className}Value.
extension ${className}ValueExtensions on ${className}Value {
  // TODO: Define the extension method.

  /// Convert to a tile widget.
  ///
  /// ```dart
  /// value.toTile(context);
  /// ```
  Widget toTile(BuildContext context) {
    return const ListTile();
  }
}
""";
  }
}
