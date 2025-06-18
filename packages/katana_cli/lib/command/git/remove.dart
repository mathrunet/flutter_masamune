part of "git.dart";

/// Remove files from Git.
///
/// Gitからファイルを削除します。
class GitRemoveCliCommand extends CliCommand {
  /// Remove files from Git.
  ///
  /// Gitからファイルを削除します。
  const GitRemoveCliCommand();

  @override
  String get description => "Remove files from Git. Gitからファイルを削除します。";

  @override
  String? get example => "katana git remove";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final git = bin.get("git", "git");
    final github = context.yaml.getAsMap("github");
    final claudeCode = github.getAsMap("claude_code");
    final author = claudeCode.getAsMap("author");
    final email = author.get("email", "claude@anthropic.com");
    final name = author.get("name", "Claude Code");
    final args = context.args.sublist(2);
    final messageArg =
        args.firstWhereOrNull((element) => element.startsWith("--message="));
    if (messageArg != null) {
      args.remove(messageArg);
    }
    final message = messageArg
        ?.substring(messageArg.indexOf("=") + 1, messageArg.length)
        .trim()
        .trimString("\"")
        .trimString("'")
        .trim();
    await command(
      "Update author information.",
      [
        git,
        "config",
        "user.email",
        "\"$email\"",
        "&&",
        git,
        "config",
        "user.name",
        "\"$name\"",
      ],
    );
    await command(
      "Remove files from Git.",
      [
        git,
        "rm",
        ...args,
      ],
    );
    await command(
      "Commit to Git.",
      [
        git,
        "commit",
        "-m",
        "\"$message\"",
      ],
    );
    await command(
      "Push to Git.",
      [
        git,
        "push",
      ],
    );
  }
}
