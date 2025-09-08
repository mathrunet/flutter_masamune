part of "store.dart";

/// Build the Android appbundle for the first upload to the store.
///
/// Androidのappbundleをビルドしてストアへの初回アップロードを行います。
class StoreAndroidBuildCliCommand extends CliCommand {
  /// Build the Android appbundle for the first upload to the store.
  ///
  /// Androidのappbundleをビルドしてストアへの初回アップロードを行います。
  const StoreAndroidBuildCliCommand();

  @override
  String get description =>
      "Build the Android appbundle for the first upload to the store. Androidのappbundleをビルドしてストアへの初回アップロードを行います。";

  @override
  String? get example => "katana store build";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final prodEnvFile = File("${Directory.current.path}/dart_defines/prod.env");
    if (prodEnvFile.existsSync()) {
      await prodEnvFile
          .copy("${Directory.current.path}/ios/Flutter/DartDefine.xcconfig");
      await prodEnvFile
          .copy("${Directory.current.path}/android/env.properties");
    }
    await command(
      "Build for appbunle.",
      [
        flutter,
        "build",
        "appbundle",
        "--release",
        "--dart-define-from-file=dart_defines/prod.env",
      ],
    );
  }
}
