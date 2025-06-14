part of "git.dart";

/// Create a pull request.
///
/// プルリクエストを作成します。
class GitPullRequestCliCommand extends CliCommand {
  /// Create a pull request.
  ///
  /// プルリクエストを作成します。
  const GitPullRequestCliCommand();

  @override
  String get description => "Create a pull request. プルリクエストを作成します。";

  @override
  String? get example => "katana git pull_request";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final git = bin.get("git", "git");
    final gh = bin.get("gh", "gh");
    final github = context.yaml.getAsMap("github");
    final claudeCode = github.getAsMap("claude_code");
    final author = claudeCode.getAsMap("author");
    final email = author.get("email", "claude@anthropic.com");
    final name = author.get("name", "Claude Code");
    final args = context.args.sublist(2);
    final targetArg =
        args.firstWhereOrNull((element) => element.startsWith("--target="));
    if (targetArg != null) {
      args.remove(targetArg);
    }
    final target = targetArg
        ?.substring(targetArg.indexOf("=") + 1, targetArg.length - 1)
        .trim()
        .trimString("\"")
        .trimString("'")
        .trim();
    final sourceArg =
        args.firstWhereOrNull((element) => element.startsWith("--source="));
    if (sourceArg != null) {
      args.remove(sourceArg);
    }
    final source = sourceArg
        ?.substring(sourceArg.indexOf("=") + 1, sourceArg.length - 1)
        .trim()
        .trimString("\"")
        .trimString("'")
        .trim();
    final titleArg =
        args.firstWhereOrNull((element) => element.startsWith("--title="));
    if (titleArg != null) {
      args.remove(titleArg);
    }
    final title = titleArg
        ?.substring(titleArg.indexOf("=") + 1, titleArg.length - 1)
        .trim()
        .trimString("\"")
        .trimString("'")
        .trim();
    final bodyArg =
        args.firstWhereOrNull((element) => element.startsWith("--body="));
    if (bodyArg != null) {
      args.remove(bodyArg);
    }
    var body = bodyArg
        ?.substring(bodyArg.indexOf("=") + 1, bodyArg.length - 1)
        .trim()
        .trimString("\"")
        .trimString("'")
        .trim();
    if (target == null || target.isEmpty) {
      error(
          "Target branch is required. e.g. `katana git pull_request --title=\"PullRequest title\" --body=\"PullRequest body\" --target=main --source=feature/fix_any_bug` documsnts/test/ci/pages/screenshot_image1.png documsnts/test/ci/pages/screenshot_image2.png`");
      return;
    }
    if (source == null || source.isEmpty) {
      error(
          "Source branch is required. e.g. `katana git pull_request --title=\"PullRequest title\" --body=\"PullRequest body\" --target=main --source=feature/fix_any_bug` documsnts/test/ci/pages/screenshot_image1.png documsnts/test/ci/pages/screenshot_image2.png`");
      return;
    }
    if (title == null || title.isEmpty) {
      error(
          "Title is required. e.g. `katana git pull_request --title=\"PullRequest title\" --body=\"PullRequest body\" --target=main --source=feature/fix_any_bug` documsnts/test/ci/pages/screenshot_image1.png documsnts/test/ci/pages/screenshot_image2.png`");
      return;
    }
    if (body == null || body.isEmpty) {
      error(
          "Body is required. e.g. `katana git pull_request --title=\"PullRequest title\" --body=\"PullRequest body\" --target=main --source=feature/fix_any_bug` documsnts/test/ci/pages/screenshot_image1.png documsnts/test/ci/pages/screenshot_image2.png`");
      return;
    }
    body = """
# Summary

$body

# Screenshots

${args.map((e) => "- ${e.last()}\n![${e.last()}]($e)").join("\n")}
""";
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
    final result = await command("Check if the pull request already exists.", [
      gh,
      "pr",
      "list",
      "--base",
      target,
      "--head",
      source,
      "--json",
      "url",
      "--jq",
      "'.[0].url'",
    ]);
    if (result.isEmpty) {
      await command(
        "Create a pull request.",
        [
          gh,
          "pr",
          "create",
          "--base",
          target,
          "--head",
          source,
          "--title",
          "\"$title\"",
          "--body",
          "\"$body\"",
        ],
      );
    } else {
      await command(
        "Post a comment to the pull request.",
        [
          gh,
          "pr",
          "comment",
          "\"$result\"",
          "--body",
          "\"$body\"",
        ],
      );
    }
  }
}
