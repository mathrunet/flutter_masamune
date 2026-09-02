// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/git/status_check.dart";
import "package:katana_cli/katana_cli.dart";

/// Gibhut Actions build for Android.
///
/// Android用のGibhut Actionsのビルド。
Future<void> buildAndroid(
  ExecContext context, {
  required String gh,
  required String appName,
  required int defaultIncrementNumber,
}) async {
  final github = context.yaml.getAsMap("github");
  final action = github.getAsMap("action");
  final android = action.getAsMap("android");
  final changesNotSentForReview =
      android.get("changes_not_sent_for_review", nullOfBool);
  final status = android.get("status", "draft");
  final keystoreFile = File("android/app/appkey.keystore");
  final secretGithub = context.secrets.getAsMap("github");
  final slack = secretGithub.getAsMap("slack");
  final slackIncomingWebhookUrl = slack.get("incoming_webhook_url", "");
  if (!keystoreFile.existsSync()) {
    error(
      "Cannot find `android/app/appkey.keystore`. Run `katana app keystore` to create the keystore file. `android/app/appkey.keystore`が見つかりません。`katana app keystore`を実行しキーストアのファイルを作成してください。",
    );
    return;
  }
  final keyPropertiesFile = File("android/key.properties");
  if (!keyPropertiesFile.existsSync()) {
    error(
      "Cannot find `android/key.properties`. Run `katana app keystore` to create the keystore file. `android/key.properties`が見つかりません。`katana app keystore`を実行しキーストアのファイルを作成してください。",
    );
    return;
  }
  final serviceAccountFile = await find(
    Directory("android"),
    RegExp("([a-z0-9_-]+).json"),
    recursive: false,
  );
  if (serviceAccountFile == null) {
    error(
      "Json for service account not found, please refer to https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b to set it up. サービスアカウント用のJsonが見つかりません。https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b を参考に設定してください。",
    );
    return;
  }
  final gradle = AppGradle();
  await gradle.load();
  final packageName = gradle.android?.defaultConfig.applicationId;
  if (packageName == null) {
    error(
      "Cannot find [android]->[defaultConfig]->[applicationId] in `android/app/build.gradle`.",
    );
    return;
  }
  final keystore = base64.encode(await keystoreFile.readAsBytes());
  final keyProperties = base64.encode(await keyPropertiesFile.readAsBytes());
  final serviceAccount = base64.encode(await serviceAccountFile.readAsBytes());
  await command(
    "Store `appkey.keystore` in `secrets.ANDROID_KEYSTORE_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "ANDROID_KEYSTORE_${appName.toUpperCase()}",
      "--body",
      keystore,
    ],
  );
  await command(
    "Store `key.properties` in `secrets.ANDROID_KEY_PROPERTIES_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "ANDROID_KEY_PROPERTIES_${appName.toUpperCase()}",
      "--body",
      keyProperties,
    ],
  );
  await command(
    "Store `service_account.json` in `secrets.ANDROID_SERVICE_ACCOUNT_KEY_JSON_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "ANDROID_SERVICE_ACCOUNT_KEY_JSON_${appName.toUpperCase()}",
      "--body",
      serviceAccount,
    ],
  );
  final gitDir = await findGitDirectory(Directory.current);
  await GitStatusCheckActionCliCode(
    workingDirectory: gitDir,
  ).generateFile("action.yaml");
  final androidCode = GithubActionsAndroidCliCode(
    workingDirectory: gitDir,
    defaultIncrementNumber: defaultIncrementNumber,
    changesNotSentForReview: changesNotSentForReview,
    status: status,
  );
  await androidCode.generateFile(
    "build_android_${appName.toLowerCase()}.yaml",
    filter: (value) {
      return androidCode._additionalSlackFilter(
        value
            .replaceAll(
              "#### REPLACE_ANDROID_PACKAGE_NAME ####",
              packageName.replaceAll('"', ""),
            )
            .replaceAll(
              "#### REPLACE_APP_NAME ####",
              appName.toUpperCase(),
            ),
        slackIncomingWebhookUrl,
      );
    },
  );
  label("Rewrite `.gitignore`.");
  final gitignore = File("android/.gitignore");
  if (!gitignore.existsSync()) {
    error("Cannot find `android/.gitignore`. Project is broken.");
    return;
  }
  final gitignores = await gitignore.readAsLines();
  if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
    if (!gitignores.any((e) => e.startsWith("key.properties"))) {
      gitignores.add("key.properties");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.keystore"))) {
      gitignores.add("**/*.keystore");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.jks"))) {
      gitignores.add("**/*.jks");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.p12"))) {
      gitignores.add("**/*.p12");
    }
    if (!gitignores.any((e) => e.startsWith("*.json"))) {
      gitignores.add("*.json");
    }
    if (!gitignores.any((e) => e.startsWith("**/appkey_fingerprint.txt"))) {
      gitignores.add("**/appkey_fingerprint.txt");
    }
    if (!gitignores.any((e) => e.startsWith("**/appkey_password.key"))) {
      gitignores.add("**/appkey_password.key");
    }
  } else {
    gitignores.removeWhere((e) => e.startsWith("**/*.p12"));
    gitignores.removeWhere((e) => e.startsWith("*.json"));
    gitignores.removeWhere((e) => e.startsWith("**/appkey_fingerprint.txt"));
    gitignores.removeWhere((e) => e.startsWith("**/appkey_password.key"));
    gitignores.removeWhere((e) => e.startsWith("key.properties"));
    gitignores.removeWhere((e) => e.startsWith("**/*.keystore"));
    gitignores.removeWhere((e) => e.startsWith("**/*.jks"));
  }
  await gitignore.writeAsString(gitignores.join("\n"));
}

/// Contents of buiod.yaml for Android in Github Actions.
///
/// Github ActionsのAndroid用のbuiod.yamlの中身。
class GithubActionsAndroidCliCode extends CliCode {
  /// Contents of buiod.yaml for Android in Github Actions.
  ///
  /// Github ActionsのAndroid用のbuiod.yamlの中身。
  const GithubActionsAndroidCliCode({
    this.workingDirectory,
    this.defaultIncrementNumber = 0,
    this.changesNotSentForReview,
    this.status = "draft",
    this.slackWebhookURL,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  /// Increment number.
  ///
  /// インクリメント番号。
  final int defaultIncrementNumber;

  /// Parameters of [changesNotSentForReview].
  ///
  /// [changesNotSentForReview]のパラメーター。
  final bool? changesNotSentForReview;

  /// Parameters of [status].
  ///
  /// [status]のパラメーター。
  final String status;

  /// Include the URL of the Incoming webhook if Slack notifications are used.
  ///
  /// Slack通知を利用する場合Incoming webhookのURLを記載。
  final String? slackWebhookURL;

  @override
  String get name => "build_android";

  @override
  String get prefix => "build_android";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/workflows";
  }

  @override
  String get description =>
      "Create buiod.yaml for Android in Github Actions. Please set up your keystore in the katana app keystore beforehand. Also, create the app in Google Play Console, upload the aab file for the first time, and complete the app settings except for the store listing information settings. Github ActionsのAndroid用のbuiod.yamlを作成します。事前にkatana app keystoreでキーストアの設定を行ってください。また、GooglePlayConsoleでアプリを作成し、aabファイルの初回アップロード、アプリの設定でストア掲載情報設定以外を済ませておいてください。";

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
# Build and upload your Flutter Android app.
# 
# apk and aab files will be stored in Github storage. (Storage period is 1 day)
#
# The app is uploaded to GooglePlayConsole in an internal test draft.
#
# Please create a keystore for your app in advance with `katana app keystore`.
#
# Also, please create your app in Google PlayConsole, upload the aab file for the first time, and complete the app settings except for the store listing information settings.
# 
# FlutterのAndroidアプリをビルドしアップロードします。
#
# apkファイルとaabファイルがGithubのストレージに保管されます。（保管期限1日）
# 
# GooglePlayConsoleへアプリが内部テストのドラフトでアップロードされます。
#
# 事前に`katana app keystore`でアプリ用のキーストアを作成しておいてください。
# 
# また、GooglePlayConsoleでアプリを作成し、aabファイルの初回アップロード、アプリの設定でストア掲載情報設定以外を済ませておいてください。
name: AndroidProductionWorkflow

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
  # Build for Android
  # ----------------------------------------------------------------- #
  build_android:
    runs-on: ubuntu-latest
    needs: status_check
    timeout-minutes: 60
    defaults:
      run:
        working-directory: ${workingPath.isEmpty ? "." : workingPath}
    steps:
      # Check-out.
      # チェックアウト。
      - name: Checks-out my repository
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
        timeout-minutes: 3

      # Generate appkey.keystore from Secrets.
      # Secretsからappkey.keystoreを生成。
      - name: Create appkey.keystore
        run: echo -n \${{ secrets.ANDROID_KEYSTORE_#### REPLACE_APP_NAME #### }} | base64 -d > android/app/appkey.keystore
        timeout-minutes: 3

      # Generate service_account_key.json from Secrets.
      # Secretsからservice_account_key.jsonを生成。
      - name: Create service_account_key.json
        run: echo -n \${{ secrets.ANDROID_SERVICE_ACCOUNT_KEY_JSON_#### REPLACE_APP_NAME #### }} | base64 -d > android/service_account_key.json
        timeout-minutes: 3

      # Generate key.properties from Secrets.
      # Secretsからkey.propertiesを生成。
      - name: Create key.properties
        run: echo \${{ secrets.ANDROID_KEY_PROPERTIES_#### REPLACE_APP_NAME #### }} | base64 -d > android/key.properties
        timeout-minutes: 3
      
      # Generate app bundle.
      # App Bundleを生成。
      - name: Building Android AppBundle
        run: flutter build appbundle --build-number \$((\$GITHUB_RUN_NUMBER+$defaultIncrementNumber)) --release --dart-define-from-file=dart_defines/prod.env
        timeout-minutes: 30

      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload aab artifacts
        timeout-minutes: 5
        uses: actions/upload-artifact@v4
        with:
          name: andoroid_aab_release
          path: ${workingPath.isEmpty ? "." : workingPath}/build/app/outputs/bundle/release
          retention-days: 1

      # Upload to Google Play Store.
      # Google Play Storeにアップロード。
      - name: Deploy to Google Play Store
        timeout-minutes: 10
        id: deploy
        uses: r0adkll/upload-google-play@v1
        with:
          track: internal
          # Change to completed after the app is released.
          # アプリをリリースした後は completed に変更してください。
          status: $status 
          serviceAccountJson: ${workingPath.isEmpty ? "." : workingPath}/android/service_account_key.json
          ${changesNotSentForReview != null ? "changesNotSentForReview: ${changesNotSentForReview! ? "true" : "false"}" : "# changesNotSentForReview: true"}
          packageName: #### REPLACE_ANDROID_PACKAGE_NAME ####
          releaseFiles: ${workingPath.isEmpty ? "." : workingPath}/build/app/outputs/bundle/release/*.aab
""";
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
