// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Algolia deployment process for Firebase.
///
/// Firebase用のAlgoliaのデプロイ処理を行います。
class FirebaseAlogliaCliAction extends CliCommand with CliActionMixin {
  /// Algolia deployment process for Firebase.
  ///
  /// Firebase用のAlgoliaのデプロイ処理を行います。
  const FirebaseAlogliaCliAction();

  @override
  String get description =>
      "Deployment process of Algolia for FirebaseFunctions. Please create a Firebase project beforehand. Also, make sure that the `firebase` and `flutterfire` commands are available. Create a project in Algolia and issue an APPID and ApiKey. FirebaseFunctions用のAlgoliaのデプロイ処理を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。また、プランをBlazeにしてください。Algoliaでプロジェクトを作成しAPPIDとApiKeyを発行してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final functions = firebase.getAsMap("functions");
    final enableFunctions = functions.get("enable", false);
    final algolia = firebase.getAsMap("algolia");
    final enableAlgolia = algolia.get("enable", false);
    return projectId.isNotEmpty && enableFunctions && enableAlgolia;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final firebase = context.yaml.getAsMap("firebase");
    final firebaseCommand = bin.get("firebase", "firebase");
    final projectId = firebase.get("project_id", "");
    final algolia = firebase.getAsMap("algolia");
    final path = algolia.get("path", "").trimQuery().trimString("/");
    final appId = algolia.get("app_id", "");
    final apiKey = algolia.get("api_key", "");
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    if (path.isEmpty) {
      error(
        "The item [firebase]->[algolia]->[path] is missing. Please provide the Algolia path for the configuration.",
      );
      return;
    }
    if (appId.isEmpty) {
      error(
        "The item [firebase]->[algolia]->[app_id] is missing. Please provide the Algolia App ID for the configuration.",
      );
      return;
    }
    if (apiKey.isEmpty) {
      error(
        "The item [firebase]->[algolia]->[api_key] is missing. Please provide the Algolia Api Key for the configuration.",
      );
      return;
    }
    if (!Directory("firebase/functions").existsSync()) {
      error(
          "The item [firebase]->[funcctions]->[enable] is false. Please enable this and initialize Functions.");
      return;
    }
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_model_algolia",
      ],
    );
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.functions.any((e) => e.startsWith("algolia"))) {
      functions.functions.add("algolia({path: \"$path\"})");
    }
    await functions.save();
    label("Set firebase functions config.");
    final env = FunctionsEnv();
    await env.load();
    env["ALGOLIA_APPID"] = appId;
    env["ALGOLIA_APIKEY"] = apiKey;
    await env.save();
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
