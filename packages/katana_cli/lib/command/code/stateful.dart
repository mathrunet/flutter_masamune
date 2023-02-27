part of katana_cli.code;

/// Create a base class to create a StatefulWidget.
///
/// StatefulWidgetを作成するベースクラスを作成します。
class CodeStatefulCliCommand extends CliCodeCommand {
  /// Create a base class to create a StatefulWidget.
  ///
  /// StatefulWidgetを作成するベースクラスを作成します。
  const CodeStatefulCliCommand();

  @override
  String get name => "stateful";

  @override
  String get prefix => "stateful";

  @override
  String get directory => "lib/widgets";

  @override
  String get description =>
      "Create a StatefulWidget in `$directory/(filepath).dart`. StatefulWidgetを`$directory/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code stateful [path]\r\n",
      );
      return;
    }
    label("Create a StatefulWidget class in `$directory/$path.dart`.");
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
    return """
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// StatefulWidget.
@immutable
class ${className}Widget extends StatefulWidget {
  const ${className}Widget({
    super.key,
    // TODO: Set parameters for the widget.
    \${1}
  });

  @override
  State<StatefulWidget> createState() => _${className}State();
}

class _${className}State extends State<${className}Widget> {
  @override
  Widget build(BuildContext context) {
    // Describes the structure of the widget.
    // TODO: Implement the view.
    return \${2:Empty()};
  }
}
""";
  }
}
