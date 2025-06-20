part of "code.dart";

/// Create a base class to create a ScopedWidget.
///
/// ScopedWidgetを作成するベースクラスを作成します。
class CodeWidgetCliCommand extends CliTestableCodeCommand {
  /// Create a base class to create a ScopedWidget.
  ///
  /// ScopedWidgetを作成するベースクラスを作成します。
  const CodeWidgetCliCommand();

  @override
  String get name => "widget";

  @override
  String get prefix => "widget";

  @override
  String get directory => "lib/widgets";

  @override
  String get testDirectory => "test/widgets";

  @override
  String get description =>
      "Create a ScopedWidget in `$directory/(filepath).dart`. ScopedWidgetを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code widget [widget_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code widget [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code widget [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    label("Create a ScopedWidget class in `$directory/$path.dart`.");
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
import "package:masamune_universal_ui/masamune_universal_ui.dart";

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
/// ScopedWidget for $className.
@immutable
class ${className}Widget extends ScopedWidget {
  /// ScopedWidget for $className.
  const ${className}Widget({
    super.key,
    // TODO: Set parameters for the widget.
    \${1}
  });

  // TODO: Set parameters for the widget in the form (e.g. [final String xxx]).
  \${2}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Describes the process of loading
    // and defining variables required for the widget.
    // TODO: Implement the variable loading process.
    \${3}

    // Describes the structure of the widget.
    // TODO: Implement the view.
    return \${4:Empty()};
  }
}
""";
  }

  @override
  String test(
      String path, String sourcePath, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
import "package:masamune_test/masamune_test.dart";

import "package:$packageName/widgets/$sourcePath.dart";

void main() {
  masamuneWidgetTest(
    name: "${className}Widget",
    path: "$sourcePath",
    builder: (context, ref, value) {
      // TODO: Write test code.
      return const ${className}Widget();      
    },
  );
}
""";
  }
}
