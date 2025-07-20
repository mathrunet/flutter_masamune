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
    await GitStatusCheckActionCliCode(
      workingDirectory: gitDir,
    ).generateFile("action.yaml");
    await GitStatusCheckCliCode(
      workingDirectory: gitDir,
    ).generateFile("status_check.yaml");
  }
}

/// Contents of status_check.yaml.
///
/// status_check.yamlの中身。
class GitStatusCheckCliCode extends CliCode {
  /// Contents of status_check.yaml.
  ///
  /// status_check.yamlの中身。
  const GitStatusCheckCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "status_check";

  @override
  String get prefix => "status_check";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/workflows";
  }

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
    final workingPath = workingDirectory?.difference(Directory.current);
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
      - claude/**/*
      - publish

jobs:
  # ----------------------------------------------------------------- #
  # Status check
  # ----------------------------------------------------------------- #
  status_check:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    defaults:
      run:
        working-directory: ${workingPath.isEmpty ? "." : workingPath}
    steps:
      # Check-out.
      # チェックアウト。
      - name: Checks-out my repository
        timeout-minutes: 10
        uses: actions/checkout@v4

      # Flutter status check.
      # Flutterのステータスチェックを行います。
      - name: Flutter status check
        timeout-minutes: 30
        uses: ./.github/actions/status_check
""";
  }
}

/// Contents of status_check.yaml.
///
/// status_check.yamlの中身。
class GitStatusCheckActionCliCode extends CliCode {
  /// Contents of status_check.yaml.
  ///
  /// status_check.yamlの中身。
  const GitStatusCheckActionCliCode({
    this.workingDirectory,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  @override
  String get name => "action";

  @override
  String get prefix => "action";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/actions/status_check";
  }

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
name: FlutterStatusCheckActions
description: "Checking Flutter status. Flutterのステータスチェックを行います。"
runs:
  using: "composite"
  steps:
    # Check-out.
    # リポジトリをチェックアウト。
    - name: Checkout repository
      uses: actions/checkout@v4

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
      shell: bash
      run: flutter --version

    # Run flutter pub get
    # Flutterのパッケージを取得。
    - name: Run flutter pub get
      shell: bash
      run: flutter pub get

    # Creation of the Assets folder.
    # Assetsフォルダの作成。
    - name: Create assets folder
      shell: bash
      run: mkdir -p assets

    # katanaコマンドをインストール
    - name: Install katana
      shell: bash
      run: flutter pub global activate katana_cli

    # Install FlutterFire CLI.
    # FlutterFire CLIをインストール。
    - name: Install FlutterFire CLI
      shell: bash
      run: flutter pub global activate flutterfire_cli

    # Running flutter analyze.
    # Flutter analyzeとcustom_lintの実行。
    - name: Analyzing flutter project
      shell: bash
      run: flutter analyze && dart run custom_lint

    # Running the flutter test.
    # Flutter testの実行。
    - name: Testing flutter project
      shell: bash
      run: katana test run

    # Upload golden test failures.
    # 差分画像をアップロード（失敗時のみ）
    - name: Upload golden test failures
      if: failure()
      uses: actions/upload-artifact@v4
      with:
        name: golden-test-failures
        path: "test/**/failures/**/*.png"
""";
  }
}
