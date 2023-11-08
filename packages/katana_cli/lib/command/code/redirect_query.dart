part of "code.dart";

/// Create a base class for RedirectQuery.
///
/// RedirectQueryのベースクラスを作成します。
class CodeRedirectQueryCliCommand extends CliCodeCommand {
  /// Create a base class for RedirectQuery.
  ///
  /// RedirectQueryのベースクラスを作成します。
  const CodeRedirectQueryCliCommand();

  @override
  String get name => "redirect_query";

  @override
  String get prefix => "redirectQuery";

  @override
  String get directory => "lib/redirects";

  @override
  String get description =>
      "Create a base class for the RedirectQuery in `$directory/(filepath).dart`. RedirectQueryのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code redirect [path]\r\n",
      );
      return;
    }
    label("Create a RedirectQuery class in `$directory/$path.dart`.");
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
import 'dart:async';

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
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Describe the redirection process between pages.
/// 
/// It works by passing it as an argument to the AppRouter or PagePath annotation.
/// 
/// ```dart
/// final router = AppRouter(
///   redirect: [
///     ${className}RedirectQuery(),
///   ],
/// );
/// ```
class ${className}RedirectQuery extends RedirectQuery {
  const ${className}RedirectQuery();

  @override
  FutureOr<RouteQuery> redirect(
    BuildContext context,
    RouteQuery source,
  ) async {
    // Return [source] if you want to transition directly to the page without redirecting.
    // TODO: Describe the redirection process.
    return source;
  }
}
""";
  }
}
