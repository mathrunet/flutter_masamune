// Project imports:
import 'dart:io';

import 'package:katana_cli/action/app/spread_sheet.dart';
import 'package:katana_cli/katana_cli.dart';

/// Unique key for getting application name.
///
/// アプリケーション名を取得するためのユニークなキーです。
const kApplicationNameKey = r"${ApplicationName}";

/// Unique key for getting application support mail.
///
/// アプリケーションサポートメールを取得するためのユニークなキーです。
const kSuuportEmailKey = r"${SupportEmail}";

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
    final bin = context.yaml.getAsMap("bin");
    final firebaseCommand = bin.get("firebase", "firebase");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final termsAndPrivacy = firebase.getAsMap("terms_and_privacy");
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
    if (!spreadSheetsFile.existsSync()) {
      error(
        "The file `$kGoogleSpreadSheetPath` does not exist. Set the item [app]->[spread_sheet] and run `katana apply`.",
      );
      return;
    }
    final spreadSheets = jsonDecodeAsMap(await spreadSheetsFile.readAsString());
    label("Set up a Terms of Use and Privacy Policy for Firebase Hosting.");
    for (final locale in termsAndPrivacy.entries) {
      if (locale.key == "enable") {
        continue;
      }
      final value = locale.value as Map;
      final termsUrl = value.get("terms_of_use", "");
      final privacyUrl = value.get("privacy_policy", "");
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
      final entry = spreadSheets.entries
              .firstWhereOrNull((item) => item.key == locale.key) ??
          spreadSheets.entries.firstWhereOrNull((item) => item.key == "en") ??
          spreadSheets.entries.firstOrNull;
      if (entry == null) {
        error(
          "The appropriate application information could not be found. Please check the spreadsheet listed under [app]->[spread_sheet]->[url] for the information you are looking for.",
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
      final entryValue = entry.value as Map<String, dynamic>;
      final applicationName = entryValue.get("title", "");
      final supportEmail =
          entryValue.get("support_email", entryValue.get("email", ""));
      final termsContent = termsResponse.body
          .replaceAll(r"${ApplicationName}", applicationName)
          .replaceAll(r"${SupportEmail}", supportEmail);
      final privacyContent = privacyResponse.body
          .replaceAll(r"${ApplicationName}", applicationName)
          .replaceAll(r"${SupportEmail}", supportEmail);
      final dir = Directory("firebase/hosting/${locale.key}");
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final termsFile = File("firebase/hosting/${locale.key}/terms.html");
      await termsFile.writeAsString(termsContent);
      final privacyFile = File("firebase/hosting/${locale.key}/privacy.html");
      await privacyFile.writeAsString(privacyContent);
    }
    await command(
      "Deploy to Firebase Hosting.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        "hosting",
      ],
      workingDirectory: "firebase",
    );
  }
}
