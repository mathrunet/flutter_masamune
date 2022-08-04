part of masamune_cli;

class UpgradeCliCommand extends CliCommand {
  const UpgradeCliCommand();

  @override
  String get description => "パッケージのアップグレードを行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final flutter = bin["flutter"] as String?;
    final melos = bin["melos"] as String?;
    if (File("melos.yaml").existsSync()) {
      final process = await Process.start(
        melos!,
        [
          "exec",
          "--",
          "$flutter pub upgrade",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      );
      await process.print();
    } else {
      final process = await Process.start(
        flutter!,
        [
          "pub",
          "upgrade",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      );
      await process.print();
    }
  }
}
