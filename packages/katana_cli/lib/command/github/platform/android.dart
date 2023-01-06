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
    print(
      "Cannot find `android/app/appkey.keystore`. Run `katana app keystore` to create the keystore file. `android/app/appkey.keystore`が見つかりません。`katana app keystore`を実行しキーストアのファイルを作成してください。",
    );
    return;
  }
  final keyPropertiesFile = File("android/key.properties");
  if (!keyPropertiesFile.existsSync()) {
    print(
      "Cannot find `android/key.properties`. Run `katana app keystore` to create the keystore file. `android/key.properties`が見つかりません。`katana app keystore`を実行しキーストアのファイルを作成してください。",
    );
    return;
  }
  final serviceAccountFile = await find(
    Directory("android"),
    RegExp("([a-z]+)-([a-z]+)-([0-9]+)-([0-9]+)-([a-z0-9]+).json"),
  );
  if (serviceAccountFile == null) {
    print(
      "Json for service account not found, please refer to https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b to set it up. サービスアカウント用のJsonが見つかりません。https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b を参考に設定してください。",
    );
    return;
  }
  final gradle = AppGradle();
  await gradle.load();
  final packageName = gradle.android?.defaultConfig.applicationId;
  if (packageName == null) {
    print(
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
    print("Cannot find `android/.gitignore`. Project is broken.");
    return;
  }
  final gitignores = await gitignore.readAsLines();
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
  await gitignore.writeAsString(gitignores.join("\n"));
}
