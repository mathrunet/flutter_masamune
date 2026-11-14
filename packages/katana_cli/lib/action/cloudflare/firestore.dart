// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/authentication.dart";
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// npm package used by the region Worker to access Firestore via the REST API.
///
/// region WorkerがREST API経由でFirestoreにアクセスするためのnpmパッケージ。
const cloudflareFirestorePackage = "@mathrunet/masamune_cloudflare_firestore";

/// Configure Firestore access from the Cloudflare region Worker.
///
/// Cloudflareのregion WorkerからFirestoreへアクセスするための設定を行います。
class CloudflareFirestoreCliAction extends CliCommand with CliActionMixin {
  /// Configure Firestore access from the Cloudflare region Worker.
  ///
  /// Cloudflareのregion WorkerからFirestoreへアクセスするための設定を行います。
  const CloudflareFirestoreCliAction();

  @override
  String get description =>
      "Configure Firestore access (REST API) from the Cloudflare region Worker. Cloudflareのregion WorkerからFirestore（REST API）へアクセスするための設定を行います。";

  @override
  bool checkEnabled(ExecContext context) {
    return context.yaml
        .getAsMap("firebase")
        .getAsMap("firestore")
        .getAsMap("worker_access")
        .get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final firestore = firebase.getAsMap("firestore");
    final projectId = firebase.get("project_id", "");
    if (!isCloudflareRegionWorkerEnabled(context.yaml)) {
      error(
        "[firebase]->[firestore]->[worker_access]->[enable] requires the region Worker. Set [cloudflare]->[workers]->[enable] and [cloudflare]->[workers]->[region]->[enable] to `true`.",
      );
      return;
    }
    if (projectId.isEmpty) {
      error(
        "[firebase]->[project_id] is required when [firebase]->[firestore]->[worker_access]->[enable] is enabled.",
      );
      return;
    }
    if (!Directory("cloudflare").existsSync() ||
        !File(cloudflareRegionEntryPath).existsSync() ||
        !File("cloudflare/$cloudflareRegionWranglerConfig").existsSync()) {
      error(
        "The region Worker (`$cloudflareRegionEntryPath`, `cloudflare/$cloudflareRegionWranglerConfig`) does not exist. Run `katana apply` with [cloudflare]->[workers]->[region]->[enable] set to `true` first.",
      );
      return;
    }
    for (final warning in cloudflareFirestoreWarnings(context.yaml)) {
      label("Warning: $warning");
    }

    String? serviceAccount;
    // `--no-secrets` skips both resolving the service account and putting it.
    if (!isNoSecretsApply) {
      try {
        serviceAccount = await resolveCloudflareFirestoreServiceAccount(
          context,
          projectId: projectId,
        );
      } on StateError catch (e) {
        error(e.message);
        return;
      }
    }

    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    if (!firestore.get("enable", false)) {
      label(
        "Warning: [firebase]->[firestore]->[enable] is `false`. The region Worker can access Firestore, but the app does not use it.",
      );
    }
    try {
      await installMissingCloudflarePackages(
        npm: npm,
        packages: const [cloudflareFirestorePackage],
      );
    } on StateError catch (e) {
      error(e.message);
      return;
    }
    if (isLocalApply) {
      label(
        "Skip putting `GOOGLE_SERVICE_ACCOUNT` to the region Worker in --local mode.",
      );
      return;
    }
    if (serviceAccount == null) {
      label(
        "Skip resolving and setting `GOOGLE_SERVICE_ACCOUNT` to the region Worker (--no-secrets)",
      );
      return;
    }
    await putWranglerSecret(
      wrangler: wrangler,
      environment: flavor,
      name: "GOOGLE_SERVICE_ACCOUNT",
      value: serviceAccount,
      config: cloudflareRegionWranglerConfig,
    );
    label(
      "Firestore REST access is configured for the region Worker. Use `createFirestoreClient(env)` from `$cloudflareFirestorePackage` in your region Worker code.",
    );
  }
}

/// Returns warnings for [yaml] when Firestore worker access is enabled.
///
/// Firestoreのworker_accessが有効な場合の[yaml]に対する警告を返します。
List<String> cloudflareFirestoreWarnings(Map yaml) {
  final firebase = yaml.getAsMap("firebase");
  final firestore = firebase.getAsMap("firestore");
  return [
    if (!firebase.getAsMap("app_check").get("enable", false))
      "[firebase]->[app_check]->[enable] is `false`. Apps access Firestore directly, so enable App Check to block requests from other clients.",
    if (!firestore.get("generate_rules_and_indexes", false))
      "[firebase]->[firestore]->[generate_rules_and_indexes] is `false`. Make sure Firestore Security Rules deny client writes to data written only by the region Worker (billing, permissions, etc.).",
  ];
}

/// Resolves the service account JSON put as `GOOGLE_SERVICE_ACCOUNT` to the region Worker.
///
/// A non-empty `firebase.firestore.service_account` in `katana_secrets.yaml` takes precedence.
/// Otherwise the Cloudflare Authentication / Messaging service account or a unique JSON file
/// under `cloudflare/` / `android/` for [projectId] is used.
///
/// region Workerに`GOOGLE_SERVICE_ACCOUNT`として登録するサービスアカウントJSONを解決します。
///
/// `katana_secrets.yaml`の`firebase.firestore.service_account`が空でなければ優先します。
/// それ以外はCloudflareのAuthentication・Messaging用、または`cloudflare/`・`android/`にある
/// [projectId]用の一意なJSONファイルを使用します。
Future<String> resolveCloudflareFirestoreServiceAccount(
  ExecContext context, {
  required String projectId,
}) async {
  final configured = context.secrets
      .getAsMap("firebase")
      .getAsMap("firestore")
      .get<Object?>("service_account", null);
  if (configured != null && configured is! String) {
    throw StateError(
      "[firebase]->[firestore]->[service_account] in katana_secrets.yaml must be a JSON string resolved for the selected flavor.",
    );
  }
  if (configured is String && configured.trim().isNotEmpty) {
    Object? decoded;
    try {
      decoded = jsonDecode(configured);
    } on FormatException {
      decoded = null;
    }
    if (decoded is! Map ||
        decoded["type"] != "service_account" ||
        decoded["client_email"] is! String ||
        decoded["private_key"] is! String) {
      throw StateError(
        "[firebase]->[firestore]->[service_account] in katana_secrets.yaml is not a valid service account JSON.",
      );
    }
    if (decoded["project_id"] != projectId) {
      throw StateError(
        "[firebase]->[firestore]->[service_account] does not match [firebase]->[project_id] for this flavor.",
      );
    }
    return configured;
  }
  return resolveCloudflareFirebaseServiceAccount(context, projectId: projectId);
}
