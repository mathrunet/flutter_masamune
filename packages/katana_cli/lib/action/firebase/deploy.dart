// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";
import "package:katana_cli/katana_cli.dart";

/// Firebase deployment process.
///
/// Firebaseのデプロイ処理を行います。
class FirebaseDeployCliAction extends CliCommand with CliActionMixin {
  /// Firebase deployment process.
  ///
  /// Firebaseのデプロイ処理を行います。
  const FirebaseDeployCliAction();

  @override
  String get description =>
      "Deploy Firebase based on the information in `katana.yaml`. Please create a Firebase project beforehand. Also, make `firebase` and `flutterfire` commands available. `katana.yaml`の情報を元にFirebaseのデプロイ処理を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final firestore = firebase.getAsMap("firestore").get("enable", false);
    final dataConnect = firebase.getAsMap("dataconnect").get("enable", false);
    final authentication =
        firebase.getAsMap("authentication").get("enable", false);
    final logger = firebase.getAsMap("logger").get("enable", false);
    final functions = firebase.getAsMap("functions").get("enable", false);
    final storage = firebase.getAsMap("storage").get("enable", false);
    final hosting = firebase.getAsMap("hosting").get("enable", false);
    final messaging = firebase.getAsMap("messaging").get("enable", false);
    return projectId.isNotEmpty &&
        (firestore ||
            dataConnect ||
            storage ||
            authentication ||
            logger ||
            functions ||
            hosting ||
            messaging);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final firebaseCommand = bin.get("firebase", "firebase");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final firestore = firebase.getAsMap("firestore");
    final enableFirestore = firestore.get("enable", false);
    final firestorePrimaryRemoteIndex =
        firestore.get("primary_remote_index", false);
    final enableFunctions = firebase.getAsMap("functions").get("enable", false);
    final enableDataConnect =
        firebase.getAsMap("dataconnect").get("enable", false);
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    label("Check firebase directory");
    final firebaseDir = Directory("firebase");
    if (!firebaseDir.existsSync()) {
      error(
        "Firebase directory is not created, please initialize Firebase with katana apply.",
      );
      return;
    }
    if (enableFirestore) {
      if (firestorePrimaryRemoteIndex) {
        label("Import firestore.indexes.json");
        final firestoreIndexes =
            File("${firebaseDir.path}/firestore.indexes.json");
        final indexData = await command(
          "Import indexes.",
          [
            firebaseCommand,
            "firestore:indexes",
          ],
          workingDirectory: firebaseDir.path,
        );
        await firestoreIndexes.writeAsString(indexData);
      }
      context.requestFirebaseDeploy(FirebaseDeployPostActionType.firestore);
    }
    if (enableFunctions) {
      context.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
    }
    if (enableDataConnect) {
      context.requestFirebaseDeploy(FirebaseDeployPostActionType.dataconnect);
    }
    // await command(
    //   "Run firebase deploy",
    //   [
    //     firebaseCommand,
    //     "deploy",
    //   ],
    //   workingDirectory: firebaseDir.path,
    // );
  }
}
