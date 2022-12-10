part of katana_cli;

/// Get the packages.
///
/// パッケージの取得を行います。
class PubGetCliCommand extends CliCommand {
  /// Get the packages.
  ///
  /// パッケージの取得を行います。
  const PubGetCliCommand();

  @override
  String get description => "Get the packages. パッケージの取得を行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      await command(
        "Get import packages for all packages.",
        [
          melos,
          "exec",
          "--",
          "$flutter pub get",
        ],
      );
    } else {
      await command(
        "Get the project package.",
        [
          flutter,
          "pub",
          "get",
        ],
      );
    }
  }
}
