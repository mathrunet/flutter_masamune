part of "git.dart";

/// Create a pull request comment.
///
/// プルリクエスト用のコメントを作成します。
class GitPullRequestCommentCliCommand extends CliCommand {
  /// Create a pull request comment.
  ///
  /// プルリクエスト用のコメントを作成します。
  const GitPullRequestCommentCliCommand();

  static final _linkRegex = RegExp(r"\[(.*?)\]\((.*?)\)");

  @override
  String get description =>
      "Create a pull request comment. プルリクエスト用のコメントを作成します。";

  @override
  String? get example => "katana git pull_request_comment";

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
        ?.substring(targetArg.indexOf("=") + 1, targetArg.length)
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
        ?.substring(sourceArg.indexOf("=") + 1, sourceArg.length)
        .trim()
        .trimString("\"")
        .trimString("'")
        .trim();
    final commentArg =
        args.firstWhereOrNull((element) => element.startsWith("--comment="));
    if (commentArg != null) {
      args.remove(commentArg);
    }
    var comment = commentArg
        ?.substring(commentArg.indexOf("=") + 1, commentArg.length)
        .trim()
        .trimString("\"")
        .trimString("'")
        .trim()
        .replaceAll("\\n", "\n")
        .replaceAll('\\"', '"')
        .replaceAll("\\!", "!");

    if (target == null || target.isEmpty) {
      error(
          "Target branch is required. e.g. `katana git pull_request_comment --comment=\"PullRequest additional comment\" --target=main --source=feature/fix_any_bug`");
      return;
    }
    if (source == null || source.isEmpty) {
      error(
          "Source branch is required. e.g. `katana git pull_request_comment --comment=\"PullRequest additional comment\" --target=main --source=feature/fix_any_bug`");
      return;
    }
    if (comment == null || comment.isEmpty) {
      error(
          "Comment is required. e.g. `katana git pull_request_comment --comment=\"PullRequest additional comment\" --target=main --source=feature/fix_any_bug`");
      return;
    }
    // GitHubリポジトリ情報を動的に取得
    final repoResult = await command(
      "Get repository information.",
      [
        gh,
        "repo",
        "view",
        "--json",
        "owner,name",
      ],
    );
    final repositoryInfoJson = jsonDecodeAsMap(repoResult);
    final repositoryName = repositoryInfoJson.get("name", "");
    final repositoryOwnerName =
        repositoryInfoJson.getAsMap("owner").get("login", "");
    final repositoryUrl =
        "https://github.com/$repositoryOwnerName/$repositoryName";
    final repositoryRawUrl = "$repositoryUrl/raw/$source".trimStringRight("/");
    // Bodyからマークダウンのリンクを抽出し相対パスであればGithubの現在のレポジトリおよびブランチ名を取得しRawDataのパスに変換する
    comment = comment.replaceAllMapped(_linkRegex, (m) {
      final path = m.group(2);
      if (path != null && !path.startsWith("http")) {
        return "[${m.group(1)}]($repositoryRawUrl/${path.trimString("/")})";
      }
      return "[${m.group(1)}]($path)";
    });
    final screenshots = args.map((path) {
      if (!path.startsWith("http")) {
        return "- ${path.last()}\n![${path.last()}]($repositoryRawUrl/${path.trimString("/")})";
      }
      return "- ${path.last()}\n![$path]($path)";
    }).join("\n");
    comment = """
# Summary

$comment

# Screenshots

$screenshots
""";
    await command(
      "Update email information.",
      [
        git,
        "config",
        "user.email",
        "\"$email\"",
      ],
    );
    await command(
      "Update author information.",
      [
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
    ]);
    final json = jsonDecodeAsList<DynamicMap>(result);
    if (json.isEmpty) {
      error(
        "Pull request not found. e.g. `katana git pull_request_comment --comment=\"PullRequest additional comment\" --target=main --source=feature/fix_any_bug`",
      );
    } else {
      final repo = json.first;
      final url =
          repo.get("url", "").trim().trimString("\"").trimString("'").trim();
      await command(
        "Post a comment to the pull request.",
        [
          gh,
          "pr",
          "comment",
          url,
          "--body",
          comment,
        ],
      );
    }
  }
}
