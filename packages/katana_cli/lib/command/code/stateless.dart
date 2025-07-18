part of "code.dart";

/// Create a base class to create a StatelessWidget.
///
/// StatelessWidgetを作成するベースクラスを作成します。
class CodeStatelessCliCommand extends CliTestableCodeCommand {
  /// Create a base class to create a StatelessWidget.
  ///
  /// StatelessWidgetを作成するベースクラスを作成します。
  const CodeStatelessCliCommand();

  @override
  String get name => "stateless";

  @override
  String get prefix => "stateless";

  @override
  String get directory => "lib/widgets";

  @override
  String get testDirectory => "test/widgets";

  @override
  String get description =>
      "Create a StatelessWidget in `$directory/(filepath).dart`. StatelessWidgetを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code stateless [widget_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code stateless [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code stateless [path]\r\n",
      );
      return;
    }
    label("Create a StatelessWidget class in `$directory/$path.dart`.");
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
/// StatelessWidget for $className.
@immutable
class ${className}Widget extends StatelessWidget {
  /// StatelessWidget for $className.
  const ${className}Widget({
    super.key,
    // TODO: Set parameters for the widget.
    \${1}
  });

  // TODO: Set parameters for the widget in the form (e.g. [final String xxx]).
  \${2}

  @override
  Widget build(BuildContext context) {
    // Describes the structure of the widget.
    // TODO: Implement the view.
    return \${3:Empty()};
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
