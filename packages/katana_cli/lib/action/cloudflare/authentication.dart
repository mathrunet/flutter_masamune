// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Configure Firebase Authentication features for Cloudflare Workers.
///
/// Cloudflare Workers向けのFirebase Authentication機能を設定します。
class CloudflareAuthenticationCliAction extends CliCommand with CliActionMixin {
  /// Configure Firebase Authentication features for Cloudflare Workers.
  ///
  /// Cloudflare Workers向けのFirebase Authentication機能を設定します。
  const CloudflareAuthenticationCliAction();

  @override
  String get description =>
      "Configure Firebase Authentication features for Cloudflare Workers. Cloudflare Workers向けのFirebase Authentication機能を設定します。";

  @override
  bool checkEnabled(ExecContext context) {
    return context.yaml
        .getAsMap("cloudflare")
        .getAsMap("authentication")
        .getAsMap("delete_user")
        .get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final workers = cloudflare.getAsMap("workers");
    final firebase = context.yaml.getAsMap("firebase");
    final firebaseProjectId = firebase.get("project_id", "");
    final enableFirebaseAuthentication =
        firebase.getAsMap("authentication").get("enable", false);
    if (!workers.get("enable", false)) {
      error(
        "[cloudflare]->[workers]->[enable] must be true when [cloudflare]->[authentication]->[delete_user]->[enable] is enabled.",
      );
      return;
    }
    if (!workers.get("enable_firebase_auth", false)) {
      error(
        "[cloudflare]->[workers]->[enable_firebase_auth] must be true when the delete-user Worker is enabled.",
      );
      return;
    }
    if (firebaseProjectId.isEmpty) {
      error(
        "[firebase]->[project_id] is required when the delete-user Worker is enabled.",
      );
      return;
    }
    if (!enableFirebaseAuthentication) {
      error(
        "[firebase]->[authentication]->[enable] must be true when the delete-user Worker is enabled.",
      );
      return;
    }
    final cloudflareDir = Directory("cloudflare");
    if (!cloudflareDir.existsSync()) {
      error(
        "The directory `cloudflare` does not exist. Initialize Cloudflare Workers by executing `katana apply`.",
      );
      return;
    }
    final serviceAccount = await resolveCloudflareFirebaseServiceAccount(
      context,
      projectId: firebaseProjectId,
    );

    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final indexFile = File("cloudflare/src/index.ts");
    if (indexFile.existsSync()) {
      CloudflareSourceUtils.validateFirebaseProjectId(
        await indexFile.readAsString(),
        firebaseProjectId,
      );
    }
    await addFlutterImport(
      [
        "masamune_auth_firebase",
        "masamune_functions_cloudflare",
      ],
    );
    label("Add Cloudflare Workers delete-user function");
    final applied = await applyCloudflareWorkersFunctions(
      alias: "auth",
      package: "@mathrunet/masamune_cloudflare_auth",
      functions: {
        "auth.Functions.deleteUser": "    auth.Functions.deleteUser(),",
      },
      replaceExisting: false,
    );
    if (!applied) {
      return;
    }
    await installMissingCloudflarePackages(
      npm: npm,
      packages: const ["@mathrunet/masamune_cloudflare_auth"],
    );
    await putWranglerSecret(
      wrangler: wrangler,
      environment: flavor,
      name: "GOOGLE_SERVICE_ACCOUNT",
      value: serviceAccount,
    );
  }
}

/// Resolves one Firebase Admin SDK credential for a Cloudflare Worker flavor.
///
/// Explicit Authentication and Messaging values must identify the same key.
/// File discovery only accepts a unique key for the selected Firebase project.
Future<String> resolveCloudflareFirebaseServiceAccount(
  ExecContext context, {
  required String projectId,
}) async {
  final authYaml = context.yaml
      .getAsMap("cloudflare")
      .getAsMap("authentication")
      .getAsMap("delete_user")
      .get<Object?>("service_account", null);
  final authSecrets = context.secrets
      .getAsMap("cloudflare")
      .getAsMap("authentication")
      .getAsMap("delete_user")
      .get<Object?>("service_account", null);
  final messagingYaml = context.yaml
      .getAsMap("firebase")
      .getAsMap("messaging")
      .get<Object?>("service_account", null);
  final messagingSecrets = context.secrets
      .getAsMap("firebase")
      .getAsMap("messaging")
      .get<Object?>("service_account", null);
  if ([authSecrets, authYaml, messagingSecrets, messagingYaml]
      .any((value) => value != null && value is! String)) {
    throw StateError(
      "Firebase service account must be a JSON string resolved for the selected flavor.",
    );
  }
  final auth = authSecrets is String && authSecrets.trim().isNotEmpty
      ? authSecrets
      : authYaml;
  final messaging =
      messagingSecrets is String && messagingSecrets.trim().isNotEmpty
          ? messagingSecrets
          : messagingYaml;
  final configured = <String>[
    if (auth is String && auth.trim().isNotEmpty) auth,
    if (messaging is String && messaging.trim().isNotEmpty) messaging,
  ];
  if (configured.isNotEmpty) {
    final selected = _parseFirebaseServiceAccount(configured.first);
    if (selected == null || selected["project_id"] != projectId) {
      throw StateError(
        "The configured Firebase service account does not match firebase.project_id for this flavor.",
      );
    }
    for (final value in configured.skip(1)) {
      final candidate = _parseFirebaseServiceAccount(value);
      if (candidate == null ||
          candidate["project_id"] != projectId ||
          candidate["client_email"] != selected["client_email"] ||
          candidate["private_key"] != selected["private_key"]) {
        throw StateError(
          "Authentication and Messaging configure different Firebase service accounts for one Worker secret.",
        );
      }
    }
    return configured.first;
  }

  final matches = <String, String>{};
  final jsonNamePattern = RegExp(r"^([a-zA-Z0-9_-]+)\.json$");
  for (final directoryName in ["cloudflare", "android"]) {
    final directory = Directory(directoryName);
    if (!directory.existsSync()) {
      continue;
    }
    final files = await directory
        .list(recursive: false, followLinks: false)
        .where((entity) => entity is File)
        .cast<File>()
        .toList();
    files.sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      final name = file.path.split(Platform.pathSeparator).last;
      if (!jsonNamePattern.hasMatch(name)) {
        continue;
      }
      try {
        final content = await file.readAsString();
        final parsed = _parseFirebaseServiceAccount(content);
        if (parsed?["project_id"] == projectId) {
          final identity = jsonEncode([
            parsed!["client_email"],
            parsed["private_key"],
          ]);
          matches.putIfAbsent(identity, () => content);
        }
      } on FileSystemException {
        continue;
      }
    }
  }
  if (matches.length != 1) {
    throw StateError(
      matches.isEmpty
          ? "No Firebase service account matches firebase.project_id for this flavor."
          : "Multiple Firebase service accounts match firebase.project_id for this flavor. Configure one explicitly.",
    );
  }
  return matches.values.single;
}

Map<String, dynamic>? _parseFirebaseServiceAccount(String value) {
  try {
    final decoded = jsonDecode(value);
    if (decoded is! Map ||
        decoded["type"] != "service_account" ||
        decoded["project_id"] is! String ||
        (decoded["project_id"] as String).isEmpty ||
        decoded["client_email"] is! String ||
        (decoded["client_email"] as String).isEmpty ||
        decoded["private_key"] is! String ||
        (decoded["private_key"] as String).isEmpty) {
      return null;
    }
    return Map<String, dynamic>.from(decoded);
  } on FormatException {
    return null;
  }
}
