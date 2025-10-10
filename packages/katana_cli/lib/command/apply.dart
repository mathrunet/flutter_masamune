// Project imports:
import "package:katana_cli/action/ads/ads.dart";
import "package:katana_cli/action/agora/agora.dart";
import "package:katana_cli/action/ai/openai.dart";
import "package:katana_cli/action/app/animate.dart";
import "package:katana_cli/action/app/app_review.dart";
import "package:katana_cli/action/app/att.dart";
import "package:katana_cli/action/app/calendar.dart";
import "package:katana_cli/action/app/camera.dart";
import "package:katana_cli/action/app/csr.dart";
import "package:katana_cli/action/app/deeplink.dart";
import "package:katana_cli/action/app/force_updater.dart";
import "package:katana_cli/action/app/geocoding.dart";
import "package:katana_cli/action/app/icon.dart";
import "package:katana_cli/action/app/info.dart";
import "package:katana_cli/action/app/introduction.dart";
import "package:katana_cli/action/app/keystore.dart";
import "package:katana_cli/action/app/local_notification.dart";
import "package:katana_cli/action/app/location.dart";
import "package:katana_cli/action/app/p12.dart";
import "package:katana_cli/action/app/picker.dart";
import "package:katana_cli/action/app/privacy_manifests.dart";
import "package:katana_cli/action/app/speech_to_text.dart";
import "package:katana_cli/action/app/spread_sheet.dart";
import "package:katana_cli/action/app/text_to_speech.dart";
import "package:katana_cli/action/ecosystem/ecosystem.dart";
import "package:katana_cli/action/firebase/algolia.dart";
import "package:katana_cli/action/firebase/authentication.dart";
import "package:katana_cli/action/firebase/dynamic_links.dart";
import "package:katana_cli/action/firebase/firestore.dart";
import "package:katana_cli/action/firebase/init.dart";
import "package:katana_cli/action/firebase/messaging.dart";
import "package:katana_cli/action/firebase/scheduler.dart";
import "package:katana_cli/action/firebase/terms_and_privacy.dart";
import "package:katana_cli/action/git/action.dart";
import "package:katana_cli/ai/claude_code.dart";
import "package:katana_cli/action/git/hook.dart";
import "package:katana_cli/action/git/status_check.dart";
import "package:katana_cli/action/mail/gmail.dart";
import "package:katana_cli/action/mail/send_grid.dart";
import "package:katana_cli/action/purchase/purchase.dart";
import "package:katana_cli/action/stripe/stripe.dart";
import "package:katana_cli/katana_cli.dart";

/// Action to be performed.
///
/// Arrange them in the order in which they are to be executed.
///
/// 実行するアクション。
///
/// 実行する順番で並べてください。
const _actions = <CliActionMixin>[
  AppInfoCliAction(),
  AppSpreadSheetCliAction(),
  AppCsrCliAction(),
  AppP12CliAction(),
  AppKeystoreCliAction(),
  AppPickerCliAction(),
  AppIconCliAction(),
  AppDeeplinkCliAction(),
  AppPrivacyManifestsCliAction(),
  FirebaseInitCliAction(),
  FirebaseAuthenticationCliAction(),
  FirebaseSchedulerCliAction(),
  FirebaseMessagingCliAction(),
  FirebaseDynamicLinksCliAction(),
  FirebaseAlogliaCliAction(),
  FirebaseTermsAndPrivacyCliAction(),
  FirebaseFirestoreCliAction(),
  GitActionCliAction(),
  GitClaudeCodeCliAction(),
  GitStatusCheckCliAction(),
  GitPreCommitCliAction(),
  AppOpenAICliAction(),
  AppAnimateCliAction(),
  AppIntroductionCliAction(),
  AppForceUpdaterCliAction(),
  AppReviewCliAction(),
  AppCameraCliAction(),
  AppCalendarCliAction(),
  AppTextToSpeechCliAction(),
  AppSpeechToTextCliAction(),
  AppLocationCliAction(),
  AppLocalNotificationCliAction(),
  AppTrackingTransparencyCliAction(),
  AgoraCliAction(),
  AdsCliAction(),
  PurchaseCliAction(),
  StripeCliAction(),
  MailGmailCliAction(),
  MailSendGridCliAction(),
  AppGeocodingCliAction(),
  EcosystemCliAction(),
];

/// Reflect the settings in katana.yaml in the application project.
///
/// katana.yamlの設定をアプリケーションプロジェクトに反映させます。
class ApplyCliCommand extends CliCommand {
  /// Reflect the settings in katana.yaml in the application project.
  ///
  /// katana.yamlの設定をアプリケーションプロジェクトに反映させます。
  const ApplyCliCommand();

  @override
  String get description =>
      "Reflect the settings in katana.yaml in the application project. katana.yamlの設定をアプリケーションプロジェクトに反映させます。";

  @override
  String? get example => "katana apply";

  @override
  Future<void> exec(ExecContext context) async {
    final enabled =
        _actions.where((element) => element.checkEnabled(context)).toList();
    for (final action in enabled) {
      // ignore: avoid_print
      print(
        """


###############################################################################

${action.description}

###############################################################################

""",
      );
      await action.exec(context);
    }
  }
}
