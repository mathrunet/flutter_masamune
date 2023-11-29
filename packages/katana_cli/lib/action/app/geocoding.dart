// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

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
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final firebaseCommand = bin.get("firebase", "firebase");
    final location = context.yaml.getAsMap("location");
    final geocoding = location.getAsMap("geocoding");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final geocodingApiKey = geocoding.get("api_key", "");
    if (geocodingApiKey.isEmpty) {
      error(
        "If [location]->[geocoding]->[enable] is enabled, please include [location]->[geocoding]->[api_key].",
      );
      return;
    }
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
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_geocoding",
        "katana_functions_firebase",
      ],
    );
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.functions.any((e) => e.startsWith("geocoding"))) {
      functions.functions.add("geocoding()");
    }
    await functions.save();
    await command(
      "Set firebase functions config.",
      [
        firebaseCommand,
        "functions:config:set",
        "map.geocoding.api_key=${geocoding.get("api_key", "")}",
      ],
      workingDirectory: "firebase",
    );
    await command(
      "Deploy firebase functions.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        "functions",
      ],
      workingDirectory: "firebase",
    );
  }
}
