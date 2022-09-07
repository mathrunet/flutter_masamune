part of masamune_cli;

class SubmoduleCliCommand extends CliCommand {
  const SubmoduleCliCommand();

  @override
  String get description => "サブモジュールをクローンします。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final git = bin["git"] as String?;
    final processPublish = await Process.start(
      git!,
      [
        "submodule",
        "update",
        "--init",
        "--recursive",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await processPublish.print();
  }
}
