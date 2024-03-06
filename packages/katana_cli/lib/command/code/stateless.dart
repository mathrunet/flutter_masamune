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
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code stateless [path]\r\n",
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
    return """
// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';
import 'package:masamune_universal_ui/masamune_universal_ui.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';
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
/// StatelessWidget.
@immutable
class ${className}Widget extends StatelessWidget {
  const ${className}Widget({
    super.key,
    // TODO: Set parameters for the widget.
    \${1}
  });

  @override
  Widget build(BuildContext context) {
    // Describes the structure of the widget.
    // TODO: Implement the view.
    return \${2:Empty()};
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
