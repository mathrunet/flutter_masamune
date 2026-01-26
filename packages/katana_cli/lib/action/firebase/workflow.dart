// Project imports:
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/src/workflow.dart";

/// Configure the workflow with FirebaseFunctions. class FirebaseWorkflowCliAction extends CliCommand with CliActi
///
/// FirebaseFunctionsを用いたワークフローの設定を行います。
class FirebaseWorkflowCliAction extends CliCommand with CliActionMixin {
  /// Configure the workflow with FirebaseFunctions. class FirebaseWorkflowCliAction extends CliCommand with CliActi
  ///
  /// FirebaseFunctionsを用いたワークフローの設定を行います。
  const FirebaseWorkflowCliAction();

  @override
  String get description =>
      "Set up a workflow using FirebaseFunctions based on the information in `katana.yaml`. Please create a Firebase project beforehand. Also, make `firebase` and `flutterfire` commands available. `katana.yaml`の情報を元にFirebaseFunctionsを用いたワークフローの設定を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final workflow = firebase.getAsMap("workflow").get("enable", false);
    return projectId.isNotEmpty && workflow;
  }

  @override
  Future<void> exec(ExecContext context) async {
    // final bin = context.yaml.getAsMap("bin");
    // final firebaseCommand = bin.get("firebase", "firebase");
    final firebase = context.yaml.getAsMap("firebase");
    final enableFunctions = firebase.getAsMap("functions").get("enable", false);
    final enableFirestore = firebase.getAsMap("firestore").get("enable", false);
    final workflow = firebase.getAsMap("workflow");
    if (workflow.isEmpty) {
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
    final packages = MasamuneWorkflowType.getPackages(context);
    if (packages.isEmpty) {
      error(
        "No workflows are enabled in [firebase]->[workflow]. Please enable at least one workflow.",
      );
      return;
    }
    await addFlutterImport(
      [
        "masamune_workflow",
      ],
    );
    await addNpmImport(
      [
        "masamune_workflow",
        ...packages.map((e) => e.id),
      ],
    );
    // label("Import firestore.indexes.json");
    // final firestoreIndexes = File("firebase/firestore.indexes.json");
    // final indexData = await command(
    //   "Import indexes.",
    //   [
    //     firebaseCommand,
    //     "firestore:indexes",
    //   ],
    //   workingDirectory: "firebase",
    // );
    // await firestoreIndexes.writeAsString(indexData);
    // label("Edit firestore.indexes.json");
    // final indexes = firestoreIndexes.existsSync()
    //     ? jsonDecodeAsMap(firestoreIndexes.readAsStringSync())
    //     : {};
    // final collections = indexes.getAsList<DynamicMap>("indexes");
    // if (collections.isNotEmpty) {
    //   final schedule = collections.firstWhereOrNull(
    //     (e) => e.get("collectionGroup", "") == "schedule",
    //   );
    //   if (schedule != null) {
    //     final fields = schedule.getAsList<DynamicMap>("fields");
    //     if (!fields.any((e) => e.get("fieldPath", "") == "_done")) {
    //       fields.add({
    //         "fieldPath": "_done",
    //         "order": "ASCENDING",
    //       });
    //     }
    //     if (!fields.any((e) => e.get("fieldPath", "") == "_time")) {
    //       fields.add({
    //         "fieldPath": "_time",
    //         "order": "ASCENDING",
    //       });
    //     }
    //   } else {
    //     collections.add({
    //       "collectionGroup": "schedule",
    //       "queryScope": "COLLECTION",
    //       "fields": [
    //         {"fieldPath": "_done", "order": "ASCENDING"},
    //         {"fieldPath": "_time", "order": "ASCENDING"},
    //       ]
    //     });
    //   }
    // } else {
    //   indexes["indexes"] = [
    //     {
    //       "collectionGroup": "schedule",
    //       "queryScope": "COLLECTION",
    //       "fields": [
    //         {"fieldPath": "_done", "order": "ASCENDING"},
    //         {"fieldPath": "_time", "order": "ASCENDING"},
    //       ]
    //     }
    //   ];
    // }
    // await firestoreIndexes.writeAsString(jsonEncode(indexes));
    // await command(
    //   "Deploy firebase firestore.",
    //   [
    //     firebaseCommand,
    //     "deploy",
    //     "--only",
    //     "firestore:indexes",
    //   ],
    //   workingDirectory: "firebase",
    // );
    label("Add firebase functions");
    var functions = Functions();
    await functions.load();
    if (!functions.imports
        .any((e) => e.contains("@mathrunet/masamune_workflow"))) {
      functions.imports
          .add("import * as workflow from \"@mathrunet/masamune_workflow\";");
    }
    functions = MasamuneWorkflowType.applyImport(context, functions);
    if (!functions.functions
        .any((e) => e.startsWith("workflow.Functions.workflowScheduler"))) {
      functions.functions.add("workflow.Functions.workflowScheduler()");
    }
    if (!functions.functions
        .any((e) => e.startsWith("workflow.Functions.taskScheduler"))) {
      functions.functions.add("workflow.Functions.taskScheduler()");
    }
    if (!functions.functions
        .any((e) => e.startsWith("workflow.Functions.taskCleaner"))) {
      functions.functions.add("workflow.Functions.taskCleaner()");
    }
    if (!functions.functions
        .any((e) => e.startsWith("workflow.Functions.asset"))) {
      functions.functions.add("workflow.Functions.asset()");
    }
    functions = MasamuneWorkflowType.applyFunctions(context, functions);
    await functions.save();
    context.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
  }
}
