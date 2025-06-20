part of "code.dart";

/// Create an Enum base.
///
/// Enumのベースを作成します。
class CodeEnumCliCommand extends CliCodeCommand {
  /// Create an Enum base.
  ///
  /// Enumのベースを作成します。
  const CodeEnumCliCommand();

  @override
  String get name => "enum";

  @override
  String get prefix => "enum";

  @override
  String get directory => "lib/enums";

  @override
  String get description =>
      "Create an Enum base in `$directory/(filepath).dart`. Enumのベースを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code enum [enum_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code enum [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code enum [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    label("Create a enum in `$directory/$path.dart`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path);
  }

  @override
  String import(String path, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";

// ignore: unused_import, unnecessary_import
import "package:$packageName/main.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Enum for $className.
enum ${className}Enum {
  // TODO: Set the value of Enum.
}
""";
  }
}
