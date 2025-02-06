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
  String? get example => "katana pub upgrade";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final pod = bin.get("pod", "pod");
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
      final iosDir = Directory("ios");
      if (iosDir.existsSync()) {
        final podfile = File("ios/Podfile.lock");
        if (podfile.existsSync()) {
          await podfile.delete();
        }
        await command(
          "Upgrade the pod repository.",
          [
            pod,
            "repo",
            "update",
          ],
          workingDirectory: iosDir.path,
        );
        await command(
          "Upgrade the iOS package.",
          [
            pod,
            "install",
          ],
          workingDirectory: iosDir.path,
        );
      }
    }
  }
}
