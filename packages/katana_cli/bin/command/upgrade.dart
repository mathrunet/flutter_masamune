part of katana_cli;

/// Upgrade the package.
///
/// パッケージのアップグレードを行います。
class UpgradeCliCommand extends CliCommand {
  /// Upgrade the package.
  ///
  /// パッケージのアップグレードを行います。
  const UpgradeCliCommand();

  @override
  String get description => "Upgrade the package. パッケージのアップグレードを行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      await Process.start(
        melos,
        [
          "exec",
          "--",
          "$flutter pub upgrade",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
    } else {
      await Process.start(
        flutter,
        [
          "pub",
          "upgrade",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
    }
  }
}
