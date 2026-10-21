// Dart imports:
import "dart:io";

// Package imports:
import "package:yaml/yaml.dart";

// Project imports:
import "package:katana_cli/action/git/dart_defines.dart";
import "package:katana_cli/action/git/status_check.dart";
import "package:katana_cli/katana_cli.dart";

/// Gibhut Actions build for Web.
///
/// Web用のGibhut Actionsのビルド。
Future<void> buildWeb(
  ExecContext context, {
  required String gh,
  required String appName,
  required int defaultIncrementNumber,
}) async {
  final secretGithub = context.secrets.getAsMap("github");
  final slack = secretGithub.getAsMap("slack");
  final slackIncomingWebhookUrl = slack.get("incoming_webhook_url", "");
  if (!isLocalApply) {
    if (!await registerDartDefinesSecrets(
      gh: gh,
      path: kProductionDartDefinesFile,
      suffix: appName.toUpperCase(),
    )) {
      return;
    }
    if (!await registerDartDefinesSecrets(
      gh: gh,
      path: kDevelopmentDartDefinesFile,
    )) {
      return;
    }
  }
  final gitDir = await findGitDirectory(Directory.current);
  await GitStatusCheckActionCliCode(
    workingDirectory: gitDir,
  ).generateFile("action.yaml");
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
    filter: (source) => webCode._additionalSlackFilter(
      applyDartDefinesToWorkflow(
        webCode._additionalFilter(yaml, source),
        buildNames: dartDefinesEnvironmentNames(kProductionDartDefinesFile),
        statusCheckNames:
            dartDefinesEnvironmentNames(kDevelopmentDartDefinesFile),
        suffix: appName.toUpperCase(),
      ),
      slackIncomingWebhookUrl,
    ),
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
    branches:
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

  # ----------------------------------------------------------------- #
  # Build for Web
  # ----------------------------------------------------------------- #
  build_web:
    runs-on: ubuntu-latest
    needs: status_check
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

      # Install FlutterFire CLI.
      # FlutterFire CLIをインストール。
      - name: Install FlutterFire CLI
        run: flutter pub global activate flutterfire_cli
        timeout-minutes: 3

      # Download package.
      # パッケージのダウンロード。
      - name: Download flutter packages
        run: flutter pub get
        timeout-minutes: 3

      # Creation of the Assets folder.
      # Assetsフォルダの作成。
      - name: Create assets folder
        run: mkdir -p assets

      # Generate web files.
      # Webファイルを生成。
      - name: Building web build
        run: flutter build web --build-number \$((\$GITHUB_RUN_NUMBER+$defaultIncrementNumber)) --release --dart-define-from-file=dart_defines/prod.env
        timeout-minutes: 30

      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload web artifacts
        uses: actions/upload-artifact@v4
        timeout-minutes: 15
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

  String _additionalSlackFilter(
      String source, String? slackIncomingWebhookURL) {
    if (slackIncomingWebhookURL.isEmpty) {
      return source;
    }
    return source += """

      # Slack notification (on success)
      # Slack通知（成功時）
      - name: Slack Notification on Success
        uses: rtCamp/action-slack-notify@v2
        if: \${{success()}}
        env:
          SLACK_USERNAME: Github Actions
          SLACK_TITLE: Deploy / Success
          SLACK_COLOR: good
          SLACK_MESSAGE: Deployment completed.
          SLACK_ICON_EMOJI: ':github:'
          SLACK_WEBHOOK: $slackIncomingWebhookURL

      # Slack notification (on failure)
      # Slack通知（失敗時）
      - name: Slack Notification on Failure
        uses: rtCamp/action-slack-notify@v2
        if: \${{failure()}}
        env:
          SLACK_USERNAME: Github Actions
          SLACK_TITLE: Deploy / Failure
          SLACK_COLOR: danger
          SLACK_MESSAGE: Deployment failed.😢
          SLACK_ICON_EMOJI: ':github:'
          SLACK_WEBHOOK: $slackIncomingWebhookURL
      """;
  }
}
