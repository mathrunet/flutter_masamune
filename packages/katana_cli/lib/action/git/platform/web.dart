// Dart imports:
import 'dart:io';

// Package imports:
import 'package:yaml/yaml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Gibhut Actions build for Web.
///
/// Web用のGibhut Actionsのビルド。
Future<void> buildWeb(
  ExecContext context, {
  required String gh,
  required String appName,
  required int defaultIncrementNumber,
}) async {
  final gitDir = await findGitDirectory(Directory.current);
  final webCode = GithubActionsWebCliCode(
    workingDirectory: gitDir,
    defaultIncrementNumber: defaultIncrementNumber,
  );

  var hostingYamlFile =
      File("${webCode.directory}/firebase-hosting-pull-request.yml");
  if (!hostingYamlFile.existsSync()) {
    hostingYamlFile = File(
        ".dart_tool/katana/firebase-hosting-pull-request-${appName.toLowerCase()}.yml");
  }
  if (!hostingYamlFile.existsSync() &&
      File("${webCode.directory}/build_web_${appName.toLowerCase()}.yaml")
          .existsSync()) {
    return;
  }
  final yaml = hostingYamlFile.existsSync()
      ? loadYaml(await hostingYamlFile.readAsString())
      : {};
  await webCode.generateFile(
    "build_web_${appName.toLowerCase()}.yaml",
    filter: (source) => webCode._additionalFilter(yaml, source),
  );
  if (hostingYamlFile.existsSync() &&
      !File(".dart_tool/katana/firebase-hosting-pull-request-${appName.toLowerCase()}.yml")
          .existsSync()) {
    if (!Directory(".dart_tool/katana").existsSync()) {
      Directory(".dart_tool/katana").createSync(recursive: true);
    }
    await hostingYamlFile.rename(
        ".dart_tool/katana/firebase-hosting-pull-request-${appName.toLowerCase()}.yml");
  }
}

/// Contents of buiod.yaml for Github Actions web.
///
/// Github ActionsのWeb用のbuiod.yamlの中身。
class GithubActionsWebCliCode extends CliCode {
  /// Contents of buiod.yaml for Github Actions web.
  ///
  /// Github ActionsのWeb用のbuiod.yamlの中身。
  const GithubActionsWebCliCode({
    this.workingDirectory,
    this.defaultIncrementNumber = 0,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  /// Increment number.
  ///
  /// インクリメント番号。
  final int defaultIncrementNumber;

  @override
  String get name => "build_web";

  @override
  String get prefix => "build_web";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/workflows";
  }

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
    final workingPath = workingDirectory?.difference(Directory.current);
    return """
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

    defaults:
      run:
        working-directory: ${workingPath.isEmpty ? "." : workingPath}

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

      # Creation of the Assets folder.
      # Assetsフォルダの作成。
      - name: Create assets folder
        run: mkdir -p assets

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
        run: flutter build web --build-number \$((\$GITHUB_RUN_NUMBER+$defaultIncrementNumber)) --release --dart-define=FLAVOR=prod --web-renderer html

      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload web artifacts
        uses: actions/upload-artifact@v2
        with:
          name: web_release
          path: ${workingPath.isEmpty ? "." : workingPath}/build/web
          retention-days: 1
""";
  }

  String _additionalFilter(Map yaml, String source) {
    if (yaml.isEmpty) {
      return source;
    }
    final jobs = yaml.getAsMap("jobs");
    final buildAndPreview = jobs.getAsMap("build_and_preview");
    final steps = buildAndPreview.getAsList("steps");
    final workingPath = workingDirectory?.difference(Directory.current);
    var repoToken = "";
    var firebaseServiceAccount = "";
    var projectId = "";
    for (final step in steps) {
      if (step is! Map) {
        continue;
      }
      final uses = step.get("uses", "");
      if (!uses.startsWith("FirebaseExtended")) {
        continue;
      }
      final withs = step.getAsMap("with");
      repoToken = withs.get("repoToken", "");
      firebaseServiceAccount = withs.get("firebaseServiceAccount", "");
      projectId = withs.get("projectId", "");
    }
    if (repoToken.isEmpty ||
        firebaseServiceAccount.isEmpty ||
        projectId.isEmpty) {
      return source;
    }
    source += """

      # A copy of the generated file.
      # 生成されたファイルのコピー。
      - name: Copy file to firebase hosting
        run: |
          cp -r ./build/web/* ./firebase/hosting

      # Deploy to Firebase Hosting.
      # Firebase Hostingへのデプロイ。
      - name: Deploy to Firebase Hosting
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          entryPoint: ${workingPath.isEmpty ? "." : workingPath}/firebase
          repoToken: $repoToken
          firebaseServiceAccount: $firebaseServiceAccount
          channelId: live
""";
    return source;
  }
}
