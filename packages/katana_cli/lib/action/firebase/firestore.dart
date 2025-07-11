// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Algolia deployment process for Firebase.
///
/// Firebase用のFirestoreのデプロイ処理を行います。
class FirebaseFirestoreCliAction extends CliCommand with CliActionMixin {
  /// Algolia deployment process for Firebase.
  ///
  /// Firebase用のFirestoreのデプロイ処理を行います。
  const FirebaseFirestoreCliAction();

  @override
  String get description =>
      "Deployment process of Firestore for FirebaseFunctions. Please create a Firebase project beforehand. Also, make sure that the `firebase` and `flutterfire` commands are available. Create a project in Firestore and issue an APPID and ApiKey. FirebaseFunctions用のFirestoreのデプロイ処理を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。また、プランをBlazeにしてください。Firestoreでプロジェクトを作成しAPPIDとApiKeyを発行してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final firestore = firebase.getAsMap("firestore");
    final enableFirestore = firestore.get("enable", false);
    return projectId.isNotEmpty && enableFirestore;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final firestore = firebase.getAsMap("firestore");
    final database = firestore.getAsList<String>("database");
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    label("Set firebase firestore config.");
    final file = File("firebase/firebase.json");
    final json = jsonDecodeAsMap(await file.readAsString());
    if (database.isEmpty) {
      json["firestore"] = {
        "rules": "firestore.rules",
        "indexes": "firestore.indexes.json",
      };
    } else {
      json["firestore"] = database
          .map((name) => {
                "database": name,
                "rules": "firestore.rules",
                "indexes": "firestore.indexes.json"
              })
          .toList();
    }
    await file.writeAsString(jsonEncode(json));
  }
}
