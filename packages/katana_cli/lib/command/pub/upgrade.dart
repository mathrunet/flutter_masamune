part of "pub.dart";

/// Upgrade the package.
///
/// パッケージのアップグレードを行います。
class PubUpgradeCliCommand extends CliCommand {
  /// Upgrade the package.
  ///
  /// パッケージのアップグレードを行います。
  const PubUpgradeCliCommand();

  @override
  String get description => "Upgrade the package. パッケージのアップグレードを行います。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      await command(
        "Upgrade import packages for all packages.",
        [
          melos,
          "exec",
          "--",
          "$flutter pub upgrade",
        ],
      );
    } else {
      await command(
        "Upgrade the project package.",
        [
          flutter,
          "pub",
          "upgrade",
        ],
      );
    }
  }
}
