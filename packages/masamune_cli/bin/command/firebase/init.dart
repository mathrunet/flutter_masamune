part of masamune_cli;

class FirebaseInitCliCommand extends CliCommand {
  const FirebaseInitCliCommand();

  @override
  String get description =>
      "`flutterfire configure`のコマンドを実行しFirebaseの初期設定を行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final firebase = yaml["firebase"] as YamlMap;
    final bin = yaml["bin"] as YamlMap;
    final app = yaml["app"] as YamlMap;
    final accountId = firebase["account_id"] as String?;
    final projectId = firebase["project_id"] as String?;
    final flutterFire = bin["flutterfire"] as String?;
    final bundleId = app["bundle_id"] as String?;
    if (accountId.isEmpty || projectId.isEmpty) {
      print("firebase/account_id or firebase/project_id is not defined.");
      return;
    }
    if (bundleId.isEmpty) {
      print("BundleId is not defined.");
      return;
    }
    final configureProcess = await Process.start(flutterFire!, [
      "configure",
      "--project=$projectId",
      "--account=$accountId",
      "--platforms=android,ios,web",
      "--ios-bundle-id=$bundleId",
      "--android-app-id=$bundleId",
      "--android-package-name=$bundleId",
    ]);
    await configureProcess.print();
    final firebaseOption = firebaseOptions();
    print(firebaseOption);

    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_FIREBASE_ID", projectId!);
      text = text.replaceAll(
        "// TODO_REPLACE_GOOGLE_SERVICES_APPLY_PLUGIN",
        """
// Comment out using Google services (Firebase、Admob、Google OAuth、Map etc...)
            // [Firebase] [Firestore] [GoogleSignIn] [GoogleMap]
            // [FirebaseCrashlytics] [FirebaseAnalytics] [FirebaseDynamicLink] [FirebaseMessaging]
            apply plugin: 'com.google.gms.google-services'
            """,
      );
      text = text.replaceAll(
        "// TODO_REPLACE_GOOGLE_SERVICES_CLASSPASS",
        """
// Comment out using Google services (Firebase、Google OAuth、Map etc..)
            // [Firebase] [Firestore] [GoogleSignIn] [GoogleMap]
            // [FirebaseCrashlytics] [FirebaseAnalytics] [FirebaseDynamicLink] [FirebaseMessaging]
            classpath 'com.google.gms:google-services:4.3.13'
            """,
      );
      File(file.path).writeAsStringSync(text);
    });

    final git = bin["git"] as String?;
    final functions = firebase["functions"] as YamlMap;
    final path = functions["path"] as String?;
    final templatePath = functions["template_path"] as String?;
    final indexPath = functions["index_path"] as String?;
    if (templatePath.isEmpty ||
        indexPath.isEmpty ||
        path.isEmpty ||
        git.isEmpty) {
      print(
        "Firebase functions information (firebase/functions/path, firebase/functions/template_path, firebase/functions/index_path) is missing.",
      );
      return;
    }
    if (!Directory(path!).existsSync()) {
      final cloneProcess = await Process.start(
        git!,
        [
          "submodule",
          "add",
          "https://github.com/mathrunet/firebase_masamune_functions.git",
          path,
        ],
        runInShell: true,
      );
      await cloneProcess.print();
    }
    final code = File(templatePath!).readAsStringSync();
    final file = File(indexPath!);
    if (!file.existsSync()) {
      file
        ..createSync(recursive: true)
        ..writeAsStringSync(code);
    }
  }
}
