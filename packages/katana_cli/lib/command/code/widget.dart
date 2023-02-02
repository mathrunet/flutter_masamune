part of katana_cli.code;

/// Create a base class to create a ScopedWidget.
///
/// ScopedWidgetを作成するベースクラスを作成します。
class CodeWidgetCliCommand extends CliCodeCommand {
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
  String get description =>
      "Create a ScopedWidget in `$directory/(filepath).dart`. ScopedWidgetを`$directory/(filepath).dart`に作成します。";

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
    await generateDartCode("$directory/$path");
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Describes the process of loading
    // and defining variables required for the widget.
    // TODO: Implement the variable loading process.
    \${2}

    // Describes the structure of the widget.
    // TODO: Implement the view.
    return \${3:Empty()};
  }
}
""";
  }
}
