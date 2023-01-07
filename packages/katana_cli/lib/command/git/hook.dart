part of katana_cli.github;

/// Add a Git hook for Flutter using Lefthook.
///
/// Lefthookを用いてFlutter用のGit hookを追加します。
class GitHookCliCommand extends CliCommand {
  /// Add a Git hook for Flutter using Lefthook.
  ///
  /// Lefthookを用いてFlutter用のGit hookを追加します。
  const GitHookCliCommand();

  @override
  String get description =>
      "Add a Git hook for Flutter using Lefthook. Check for Linter, sort imports, and run the formatter when staging. Please install lefthook beforehand. Lefthookを用いてFlutter用のGit hookを追加します。ステージング時にLinterのチェックとインポートのソート、フォーマッターの実行を行うようにします。事前にlefthookをインストールしておいてください。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final lefthook = bin.get("lefthook", "lefthook");
    await command(
      "Import import_sorter packages.",
      [
        flutter,
        "pub",
        "add",
        "--dev",
        "import_sorter",
      ],
    );
    label("Create lefthook.yaml");
    await const LefthookCliCode().generateFile("lefthook.yaml");
    await command(
      "Install lefthook.",
      [
        lefthook,
        "install",
      ],
    );
  }
}
