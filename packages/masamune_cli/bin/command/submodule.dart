part of masamune_cli;

class SubmoduleCliCommand extends CliCommand {
  const SubmoduleCliCommand();

  @override
  String get description => "サブモジュールをクローンします。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final git = bin.get("git", "git");
    final processPublish = await Process.start(
      git,
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
