part of "flavor.dart";

/// Set the app to the Stg Flavor.
///
/// アプリをStgのFlavorに設定します。
class FlavorStgCliCommand extends CliCommand {
  /// Set the app to the Stg Flavor.
  ///
  /// アプリをStgのFlavorに設定します。
  const FlavorStgCliCommand();

  @override
  String get description =>
      "Set the app to the Stg Flavor. アプリをStgのFlavorに設定します。";

  @override
  String? get example => "katana flavor stg";

  @override
  Future<void> exec(ExecContext context) async {
    final stgEnvFile = File("${Directory.current.path}/dart_defines/stg.env");
    if (!stgEnvFile.existsSync()) {
      // ignore: avoid_print
      print("Skipping because the stg.env file was not found.");
      return;
    }
    await stgEnvFile
        .copy("${Directory.current.path}/ios/Flutter/DartDefine.xcconfig");
    await stgEnvFile.copy("${Directory.current.path}/android/env.properties");
  }
}
