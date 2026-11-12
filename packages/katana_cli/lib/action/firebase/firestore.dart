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
    json["firestore"] = synchronizeFirestoreConfig(json["firestore"], database);
    await file.writeAsString(jsonEncode(json));
  }

  /// Updates managed paths while preserving database metadata and extra entries.
  static Object synchronizeFirestoreConfig(
      Object? existing, List<String> databases) {
    const paths = {
      "rules": "firestore.rules",
      "indexes": "firestore.indexes.json"
    };
    if (databases.isEmpty) {
      if (existing is List) {
        return existing.map((entry) {
          if (entry is! Map) {
            throw const FormatException("Invalid Firestore database entry.");
          }
          return {...entry, ...paths};
        }).toList();
      }
      if (existing != null && existing is! Map) {
        throw const FormatException("Invalid Firestore configuration.");
      }
      return {if (existing is Map) ...existing, ...paths};
    }
    final entries = existing is List
        ? existing
        : existing is Map
            ? [existing]
            : <Object>[];
    if (existing != null && existing is! Map && existing is! List) {
      throw const FormatException("Invalid Firestore configuration.");
    }
    final result = <Map<String, dynamic>>[];
    final found = <String>{};
    for (final entry in entries) {
      if (entry is! Map) {
        throw const FormatException("Invalid Firestore database entry.");
      }
      final name = entry["database"] ?? "(default)";
      result.add({
        ...Map<String, dynamic>.from(entry),
        if (databases.contains(name)) "database": name,
        if (databases.contains(name)) ...paths,
      });
      found.add(name as String);
    }
    for (final name in databases) {
      if (!found.contains(name)) {
        result.add({"database": name, ...paths});
      }
    }
    return result;
  }
}
