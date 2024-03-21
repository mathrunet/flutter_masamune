// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:katana_cli/action/post/firebase_deploy_post_action.dart';
import 'package:katana_cli/katana_cli.dart';

/// Configure the scheduler with FirebaseFunctions. class FirebaseSchedulerCliAction extends CliCommand with CliActi
///
/// FirebaseFunctionsを用いたスケジューラーの設定を行います。
class FirebaseSchedulerCliAction extends CliCommand with CliActionMixin {
  /// Configure the scheduler with FirebaseFunctions. class FirebaseSchedulerCliAction extends CliCommand with CliActi
  ///
  /// FirebaseFunctionsを用いたスケジューラーの設定を行います。
  const FirebaseSchedulerCliAction();

  @override
  String get description =>
      "Set up a scheduler using FirebaseFunctions based on the information in `katana.yaml`. Please create a Firebase project beforehand. Also, make `firebase` and `flutterfire` commands available. `katana.yaml`の情報を元にFirebaseFunctionsを用いたスケジューラーの設定を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final scheduler = firebase.getAsMap("scheduler").get("enable", false);
    return projectId.isNotEmpty && scheduler;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final firebaseCommand = bin.get("firebase", "firebase");
    final firebase = context.yaml.getAsMap("firebase");
    final enableFunctions = firebase.getAsMap("functions").get("enable", false);
    final enableFirestore = firebase.getAsMap("firestore").get("enable", false);
    final scheduler = firebase.getAsMap("scheduler");
    final time = scheduler.get("time", "");
    if (time.isEmpty) {
      error(
        "Time is not specified in [firebase]->[scheduler]->[time]. Please specify any time.",
      );
      return;
    }
    if (!enableFunctions) {
      error(
        "FirebaseFunctions is not enabled in [firebase]->[functions]->[enable]. Please enable it.",
      );
      return;
    }
    if (!enableFirestore) {
      error(
        "Firestore is not enabled in [firebase]->[firestore]->[enable]. Please enable it.",
      );
      return;
    }
    await addFlutterImport(
      [
        "masamune_scheduler",
      ],
    );
    label("Import firestore.indexes.json");
    final firestoreIndexes = File("firebase/firestore.indexes.json");
    final indexData = await command(
      "Import packages.",
      [
        firebaseCommand,
        "firestore:indexes",
      ],
      workingDirectory: "firebase",
    );
    await firestoreIndexes.writeAsString(indexData);
    label("Edit firestore.indexes.json");
    final indexes = firestoreIndexes.existsSync()
        ? jsonDecodeAsMap(firestoreIndexes.readAsStringSync())
        : {};
    final collections = indexes.getAsList<DynamicMap>("indexes");
    if (collections.isNotEmpty) {
      final schedule = collections.firstWhereOrNull(
        (e) => e.get("collectionGroup", "") == "schedule",
      );
      if (schedule != null) {
        final fields = schedule.getAsList<DynamicMap>("fields");
        if (!fields.any((e) => e.get("fieldPath", "") == "_done")) {
          fields.add({
            "fieldPath": "_done",
            "order": "ASCENDING",
          });
        }
        if (!fields.any((e) => e.get("fieldPath", "") == "_time")) {
          fields.add({
            "fieldPath": "_time",
            "order": "ASCENDING",
          });
        }
      } else {
        collections.add({
          "collectionGroup": "schedule",
          "queryScope": "COLLECTION",
          "fields": [
            {"fieldPath": "_done", "order": "ASCENDING"},
            {"fieldPath": "_time", "order": "ASCENDING"},
          ]
        });
      }
    } else {
      indexes["indexes"] = [
        {
          "collectionGroup": "schedule",
          "queryScope": "COLLECTION",
          "fields": [
            {"fieldPath": "_done", "order": "ASCENDING"},
            {"fieldPath": "_time", "order": "ASCENDING"},
          ]
        }
      ];
    }
    await firestoreIndexes.writeAsString(jsonEncode(indexes));
    label("Set firebase functions config.");
    final env = FunctionsEnv();
    await env.load();
    env["SCHEDULER_COLLECTION_PATH"] = "plugins/scheduler/schedule";
    await env.save();
    await command(
      "Deploy firebase firestore.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        "firestore:indexes",
      ],
      workingDirectory: "firebase",
    );
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (time.isNotEmpty &&
        !functions.functions.any((e) => e.startsWith("scheduler"))) {
      functions.functions.add("scheduler({schedule: \"$time\"})");
    }
    await functions.save();
    context.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
    // await command(
    //   "Deploy firebase functions.",
    //   [
    //     firebaseCommand,
    //     "deploy",
    //     "--only",
    //     "functions",
    //   ],
    //   workingDirectory: "firebase",
    // );
  }
}
