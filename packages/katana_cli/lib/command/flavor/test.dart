part of "flavor.dart";

/// Set the app to the Test Flavor.
///
/// アプリをTestのFlavorに設定します。
class FlavorTestCliCommand extends CliCommand {
  /// Set the app to the Test Flavor.
  ///
  /// アプリをTestのFlavorに設定します。
  const FlavorTestCliCommand();

  @override
  String get description =>
      "Set the app to the Test Flavor. アプリをTestのFlavorに設定します。";

  @override
  String? get example => "katana flavor test";

  @override
  Future<void> exec(ExecContext context) async {
    final testEnvFile = File("${Directory.current.path}/dart_defines/test.env");
    if (!testEnvFile.existsSync()) {
      // ignore: avoid_print
      print("Skipping because the test.env file was not found.");
      return;
    }
    await testEnvFile
        .copy("${Directory.current.path}/ios/Flutter/DartDefine.xcconfig");
    await testEnvFile.copy("${Directory.current.path}/android/env.properties");
  }
}
