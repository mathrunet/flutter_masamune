part of "code.dart";

/// Create a base class for the controller.
///
/// コントローラーのベースクラスを作成します。
class CodeControllerCliCommand extends CliTestableCodeCommand {
  /// Create a base class for the controller.
  ///
  /// コントローラーのベースクラスを作成します。
  const CodeControllerCliCommand();

  @override
  String get name => "controller";

  @override
  String get prefix => "controller";

  @override
  String get directory => "lib/controllers";

  @override
  String get testDirectory => "test/controllers";

  @override
  String get description =>
      "Create a base class for the controller in `$directory/(filepath).dart`. コントローラーのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code controller [controller_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code controller [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code controller [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    label("Create a controller class in `$directory/$path.dart`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
      final parentTestDir = Directory("$testDirectory/$parentPath");
      if (!parentTestDir.existsSync()) {
        await parentTestDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path);
    await generateDartTestCode("$testDirectory/$path", path);
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
part "$baseName.m.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Controller for $className.
@Controller(autoDisposeWhenUnreferenced: true)
class ${className}Controller extends ChangeNotifier {
  /// Controller for $className.
  ${className}Controller(
    // TODO: Define some arguments.
    \${1}
  );

  // TODO: Define fields and processes.
  \${2}

  /// Query for ${className}Controller.
  ///
  /// ```dart
  /// appRef.controller(${className}Controller.query(parameters));     // Get from application scope.
  /// ref.app.controller(${className}Controller.query(parameters));    // Watch at application scope.
  /// ref.page.controller(${className}Controller.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _\$${className}ControllerQuery();
}
""";
  }

  @override
  String test(
      String path, String sourcePath, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";
import "package:masamune_test/masamune_test.dart";

import "package:$packageName/controllers/$sourcePath.dart";

void main() {
  masamuneControllerTest(
    name: "$className",
    tests: [
      // TODO: Write test code.

    ],
  );
}
""";
  }
}
