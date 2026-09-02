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
    final deleteUser =
        cloudflare.getAsMap("authentication").getAsMap("delete_user");
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
    final serviceAccount = await _resolveServiceAccountJson(
      yamlValue: deleteUser.get("service_account", ""),
      secretsValue: context.secrets
          .getAsMap("cloudflare")
          .getAsMap("authentication")
          .getAsMap("delete_user")
          .get("service_account", ""),
    );
    if (serviceAccount.isEmpty) {
      error(
        "Firebase Admin SDK service account JSON was not found. Set [cloudflare]->[authentication]->[delete_user]->[service_account] in `katana_secrets.yaml` (recommended) or `katana.yaml`, or place a service account JSON under `cloudflare/` or `android/`.",
      );
      return;
    }
    if (!_isServiceAccountJson(serviceAccount)) {
      error(
        "The configured delete-user service account is not a valid Firebase Admin SDK service account JSON.",
      );
      return;
    }

    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final flavor = context.flavorContext?.flavor.name ?? "prod";
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
        "auth.Functions.deleteUser":
            "    auth.Functions.deleteUser({ projectId: ${jsonEncode(firebaseProjectId)} }),",
      },
    );
    if (!applied) {
      return;
    }
    final indexFile = File("cloudflare/src/index.ts");
    final source = await indexFile.readAsString();
    final updated = CloudflareSourceUtils.replaceFunctionCall(
      source,
      "m.FirebaseAuthAdapter",
      "m.FirebaseAuthAdapter({ projectId: ${jsonEncode(firebaseProjectId)} })",
    );
    await indexFile.writeAsString(updated);
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

  Future<String> _resolveServiceAccountJson({
    required String yamlValue,
    required String secretsValue,
  }) async {
    if (secretsValue.isNotEmpty) {
      return secretsValue;
    }
    if (yamlValue.isNotEmpty) {
      return yamlValue;
    }
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
          if (_isServiceAccountJson(content)) {
            return content;
          }
        } on FileSystemException {
          continue;
        }
      }
    }
    return "";
  }

  bool _isServiceAccountJson(String value) {
    try {
      final json = jsonDecode(value);
      return json is Map &&
          json["type"] == "service_account" &&
          json["client_email"] is String &&
          json["private_key"] is String;
    } on FormatException {
      return false;
    }
  }
}
