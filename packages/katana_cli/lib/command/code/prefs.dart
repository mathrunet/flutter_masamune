part of "code.dart";

/// Create a base class for SharedPreferences.
///
/// SharedPreferencesのベースクラスを作成します。
class CodePrefsCliCommand extends CliCodeCommand {
  /// Create a base class for SharedPreferences.
  ///
  /// SharedPreferencesのベースクラスを作成します。
  const CodePrefsCliCommand();

  @override
  String get name => "prefs";

  @override
  String get prefix => "prefs";

  @override
  String get directory => "lib";

  @override
  String get description =>
      "Create a base class for SharedPreferences in `$directory/prefs.dart`. SharedPreferencesのベースクラスを`$directory/prefs.dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    label("Create a controller group class in `$directory/prefs.dart`.");
    await generateDartCode("$directory/prefs", "prefs");
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
part 'prefs.prefs.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
/// Get SharedPreferences for the app.
/// 
/// ```dart
/// appPrefs.xxx.get();      // Get xxx value.
/// appPrefs.xxx.set("xxx"); // Set xxx value.
/// ```
final appPrefs = Prefs(
  // TODO: Initial values defined in Prefs are listed here.
  ${2}
);

/// Shared Preferences.
@prefs
class Prefs with _$Prefs, ChangeNotifier {
  factory Prefs({
    // TODO: Define here the values to be managed in Shared Preferences.
    ${1}
  }) = _Prefs;
  Prefs._();
}
""";
  }
}
