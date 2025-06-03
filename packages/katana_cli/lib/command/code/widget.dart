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
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';

// ignore: unused_import, unnecessary_import
import 'package:$packageName/main.dart';
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
/// ScopedWidget.
@immutable
class ${className}Widget extends ScopedWidget {
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
  String test(String path, String baseName, String className) {
    return """
import 'package:flutter_test/flutter_test.dart';
import 'package:masamune/masamune.dart';

void main() {
  testWidgets("$className", (tester) async {
    masamuneTest();
    // TODO: Write test code.
  });
}
""";
  }
}
