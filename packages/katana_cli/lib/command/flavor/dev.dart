part of "flavor.dart";

/// Set the app to the Dev Flavor.
///
/// アプリをDevのFlavorに設定します。
class FlavorDevCliCommand extends CliCommand {
  /// Set the app to the Dev Flavor.
  ///
  /// アプリをDevのFlavorに設定します。
  const FlavorDevCliCommand();

  @override
  String get description =>
      "Set the app to the Dev Flavor. アプリをDevのFlavorに設定します。";

  @override
  String? get example => "katana flavor dev";

  @override
  Future<void> exec(ExecContext context) async {
    final devEnvFile = File("${Directory.current.path}/dart_defines/dev.env");
    if (!devEnvFile.existsSync()) {
      // ignore: avoid_print
      print("Skipping because the dev.env file was not found.");
      return;
    }
    await devEnvFile
        .copy("${Directory.current.path}/ios/Flutter/DartDefine.xcconfig");
    await devEnvFile.copy("${Directory.current.path}/android/env.properties");
  }
}
