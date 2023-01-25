// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Gibhut Actions build for Web.
///
/// Web用のGibhut Actionsのビルド。
Future<void> buildWeb(
  ExecContext context, {
  required String gh,
}) async {
  await const GithubActionsWebCliCode().generateFile("build_web.yaml");
}

/// Contents of buiod.yaml for Github Actions web.
///
/// Github ActionsのWeb用のbuiod.yamlの中身。
class GithubActionsWebCliCode extends CliCode {
  /// Contents of buiod.yaml for Github Actions web.
  ///
  /// Github ActionsのWeb用のbuiod.yamlの中身。
  const GithubActionsWebCliCode();

  @override
  String get name => "build_web";

  @override
  String get prefix => "build_web";

  @override
  String get directory => ".github/workflows";

  @override
  String get description =>
      "Create a buiod.yaml for Github Actions for the web, please set up Firebase in advance to upload to Firebase hosting. Github ActionsのWeb用のbuiod.yamlを作成します。Firebase hostingにアップロードするため事前にFirebaseの設定を行ってください。";

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
    return r"""
# Build and upload a Flutter web app.
# 
# The built related files will be stored in Github storage. (storage expires in 1 day)
# 
# FlutterのWebアプリをビルドしアップロードします。
#
# ビルドされた関連ファイルがGithubのストレージに保管されます。（保管期限1日）
name: WebProductionWorkflow

on:
  # This workflow runs when there is a push on the publish branch.
  # publish branch に push があったらこの workflow が走る。
  push:
    branches: [ publish ]

jobs:
  # ----------------------------------------------------------------- #
  # Build for Web
  # ----------------------------------------------------------------- #
  build_web:

    runs-on: ubuntu-latest

    steps:
      # Check-out.
      # チェックアウト。
      - name: Checks-out my repository
        uses: actions/checkout@v2

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

      # Download package.
      # パッケージのダウンロード。
      - name: Download flutter packages
        run: flutter pub get

      # Running flutter analyze.
      # Flutter analyzeの実行。
      - name: Analyzing flutter project
        run: flutter analyze

      # Running the flutter test.
      # Flutter testの実行。
      - name: Testing flutter project
        run: flutter test

      # Generate web files.
      # Webファイルを生成。
      - name: Building web build
        run: flutter build web --build-number ${GITHUB_RUN_NUMBER} --release --dart-define=FLAVOR=prod --web-renderer html

      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload aab artifacts
        uses: actions/upload-artifact@v2
        with:
          name: web_release
          path: ./build/web
          retention-days: 1
""";
  }
}
