part of katana_cli;

/// Code base for creating RedirectQuery.
///
/// RedirectQueryを作成するためのコードベース。
class RedirectQueryCliCode extends CliCode {
  /// Code base for creating RedirectQuery.
  ///
  /// RedirectQueryを作成するためのコードベース。
  const RedirectQueryCliCode();

  @override
  String get name => "redirect_query";

  @override
  String get prefix => "redirectQuery";

  @override
  String get directory => "lib/redirects";

  @override
  String get description =>
      "Create a class to describe the page redirect. The class name will be [(filename)RedirectQuery]. ページリダイレクトを記述するためのクラスを作成します。クラス名は[(ファイル名)RedirectQuery]となります。";

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
  FutureOr<RouteQuery?> redirect(
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
