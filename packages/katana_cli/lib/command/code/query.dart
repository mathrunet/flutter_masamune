part of "code.dart";

/// Create a `ChangeNotifierScopedQuery`.
///
/// `ChangeNotifierScopedQuery`を作成します。
class CodeQueryCliCommand extends CliCodeCommand {
  /// Create a `ChangeNotifierScopedQuery`.
  ///
  /// `ChangeNotifierScopedQuery`を作成します。
  const CodeQueryCliCommand();

  @override
  String get name => "query";

  @override
  String get prefix => "query";

  @override
  String get directory => "lib/controllers";

  @override
  String get description =>
      "Create a `ChangeNotifierScopedQuery` in `$directory/(filepath).dart`. `ChangeNotifierScopedQuery`を`$directory/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code query [path]\r\n",
      );
      return;
    }
    label("Create a ChangeNotifierScopedQuery in `$directory/$path.dart`.");
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
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// [ChangeNotifierScopedQuery] for $className.
/// 
/// It can be used as follows
/// 
/// ```dart
/// final ${className.toCamelCase()} = ref.app.query(${className.toCamelCase()}Query);
/// ```
final ${className.toCamelCase()}Query = ChangeNotifierScopedQuery(
  (ref) {
    // TODO: Define the process of creating the ChangeNotifier.
    return \${1};
  }
);
""";
  }
}
