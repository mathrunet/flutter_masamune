part of katana_cli.code;

/// Create a base class for the Boot page.
///
/// Bootページのベースクラスを作成します。
class CodeBootCliCommand extends CliCodeCommand {
  /// Create a base class for the Boot page.
  ///
  /// Bootページのベースクラスを作成します。
  const CodeBootCliCommand();

  @override
  String get name => "boot";

  @override
  String get prefix => "boot";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a base class for the boot page in `$directory/boot.dart`. ブートページのベースクラスを`$directory/boot.dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    label("Create a Boot class in `$directory/boot.dart`.");
    await generateDartCode("$directory/boot", "boot");
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
/// Describe the page to be displayed when the application is launched.
/// 
/// By passing this object to the `boot` parameter of AppRouter, the processing of this class will be executed when the application starts.
/// 
/// ```dart
/// final router = AppRouter(
///   boot: const Boot(),
/// );
/// ```
@immutable
class Boot extends BootRouteQueryBuilder {
  const Boot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Describe the screen to be displayed when the process is first implemented.
    );
  }

  @override
  FutureOr<void> onInit(BuildContext context) async {
    // TODO: Describe the initialization process.
    await Future.delayed(2.s);
  }

  @override
  void onError(BuildContext context, Object error, StackTrace stackTrace) {
    // TODO: Describe the error process.
  }

  @override
  TransitionQuery get initialTransitionQuery => TransitionQuery.fade;
}
""";
  }
}
