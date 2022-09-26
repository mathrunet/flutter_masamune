part of masamune_cli;

class PublishCliCommand extends CliCommand {
  const PublishCliCommand();

  @override
  String get description => "Dartパッケージのpubへのデプロイを行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final melos = bin.get("melos", "melos");
    if (!File("melos.yaml").existsSync()) {
      print("melos.yamlのファイルが存在しません。");
      return;
    }
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
