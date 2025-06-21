part of "git.dart";

/// Create a pull request.
///
/// プルリクエストを作成します。
class GitPullRequestCliCommand extends CliCommand {
  /// Create a pull request.
  ///
  /// プルリクエストを作成します。
  const GitPullRequestCliCommand();

  static final _linkRegex = RegExp(r"\[(.*?)\]\((.*?)\)");

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
    final titleArg =
        args.firstWhereOrNull((element) => element.startsWith("--title="));
    if (titleArg != null) {
      args.remove(titleArg);
    }
    final title = titleArg
        ?.substring(titleArg.indexOf("=") + 1, titleArg.length)
        .escape();
    final bodyArg =
        args.firstWhereOrNull((element) => element.startsWith("--body="));
    if (bodyArg != null) {
      args.remove(bodyArg);
    }
    var body =
        bodyArg?.substring(bodyArg.indexOf("=") + 1, bodyArg.length).escape();
    // ignore: avoid_print
    print(body);

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
    body = body.replaceAllMapped(_linkRegex, (m) {
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
    body = """
# Summary

$body

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
          title,
          "--body",
          body,
        ],
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
          body,
        ],
      );
    }
  }
}
