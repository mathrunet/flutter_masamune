part of "flavor.dart";

/// Set the app to the Prod Flavor.
///
/// アプリをProdのFlavorに設定します。
class FlavorProdCliCommand extends CliCommand {
  /// Set the app to the Prod Flavor.
  ///
  /// アプリをProdのFlavorに設定します。
  const FlavorProdCliCommand();

  @override
  String get description =>
      "Set the app to the Prod Flavor. アプリをProdのFlavorに設定します。";

  @override
  String? get example => "katana flavor prod";

  @override
  Future<void> exec(ExecContext context) async {
    final prodEnvFile = File("${Directory.current.path}/dart_defines/prod.env");
    if (!prodEnvFile.existsSync()) {
      // ignore: avoid_print
      print("Skipping because the prod.env file was not found.");
      return;
    }
    await prodEnvFile
        .copy("${Directory.current.path}/ios/Flutter/DartDefine.xcconfig");
    await prodEnvFile.copy("${Directory.current.path}/android/env.properties");
  }
}
