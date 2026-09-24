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
import "package:katana_cli/action/app/handover.dart";
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
import "package:katana_cli/action/cloudflare/authentication.dart";
import "package:katana_cli/action/cloudflare/d1.dart";
import "package:katana_cli/action/cloudflare/durable_object.dart";
import "package:katana_cli/action/cloudflare/init.dart";
import "package:katana_cli/action/cloudflare/kv.dart";
import "package:katana_cli/action/cloudflare/storage.dart";
import "package:katana_cli/action/cloudflare/tidb.dart";
import "package:katana_cli/action/cloudflare/turso.dart";
import "package:katana_cli/action/ecosystem/ecosystem.dart";
import "package:katana_cli/action/firebase/algolia.dart";
import "package:katana_cli/action/firebase/authentication.dart";
import "package:katana_cli/action/firebase/dynamic_links.dart";
import "package:katana_cli/action/firebase/firestore.dart";
import "package:katana_cli/action/firebase/init.dart";
import "package:katana_cli/action/firebase/messaging.dart";
import "package:katana_cli/action/firebase/scheduler.dart";
import "package:katana_cli/action/firebase/terms_and_privacy.dart";
import "package:katana_cli/action/firebase/workflow.dart";
import "package:katana_cli/action/git/action.dart";
import "package:katana_cli/action/git/hook.dart";
import "package:katana_cli/action/git/status_check.dart";
import "package:katana_cli/action/mail/send_grid.dart";
import "package:katana_cli/action/purchase/purchase.dart";
import "package:katana_cli/action/stripe/stripe.dart";
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/src/android_manifest.dart";

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
  CloudflareInitCliAction(),
  CloudflareAuthenticationCliAction(),
  CloudflareKvCliAction(),
  CloudflareStorageCliAction(),
  CloudflareTursoCliAction(),
  CloudflareTidbCliAction(),
  CloudflareD1CliAction(),
  CloudflareDurableObjectCliAction(),
  FirebaseInitCliAction(),
  FirebaseAuthenticationCliAction(),
  FirebaseSchedulerCliAction(),
  FirebaseMessagingCliAction(),
  FirebaseDynamicLinksCliAction(),
  FirebaseAlogliaCliAction(),
  FirebaseTermsAndPrivacyCliAction(),
  FirebaseFirestoreCliAction(),
  FirebaseWorkflowCliAction(),
  GitActionCliAction(),
  GitStatusCheckCliAction(),
  GitPreCommitCliAction(),
  AppOpenAICliAction(),
  AppAnimateCliAction(),
  AppIntroductionCliAction(),
  AppForceUpdaterCliAction(),
  AppHandoverCliAction(),
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
  MailSendGridCliAction(),
  AppGeocodingCliAction(),
  EcosystemCliAction(),
  AndroidManifestQueryFinalizeCliAction(),
  AndroidManifestPlaceholderFinalizeCliAction(),
];

/// 全プラグインの設定後に、ブラウザ認証に必要なManifest queryを整えます。
class AndroidManifestQueryFinalizeCliAction extends CliCommand
    with CliActionMixin {
  /// Manifest queryの最終処理。
  const AndroidManifestQueryFinalizeCliAction();

  @override
  String get description => "AndroidManifestのqueryを修復し、ブラウザ認証の設定を反映します。";

  @override
  bool checkEnabled(ExecContext context) =>
      const AndroidManifestQuerySynchronizer().hasFile;

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final authentication = firebase.getAsMap("authentication");
    await const AndroidManifestQuerySynchronizer().apply(enable: [
      if (firebase.get("project_id", "").isNotEmpty &&
          authentication.get("enable", false))
        AndroidManifestQueryType.customTabs,
    ]);
  }
}

/// Synchronizes Dart define placeholders in AndroidManifest with Gradle.
///
/// AndroidManifestのDart defineプレースホルダーをGradleと同期します。
class AndroidManifestPlaceholderFinalizeCliAction extends CliCommand
    with CliActionMixin {
  /// Synchronizes Dart define placeholders in AndroidManifest with Gradle.
  ///
  /// AndroidManifestのDart defineプレースホルダーをGradleと同期します。
  const AndroidManifestPlaceholderFinalizeCliAction();

  @override
  String get description =>
      "Synchronize AndroidManifest Dart define placeholders with Gradle. AndroidManifestのDart defineプレースホルダーをGradleと同期します。";

  @override
  bool checkEnabled(ExecContext context) =>
      const AndroidManifestPlaceholderSynchronizer().hasFiles;

  @override
  Future<void> exec(ExecContext context) async {
    const synchronizer = AndroidManifestPlaceholderSynchronizer();
    label("Synchronize AndroidManifest Dart define placeholders.");
    await synchronizer.apply();
  }
}

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
      "Reflect the settings in katana.yaml in the application project. katana.yamlの設定をアプリケーションプロジェクトに反映させます。--local は導入済み依存と初期設定を検証し、依存変更・外部設定・デプロイを行わずローカル設定を反映します。未対応の外部設定が有効な場合は失敗します。--only <name,...> は名前（例: tidb, turso, storage）に一致する有効なアクションだけを実行します。";

  @override
  String? get example =>
      "katana apply [--local] [--only <name,...>] [--flavor dev|prod]";

  @override
  Future<void> exec(ExecContext context) async {
    await runApplyCommands(() => _apply(context),
        local: context.args.contains("--local"));
  }

  Future<void> _apply(ExecContext context) async {
    final only = _onlyFilters(context.args);
    final enabled = _actions
        .where((element) => element.checkEnabled(context))
        .where((element) => only.isEmpty || _matchesOnly(element, only))
        .toList();
    if (only.isNotEmpty && enabled.isEmpty) {
      throw StateError("--only に一致する有効なアクションがありません: ${only.join(", ")}");
    }
    if (isLocalApply) {
      for (final action in enabled) {
        if (action is AppSpreadSheetCliAction ||
            action is StripeCliAction ||
            action is FirebaseSchedulerCliAction ||
            action is CloudflareAuthenticationCliAction ||
            action is CloudflareKvCliAction ||
            action is CloudflareTidbCliAction ||
            action is CloudflareD1CliAction ||
            action is CloudflareDurableObjectCliAction) {
          throw StateError(
              "--local 未対応の外部設定があります: ${action.runtimeType}。設定を無効化せず個別の対応を確認してください。");
        }
      }
      const cloudflare = CloudflareInitCliAction();
      if (cloudflare.checkEnabled(context)) {
        cloudflare.validateLocal(context);
      }
      const turso = CloudflareTursoCliAction();
      if (turso.checkEnabled(context)) {
        turso.validateLocal(context);
      }
      const storage = CloudflareStorageCliAction();
      if (storage.checkEnabled(context)) {
        storage.validateLocal(context);
      }
      const firebase = FirebaseInitCliAction();
      if (firebase.checkEnabled(context)) {
        await firebase.validateLocal(context);
      }
    }
    if (only.isNotEmpty) {
      label("--only: ${enabled.map(_actionName).join(", ")} のみ実行します。");
    }
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
      if (isError) {
        throw StateError("設定反映に失敗しました: ${action.runtimeType}");
      }
    }
  }
}

/// `--only a,b` / `--only=a,b` を小文字のトークン一覧へ正規化する。
List<String> _onlyFilters(List<String> args) {
  final tokens = <String>[];
  for (var i = 0; i < args.length; i++) {
    final argument = args[i];
    String? value;
    if (argument == "--only" && i + 1 < args.length) {
      value = args[++i];
    } else if (argument.startsWith("--only=")) {
      value = argument.substring("--only=".length);
    }
    if (value == null) {
      continue;
    }
    tokens.addAll(value
        .split(",")
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty));
  }
  return tokens;
}

/// `CloudflareTidbCliAction` → `cloudflaretidb` のように比較用の名前へ変換する。
String _actionName(CliCommand action) =>
    action.runtimeType.toString().toLowerCase().replaceAll("cliaction", "");

bool _matchesOnly(CliCommand action, List<String> only) {
  final name = _actionName(action);
  return only.any((token) => name == token || name.endsWith(token));
}
