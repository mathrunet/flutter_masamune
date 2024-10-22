// Dart imports:
import 'dart:io';

// Package imports:
import 'package:yaml/yaml.dart';

// Project imports:
import 'package:katana_cli/action/app/spread_sheet.dart';
import 'package:katana_cli/action/git/platform/web.dart';
import 'package:katana_cli/action/post/firebase_deploy_post_action.dart';
import 'package:katana_cli/katana_cli.dart';

/// Unique key for getting application name.
///
/// アプリケーション名を取得するためのユニークなキーです。
const kApplicationNameKey = r"${ApplicationName}";

/// Unique key for getting application support mail.
///
/// アプリケーションサポートメールを取得するためのユニークなキーです。
const kSuuportEmailKey = r"${SupportEmail}";

/// Unique key to obtain AppID for AppStore.
///
/// AppStore用のAppIDを取得するためのユニークなキーです。
const kAppleAppIdKey = r"${AppleAppId}";

/// Unique key to obtain the application ID.
///
/// アプリケーションIDを取得するためのユニークなキーです。
const kApplicationIdKey = r"${ApplicationId}";

/// Set up a Terms of Use and Privacy Policy for Firebase Hosting.
///
/// 利用規約とプライバシーポリシーをFirebase Hostingに設定します。
class FirebaseTermsAndPrivacyCliAction extends CliCommand with CliActionMixin {
  /// Set up a Terms of Use and Privacy Policy for Firebase Hosting.
  ///
  /// 利用規約とプライバシーポリシーをFirebase Hostingに設定します。
  const FirebaseTermsAndPrivacyCliAction();

  @override
  String get description =>
      "Set up a Terms of Use and Privacy Policy for Firebase Hosting. Firebase Hostingに利用規約とプライバシーポリシーを設定します。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final hosting = firebase.getAsMap("hosting").get("enable", false);
    final termsAndPrivacy =
        firebase.getAsMap("terms_and_privacy").get("enable", false);
    return projectId.isNotEmpty && hosting && termsAndPrivacy;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final termsAndPrivacy = firebase.getAsMap("terms_and_privacy");
    final appInfo = context.yaml.getAsMap("app").getAsMap("info");
    final appInfoLocales = appInfo.getAsMap("locale");
    final pubspecFile = File("pubspec.yaml");
    final yaml = modifize(loadYaml(await pubspecFile.readAsString())) as Map;
    final appName = yaml.get("name", "");
    final gitDir = await findGitDirectory(Directory.current);
    final webCode = GithubActionsWebCliCode(
      workingDirectory: gitDir,
    );

    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    final firebaseDir = Directory("firebase");
    if (!firebaseDir.existsSync()) {
      error(
        "The directory `firebase` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    final hostingDir = Directory("firebase/hosting");
    if (!hostingDir.existsSync()) {
      error(
        "The directory `firebase/hosting` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    final spreadSheetsFile = File(kGoogleSpreadSheetPath);
    final spreadSheets = spreadSheetsFile.existsSync()
        ? jsonDecodeAsMap(await spreadSheetsFile.readAsString())
        : null;
    label("Set up a Terms of Use and Privacy Policy for Firebase Hosting.");
    for (final locale in termsAndPrivacy.entries) {
      if (locale.key == "enable" || locale.key == "support_email") {
        continue;
      }
      final value = locale.value as Map;
      final termsUrl = value.get("terms_of_use", "");
      final privacyUrl = value.get("privacy_policy", "");
      final deleteUrl = value.get("how_to_delete", "");
      final indexUrl = value.get("index", "");
      if (termsUrl.isEmpty) {
        error(
          "The item [firebase]->[terms_and_privacy]->[${locale.key}]->[terms_of_use] is missing. Please provide the URL of the Terms of Use.",
        );
        return;
      }
      if (privacyUrl.isEmpty) {
        error(
          "The item [firebase]->[terms_and_privacy]->[${locale.key}]->[privacy_policy] is missing. Please provide the URL of the Privacy Policy.",
        );
        return;
      }
      if (deleteUrl.isEmpty) {
        error(
          "The item [firebase]->[terms_and_privacy]->[${locale.key}]->[how_to_delete] is missing. Please provide the URL of the How to delete.",
        );
        return;
      }
      final termsResponse = await Api.get(termsUrl);
      if (termsResponse.statusCode != 200) {
        error(
          "The URL of the Terms of Use is invalid. Please provide the URL of the Terms of Use.",
        );
        return;
      }
      final privacyResponse = await Api.get(privacyUrl);
      if (privacyResponse.statusCode != 200) {
        error(
          "The URL of the Privacy Policy is invalid. Please provide the URL of the Privacy Policy.",
        );
        return;
      }
      final deleteResponse = await Api.get(deleteUrl);
      if (deleteResponse.statusCode != 200) {
        error(
          "The URL of the How to delete is invalid. Please provide the URL of the How to delete.",
        );
        return;
      }
      final entry = spreadSheets?.entries
              .firstWhereOrNull((item) => item.key == locale.key) ??
          spreadSheets?.entries.firstWhereOrNull((item) => item.key == "en") ??
          spreadSheets?.entries.firstOrNull;
      final entryValue =
          entry == null ? null : (entry.value as Map<String, dynamic>);
      final applicationName = entryValue.get(
        "title",
        appInfoLocales.getAsMap(locale.key).get(
              "title",
              value.get("app_title", ""),
            ),
      );
      final supportEmail = entryValue.get(
        "support_email",
        entryValue.get("email", appInfo.get("email", "")),
      );
      if (applicationName.isEmpty) {
        error(
          "The item [app]->[info]->[locale]->[locale_name]->[title] is missing. Please provide the application title.",
        );
        return;
      }
      if (supportEmail.isEmpty) {
        error(
          "The item [app]->[info]->[email] is missing. Please provide the support email.",
        );
        return;
      }
      final termsContent = termsResponse.body
          .replaceAll(kApplicationNameKey, applicationName)
          .replaceAll(kSuuportEmailKey, "mailto:$supportEmail");
      final privacyContent = privacyResponse.body
          .replaceAll(kApplicationNameKey, applicationName)
          .replaceAll(kSuuportEmailKey, "mailto:$supportEmail");
      final deleteContent = deleteResponse.body
          .replaceAll(kApplicationNameKey, applicationName)
          .replaceAll(kSuuportEmailKey, "mailto:$supportEmail");
      final dir = Directory("firebase/hosting/${locale.key}");
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final termsFile = File("firebase/hosting/${locale.key}/terms.html");
      await termsFile.writeAsString(termsContent);
      final privacyFile = File("firebase/hosting/${locale.key}/privacy.html");
      await privacyFile.writeAsString(privacyContent);
      final deleteFile = File("firebase/hosting/${locale.key}/delete.html");
      await deleteFile.writeAsString(deleteContent);
      if (indexUrl.isNotEmpty) {
        final appleAppId = appInfo.get("apple_app_id", "");
        if (appleAppId.isEmpty) {
          error(
            "The item [app]->[info]->[apple_app_id] is missing. Please provide the apple app id.",
          );
          return;
        }
        final gradle = AppGradle();
        await gradle.load();
        final androidApplicationId = gradle.android?.defaultConfig.applicationId
            .trim()
            .replaceAll('"', "")
            .replaceAll("'", "");
        if (androidApplicationId.isEmpty) {
          error(
            "Android application ID is not set, please set applicationId in andoird/app/build.gradle.",
          );
          return;
        }
        final indexResponse = await Api.get(indexUrl);
        if (indexResponse.statusCode != 200) {
          error(
            "The URL of index page is invalid. Please provide the URL of the index page.",
          );
          return;
        }
        final indexContent = indexResponse.body
            .replaceAll(kApplicationNameKey, applicationName)
            .replaceAll(kSuuportEmailKey, "mailto:$supportEmail")
            .replaceAll(kAppleAppIdKey, "id${appleAppId.replaceAll("id", "")}")
            .replaceAll(
              kApplicationIdKey,
              androidApplicationId ?? "",
            );
        final indexFile = File("firebase/hosting/${locale.key}/index.html");
        await indexFile.writeAsString(indexContent);
      }
    }
    if (File("${webCode.directory}/build_web_${appName.toLowerCase()}.yaml")
        .existsSync()) {
      // ignore: avoid_print
      print(
        "build_web_${appName.toLowerCase()}.yaml already exists. Skip deployment to Hosting.",
      );
      return;
    }
    context.requestFirebaseDeploy(FirebaseDeployPostActionType.hosting);
    // await command(
    //   "Deploy to Firebase Hosting.",
    //   [
    //     firebaseCommand,
    //     "deploy",
    //     "--only",
    //     "hosting",
    //   ],
    //   workingDirectory: "firebase",
    // );
  }
}
