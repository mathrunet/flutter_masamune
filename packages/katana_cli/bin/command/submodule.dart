part of katana_cli;

/// Recursively clone submodules.
///
/// サブモジュールを再帰的にクローンします。
class SubmoduleCliCommand extends CliCommand {
  /// Recursively clone submodules.
  ///
  /// サブモジュールを再帰的にクローンします。
  const SubmoduleCliCommand();

  @override
  String get description =>
      "Recursively clone submodules. サブモジュールを再帰的にクローンします。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final git = bin.get("git", "git");
    await Process.start(
      git,
      [
        "submodule",
        "update",
        "--init",
        "--recursive",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    ).print();
  }
}
