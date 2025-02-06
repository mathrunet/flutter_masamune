part of "git.dart";

/// Recursively clone submodules.
///
/// サブモジュールを再帰的にクローンします。
class GitSubmoduleCliCommand extends CliCommand {
  /// Recursively clone submodules.
  ///
  /// サブモジュールを再帰的にクローンします。
  const GitSubmoduleCliCommand();

  @override
  String get description =>
      "Recursively clone submodules. サブモジュールを再帰的にクローンします。";

  @override
  String? get example => "katana git submodule";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final git = bin.get("git", "git");
    await command(
      "Recursively clone a Git submodule of the current project.",
      [
        git,
        "submodule",
        "update",
        "--init",
        "--recursive",
      ],
    );
  }
}
