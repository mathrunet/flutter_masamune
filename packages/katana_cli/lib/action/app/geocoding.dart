// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";
import "package:katana_cli/katana_cli.dart";

/// Add a module to use GeocodingAPI.
///
/// GeocodingAPIを利用するためのモジュールを追加します。
class AppGeocodingCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use GeocodingAPI.
  ///
  /// GeocodingAPIを利用するためのモジュールを追加します。
  const AppGeocodingCliAction();

  @override
  String get description =>
      "Add a module to use GeocodingAPI. GeocodingAPIを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("location").getAsMap("geocoding");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final location = context.yaml.getAsMap("location");
    final geocoding = location.getAsMap("geocoding");
    final geocodingApiKey = geocoding.get("api_key", "");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final enableCloudflareWorkers =
        cloudflare.getAsMap("workers").get("enable", false);
    if (geocodingApiKey.isEmpty) {
      error(
        "If [location]->[geocoding]->[enable] is enabled, please include [location]->[geocoding]->[api_key].",
      );
      return;
    }
    // Cloudflare Workersが有効な場合はCloudflare側に設定する。
    if (enableCloudflareWorkers) {
      await _execCloudflare(context, geocodingApiKey);
      return;
    }
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
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
    final functionsDir = Directory("firebase/functions");
    if (!functionsDir.existsSync()) {
      error(
        "The directory `firebase/functions` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    await addFlutterImport(
      [
        "masamune_location_geocoding",
        "katana_functions_firebase",
      ],
    );
    label("Add firebase functions");
    final functions = Functions();
    await functions.load();
    if (!functions.imports
        .any((e) => e.contains("@mathrunet/masamune_location_geocoding"))) {
      functions.imports.add(
          "import * as geocoding from \"@mathrunet/masamune_location_geocoding\";");
    }
    if (!functions.functions
        .any((e) => e.startsWith("geocoding.Functions.geocoding"))) {
      functions.functions.add("geocoding.Functions.geocoding()");
    }
    await functions.save();
    label("Set firebase functions config.");
    final env = FunctionsEnv();
    await env.load();
    env["MAP_GEOCODING_APIKEY"] = geocodingApiKey;
    await env.save();
    context.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
  }

  Future<void> _execCloudflare(
    ExecContext context,
    String geocodingApiKey,
  ) async {
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final cloudflareDir = Directory("cloudflare");
    if (!cloudflareDir.existsSync()) {
      error(
        "The directory `cloudflare` does not exist. Initialize Cloudflare Workers by enabling [cloudflare]->[workers]->[enable] and executing `katana apply`.",
      );
      return;
    }
    await addFlutterImport(
      [
        "masamune_location_geocoding",
        "masamune_functions_cloudflare",
      ],
    );
    label("Add Cloudflare Workers functions");
    final applied = await applyCloudflareWorkersFunctions(
      alias: "geocoding",
      package: "@mathrunet/masamune_cloudflare_location_geocoding",
      functions: {
        "geocoding.Functions.geocoding": "    geocoding.Functions.geocoding(),",
      },
    );
    if (!applied) {
      return;
    }
    await command(
      "Package installation.",
      [
        npm,
        "install",
        "@mathrunet/masamune_cloudflare_location_geocoding",
      ],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    await putWranglerSecret(
      wrangler: wrangler,
      environment: context.flavorContext?.flavor.name ?? "prod",
      name: "MAP_GEOCODING_APIKEY",
      value: geocodingApiKey,
    );
  }
}
