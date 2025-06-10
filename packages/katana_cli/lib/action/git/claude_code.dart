// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Add AI Agent using Claude Code.
///
/// Claude Codeを利用したAIエージェント機能を追加します。
class GitClaudeCodeCliAction extends CliCommand with CliActionMixin {
  /// Add AI Agent using Claude Code.
  ///
  /// Claude Codeを利用したAIエージェント機能を追加します。
  const GitClaudeCodeCliAction();

  @override
  String get description =>
      "Add AI Agent using Claude Code. Claude Codeを利用したAIエージェント機能を追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("github").getAsMap("claude_code");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final gh = bin.get("gh", "gh");
    final github = context.yaml.getAsMap("github");
    final claudeCode = github.getAsMap("claude_code");
    final api = claudeCode.getAsMap("api");
    final plan = claudeCode.getAsMap("plan");
    final apiKey = api.get("api_key", "");
    final uses = plan.get("uses", "");
    final accessToken = plan.get("access_token", "");
    final refreshToken = plan.get("refresh_token", "");
    final expiresAt = plan.get("expires_at", nullOfInt);
    final model = claudeCode.get("model", "claude-sonnet-4-20250514");

    if (apiKey.isEmpty &&
        (uses.isEmpty ||
            accessToken.isEmpty ||
            refreshToken.isEmpty ||
            expiresAt == null)) {
      error(
        "Configuration not found. Please set one of the following: `[claude_code]->[api]->[api_key]`, `[claude_code]->[plan]->[uses]`, `[claude_code]->[plan]->[access_token]`, `[claude_code]->[plan]->[refresh_token]`, or `[claude_code]->[plan]->[expires_at]`.",
      );
      return;
    }
    if (apiKey.isNotEmpty) {
      await command(
        "Set Anthropic API Key in `secrets.ANTHROPIC_API_KEY`.",
        [
          gh,
          "secret",
          "set",
          "ANTHROPIC_API_KEY",
          "--body",
          apiKey,
        ],
      );
    } else {
      await command(
        "Set Claude Access Token in `secrets.CLAUDE_ACCESS_TOKEN`.",
        [
          gh,
          "secret",
          "set",
          "CLAUDE_ACCESS_TOKEN",
          "--body",
          accessToken,
        ],
      );
      await command(
        "Set Claude Refresh Token in `secrets.CLAUDE_REFRESH_TOKEN`.",
        [
          gh,
          "secret",
          "set",
          "CLAUDE_REFRESH_TOKEN",
          "--body",
          refreshToken,
        ],
      );
      await command(
        "Set Claude Expires At in `secrets.CLAUDE_EXPIRES_AT`.",
        [
          gh,
          "secret",
          "set",
          "CLAUDE_EXPIRES_AT",
          "--body",
          expiresAt.toString(),
        ],
      );
    }
    label("Create claude_code.yaml");
    final gitDir = await findGitDirectory(Directory.current);
    final workingPath = Directory.current.difference(gitDir);
    await GitClaudeCodeCliCode(
      model: model,
      actionsRepositoryName: uses,
    ).generateFile(
      "${workingPath.isEmpty ? "." : workingPath}/.github/workflows/claude_code.yaml",
    );
  }
}

/// Contents of claude_code.yaml.
///
/// claude_code.yamlの中身。
class GitClaudeCodeCliCode extends CliCode {
  /// Contents of claude_code.yaml.
  ///
  /// claude_code.yamlの中身。
  const GitClaudeCodeCliCode({
    required this.model,
    this.actionsRepositoryName,
  });

  /// Name of the Actions repository to be used.
  ///
  /// 利用するActionsのレポジトリの名前。
  final String? actionsRepositoryName;

  /// Name of the model to be used.
  ///
  /// 利用するモデルの名前。
  final String model;

  @override
  String get name => "claude_code";

  @override
  String get prefix => "claude_code";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create claude_code.yaml for AI Agent using Claude Code. Claude Codeを利用したAIエージェント機能用のclaude_code.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    if (actionsRepositoryName.isEmpty) {
      return """
# AI Agent using Claude Code.
# 
# Claude Codeを利用したAIエージェント機能を追加します。
name: Claude Code
on:
    issue_comment:
        types: [created]
    pull_request_review_comment:
        types: [created]
    issues:
        types: [opened, assigned]
    pull_request_review:
        types: [submitted]

jobs:
    claude:
        if: |
            (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
            (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
            (github.event_name == 'pull_request_review' && contains(github.event.review.body, '@claude')) ||
            (github.event_name == 'issues' && (contains(github.event.issue.body, '@claude') || contains(github.event.issue.title, '@claude')))

        runs-on: ubuntu-latest

        permissions:
            contents: write
            pull-requests: write
            issues: write
            id-token: write

        steps:
            # リポジトリをチェックアウト。
            - name: Checkout repository
              uses: actions/checkout@v4
              with:
                  fetch-depth: 1

            # Set up JDK 17.
            # JDK 17のセットアップ
            - name: Set up JDK 17
              uses: actions/setup-java@v4
              with:
                distribution: microsoft
                java-version: "17.0.10"

            # Install flutter.
            # Flutterのインストール。
            - name: Install flutter
              uses: subosito/flutter-action@v2
              with:
                channel: stable
                cache: true

            # Check flutter version.
            # Flutterのバージョン確認。
            - name: Run flutter version
              run: flutter --version

            # Run flutter pub get
            # Flutterのパッケージを取得。
            - name: Run flutter pub get
              run: flutter pub get

            # Creation of the Assets folder.
            # Assetsフォルダの作成。
            - name: Create assets folder
              run: mkdir -p assets

            # firebaseコマンドをインストール
            - name: Install firebase
              run: npm install -g firebase-tools

            # flutterfireコマンドをインストール
            - name: Install flutterfire
              run: flutter pub global activate flutterfire_cli

            # katanaコマンドをインストール
            - name: Install katana
              run: flutter pub global activate katana_cli

            # Claude Codeを実行
            - name: Run Claude Code
              id: claude
              uses: anthropics/claude-code-action@main
              with:
                  model: $model
                  anthropic_api_key: \${{secrets.ANTHROPIC_API_KEY}}
                  github_token: \${{secrets.GITHUB_TOKEN}}
""";
    } else {
      return """
# AI Agent using Claude Code.
# 
# Claude Codeを利用したAIエージェント機能を追加します。
name: Claude Code
on:
    issue_comment:
        types: [created]
    pull_request_review_comment:
        types: [created]
    issues:
        types: [opened, assigned]
    pull_request_review:
        types: [submitted]

jobs:
    claude:
        if: |
            (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
            (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
            (github.event_name == 'pull_request_review' && contains(github.event.review.body, '@claude')) ||
            (github.event_name == 'issues' && (contains(github.event.issue.body, '@claude') || contains(github.event.issue.title, '@claude')))

        runs-on: ubuntu-latest

        permissions:
            contents: write
            pull-requests: write
            issues: write
            id-token: write

        steps:
            # リポジトリをチェックアウト。
            - name: Checkout repository
              uses: actions/checkout@v4
              with:
                  fetch-depth: 1

            # Set up JDK 17.
            # JDK 17のセットアップ
            - name: Set up JDK 17
              uses: actions/setup-java@v4
              with:
                distribution: microsoft
                java-version: "17.0.10"

            # Install flutter.
            # Flutterのインストール。
            - name: Install flutter
              uses: subosito/flutter-action@v2
              with:
                channel: stable
                cache: true

            # Check flutter version.
            # Flutterのバージョン確認。
            - name: Run flutter version
              run: flutter --version

            # Run flutter pub get
            # Flutterのパッケージを取得。
            - name: Run flutter pub get
              run: flutter pub get

            # Creation of the Assets folder.
            # Assetsフォルダの作成。
            - name: Create assets folder
              run: mkdir -p assets

            # firebaseコマンドをインストール
            - name: Install firebase
              run: npm install -g firebase-tools

            # flutterfireコマンドをインストール
            - name: Install flutterfire
              run: flutter pub global activate flutterfire_cli

            # katanaコマンドをインストール
            - name: Install katana
              run: flutter pub global activate katana_cli

            # Claude Codeを実行
            - name: Run Claude Code
              id: claude
              uses: $actionsRepositoryName
              with:
                  model: $model
                  use_oauth: 'true'
                  claude_access_token: \${{secrets.CLAUDE_ACCESS_TOKEN}}
                  claude_refresh_token: \${{secrets.CLAUDE_REFRESH_TOKEN}}
                  claude_expires_at: \${{secrets.CLAUDE_EXPIRES_AT}}
""";
    }
  }
}
