part of katana_cli;

/// Controller group codebase.
///
/// コントローラーグループのコードベース。
class ControllerGroupCliCode extends CliCode {
  /// Controller group codebase.
  ///
  /// コントローラーグループのコードベース。
  const ControllerGroupCliCode();

  @override
  String get name => "controller_group";

  @override
  String get prefix => "controllerGroup";

  @override
  String get directory => "lib/controllers";

  @override
  String get description =>
      "Create the code necessary to create a controller group. The controller group name will be [(filename)ControllerGroup]. コントローラーグループを作成するために必要なコードを作成します。コントローラーグループ名は[(ファイル名)ControllerGroup]になります。";

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
@controllerGroup
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
