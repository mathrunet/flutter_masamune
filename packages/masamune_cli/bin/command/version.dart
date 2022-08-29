part of masamune_cli;

class VersionCliCommand extends CliCommand {
  const VersionCliCommand();

  @override
  String get description => "Dartパッケージのバージョンアップを行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final melos = bin["melos"] as String?;
    if (!File("melos.yaml").existsSync()) {
      print("melos.yamlのファイルが存在しません。");
      return;
    }
    final processVersion = await Process.start(
      melos!,
      [
        "version",
        "--yes",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await processVersion.print();
  }
}
