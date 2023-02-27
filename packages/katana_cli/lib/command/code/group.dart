part of katana_cli.code;

/// Create a base class for the controller group.
///
/// コントローラーグループのベースクラスを作成します。
class CodeGroupCliCommand extends CliCodeCommand {
  /// Create a base class for the controller group.
  ///
  /// コントローラーグループのベースクラスを作成します。
  const CodeGroupCliCommand();

  @override
  String get name => "controller_group";

  @override
  String get prefix => "controllerGroup";

  @override
  String get directory => "lib/controllers";

  @override
  String get description =>
      "Create a base class for the controller group in `$directory/(filepath).dart`. コントローラーグループのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code group [path]\r\n",
      );
      return;
    }
    label("Create a controller group class in `$directory/$path.dart`.");
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
part '$baseName.listenable.dart';
part '$baseName.m.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Controller Group.
@listenables
@ControllerGroup(autoDisposeWhenUnreferenced: true)
class ${className}ControllerGroup with _\$${className}ControllerGroup, ChangeNotifier {
  factory ${className}ControllerGroup({
    // TODO: Define the ChangeNotifier field here.
    \${1}
  }) = _${className}ControllerGroup;
  ${className}ControllerGroup._();

  /// Query for ${className}ControllerGroup.
  ///
  /// ```dart
  /// appRef.conroller(${className}ControllerGroup.query(parameters));   // Get from application scope.
  /// ref.app.conroller(${className}ControllerGroup.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(${className}ControllerGroup.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _\$${className}ControllerGroupQuery();
}
""";
  }
}
