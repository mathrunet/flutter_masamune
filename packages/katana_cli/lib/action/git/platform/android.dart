import 'dart:convert';
import 'dart:io';

import 'package:katana_cli/katana_cli.dart';

/// Gibhut Actions build for Android.
///
/// Android用のGibhut Actionsのビルド。
Future<void> buildAndroid(
  ExecContext context, {
  required String gh,
}) async {
  final keystoreFile = File("android/app/appkey.keystore");
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
    RegExp("([a-z]+)-([a-z]+)-([0-9]+)-([0-9]+)-([a-z0-9]+).json"),
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
    "Store `appkey.keystore` in `secrets.ANDROID_KEYSTORE`.",
    [
      gh,
      "secret",
      "set",
      "ANDROID_KEYSTORE",
      "--body",
      keystore,
    ],
  );
  await command(
    "Store `key.properties` in `secrets.ANDROID_KEY_PROPERTIES`.",
    [
      gh,
      "secret",
      "set",
      "ANDROID_KEY_PROPERTIES",
      "--body",
      keyProperties,
    ],
  );
  await command(
    "Store `service_account.json` in `secrets.ANDROID_SERVICE_ACCOUNT_KEY_JSON`.",
    [
      gh,
      "secret",
      "set",
      "ANDROID_SERVICE_ACCOUNT_KEY_JSON",
      "--body",
      serviceAccount,
    ],
  );
  await const GithubActionsAndroidCliCode().generateFile(
    "build_android.yaml",
    filter: (value) {
      return value.replaceAll(
        "#### REPLACE_ANDROID_PACKAGE_NAME ####",
        packageName.replaceAll('"', ""),
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
  const GithubActionsAndroidCliCode();

  @override
  String get name => "build_android";

  @override
  String get prefix => "build_android";

  @override
  String get directory => ".github/workflows";

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
    return r"""
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
    branches: [ publish ]

jobs:
  # ----------------------------------------------------------------- #
  # Build for Android
  # ----------------------------------------------------------------- #
  build_android:

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

      # Generate appkey.keystore from Secrets.
      # Secretsからappkey.keystoreを生成。
      - name: Create appkey.keystore
        run: echo -n ${{ secrets.ANDROID_KEYSTORE }} | base64 -d > android/app/appkey.keystore

      # Generate service_account_key.json from Secrets.
      # Secretsからservice_account_key.jsonを生成。
      - name: Create service_account_key.json
        run: echo -n ${{ secrets.ANDROID_SERVICE_ACCOUNT_KEY_JSON }} | base64 -d > android/service_account_key.json

      # Generate key.properties from Secrets.
      # Secretsからkey.propertiesを生成。
      - name: Create key.properties
        run: echo ${{ secrets.ANDROID_KEY_PROPERTIES }} | base64 -d > android/key.properties

      # Generate Apk.
      # Apkを生成。
      - name: Building Android apk
        run: flutter build apk --build-number ${GITHUB_RUN_NUMBER} --release --dart-define=FLAVOR=prod

      # Generate app bundle.
      # App Bundleを生成。
      - name: Building Android AppBundle
        run: flutter build appbundle --build-number ${GITHUB_RUN_NUMBER} --release --dart-define=FLAVOR=prod
      
      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload apk artifacts
        uses: actions/upload-artifact@v2
        with:
          name: andoroid_apk_release
          path: ./build/app/outputs/apk/release
          retention-days: 1

      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload aab artifacts
        uses: actions/upload-artifact@v2
        with:
          name: andoroid_aab_release
          path: ./build/app/outputs/bundle/release
          retention-days: 1

      # Upload to Google Play Store.
      # Google Play Storeにアップロード。
      - name: Deploy to Google Play Store
        id: deploy
        uses: r0adkll/upload-google-play@v1
        with:
          track: internal
          status: draft
          serviceAccountJson: android/service_account_key.json
          packageName: #### REPLACE_ANDROID_PACKAGE_NAME ####
          releaseFiles: ./build/app/outputs/bundle/release/*.aab
""";
  }
}
