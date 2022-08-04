part of masamune_cli;

class PublishCliCommand extends CliCommand {
  const PublishCliCommand();

  @override
  String get description => "Dartパッケージのpubへのデプロイを行います。";

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
        "-y",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await processVersion.print();
    final processPublish = await Process.start(
      melos,
      [
        "publish",
        "--no-dry-run",
        "-y",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await processPublish.print();
  }
}
