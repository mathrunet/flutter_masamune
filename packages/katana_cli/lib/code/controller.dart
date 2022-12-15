part of katana_cli;

/// Controller code base.
///
/// コントローラーのコードベース。
class ControllerCliCode extends CliCode {
  /// Controller code base.
  ///
  /// コントローラーのコードベース。
  const ControllerCliCode();

  @override
  String get name => "controller";

  @override
  String get prefix => "controller";

  @override
  String get directory => "lib/controllers";

  @override
  String get description =>
      "Create the code necessary to create a controller. The controller name will be [(filename)Controller]. コントローラーを作成するために必要なコードを作成します。コントローラー名は[(ファイル名)Controller]になります。";

  @override
  String import(String path, String baseName, String className) {
    return """
// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:masamune/masamune.dart';

// ignore: unused_import
import '/main.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part '$baseName.m.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Controller.
@controller
class ${className}Controller extends ChangeNotifier {
  ${className}Controller(
    // TODO: Define some arguments.
    \${1}
  );

  // TODO: Define fields and processes.
  \${2}

  /// Query for ${className}Controller.
  ///
  /// ```dart
  /// appRef.conroller(${className}Controller.query(parameters));   // Get from application scope.
  /// ref.app.conroller(${className}Controller.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(${className}Controller.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _\$${className}ControllerQuery();
}
""";
  }
}
