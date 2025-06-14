// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Check the status of the commit.
///
/// コミットの状態を確認します。
class GitStatusCheckCliAction extends CliCommand with CliActionMixin {
  /// Check the status of the commit.
  ///
  /// コミットの状態を確認します。
  const GitStatusCheckCliAction();

  @override
  String get description => "Check the status of the commit. コミットの状態を確認します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("github").getAsMap("status_check");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    label("Create status_check.yaml");
    final gitDir = await findGitDirectory(Directory.current);
    final workingPath = Directory.current.difference(gitDir);
    await const GitStatusCheckCliCode().generateFile(
      "${workingPath.isEmpty ? "." : workingPath}/.github/workflows/status_check.yaml",
    );
  }
}

/// Contents of status_check.yaml.
///
/// status_check.yamlの中身。
class GitStatusCheckCliCode extends CliCode {
  /// Contents of status_check.yaml.
  ///
  /// status_check.yamlの中身。
  const GitStatusCheckCliCode();

  @override
  String get name => "status_check";

  @override
  String get prefix => "status_check";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create status_check.yaml for status check. status check用のstatus_check.yamlを作成します。";

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
    return """
# Flutter status check.
# 
# Flutterのステータスチェックを行います。
name: FlutterStatusCheckWorkflow
on:
  # This workflow is run when there is a push to the branch in question.
  # 該当のブランチ に push があったらこの workflow が走る。
  pull_request:
  push:
    branches:
      - feature/**/*
      - publish

jobs:
  status_check:

    runs-on: ubuntu-latest
    timeout-minutes: 30

    defaults:
      run:
        working-directory: .

    steps:
      # Check-out.
      # リポジトリをチェックアウト。
      - name: Checkout repository
        timeout-minutes: 10
        uses: actions/checkout@v4

      # Set up JDK 17.
      # JDK 17のセットアップ
      - name: Set up JDK 17
        timeout-minutes: 10
        uses: actions/setup-java@v4
        with:
          distribution: microsoft
          java-version: "17.0.10"

      # Install flutter.
      # Flutterのインストール。
      - name: Install flutter
        timeout-minutes: 10
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      # Check flutter version.
      # Flutterのバージョン確認。
      - name: Run flutter version
        run: flutter --version
        timeout-minutes: 3

      # Run flutter pub get
      # Flutterのパッケージを取得。
      - name: Run flutter pub get
        run: flutter pub get
        timeout-minutes: 3

      # Creation of the Assets folder.
      # Assetsフォルダの作成。
      - name: Create assets folder
        run: mkdir -p assets
        timeout-minutes: 3

      # katanaコマンドをインストール
      - name: Install katana
        run: flutter pub global activate katana_cli
        timeout-minutes: 3

      # Running flutter analyze.
      # Flutter analyzeとcustom_lintの実行。
      - name: Analyzing flutter project
        run: flutter analyze && dart run custom_lint
        timeout-minutes: 10

      # Running the flutter test with Xvfb for golden tests.
      # Flutter testの実行（ゴールデンテスト用にXvfbを使用）。
      - name: Testing flutter project
        run: katana test run
        timeout-minutes: 30

      # Upload golden test failures.
      # 差分画像をアップロード（失敗時のみ）
      - name: Upload golden test failures
        if: failure()
        timeout-minutes: 10
        uses: actions/upload-artifact@v4
        with:
          name: golden-test-failures
          path: "test/**/failures/**/*.png"
""";
  }
}
