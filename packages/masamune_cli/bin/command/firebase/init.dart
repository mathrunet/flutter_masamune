part of masamune_cli;

class FirebaseInitCliCommand extends CliCommand {
  const FirebaseInitCliCommand();

  @override
  String get description =>
      "`google-services.json`や`GoogleService-Info.plist`を元にFirebaseのアプリ側の初期設定を行ないます。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final json = File("android/app/google-services.json");
    if (!json.existsSync()) {
      print("google-services.json could not be found in android/app.");
      return;
    }
    final plist = File("ios/Runner/GoogleService-Info.plist");
    if (!plist.existsSync()) {
      print("GoogleService-Info.plist could not be found in ios/Runner.");
      return;
    }
    final text = json.readAsStringSync();
    final data = jsonDecode(text) as Map;
    final projectInfo = data["project_info"] as Map;
    final projectId = projectInfo["project_id"] as String;

    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_FIREBASE_ID", projectId);
      text = text.replaceAll("// TODO_REPLACE_GOOGLE_SERVICES_APPLY_PLUGIN", """
// Comment out using Google services (Firebase、Admob、Google OAuth、Map etc...)
            // [Firebase] [Firestore] [GoogleSignIn] [GoogleMap]
            // [FirebaseCrashlytics] [FirebaseAnalytics] [FirebaseDynamicLink] [FirebaseMessaging]
            apply plugin: 'com.google.gms.google-services'
            """);
      text = text.replaceAll("// TODO_REPLACE_GOOGLE_SERVICES_CLASSPASS", """
// Comment out using Google services (Firebase、Google OAuth、Map etc..)
            // [Firebase] [Firestore] [GoogleSignIn] [GoogleMap]
            // [FirebaseCrashlytics] [FirebaseAnalytics] [FirebaseDynamicLink] [FirebaseMessaging]
            classpath 'com.google.gms:google-services:4.3.3'
            """);
      text = text.replaceAllMapped(
          RegExp(
              r"// ([A-Z0-9]+) /\* GoogleService-Info\.plist in Resources \*/"),
          (m) => "${m.group(1)} /* GoogleService-Info.plist in Resources */");
      File(file.path).writeAsStringSync(text);
    });

    final bin = yaml["bin"] as YamlMap;
    final git = bin["git"] as String?;
    final firebase = yaml["firebase"] as YamlMap;
    final functions = firebase["functions"] as YamlMap;
    final path = functions["path"] as String?;
    final templatePath = functions["template_path"] as String?;
    final indexPath = functions["index_path"] as String?;
    if (templatePath.isEmpty ||
        indexPath.isEmpty ||
        path.isEmpty ||
        git.isEmpty) {
      print("Firebase functions information is missing.");
      return;
    }
    if (!Directory(path!).existsSync()) {
      await Process.run(
        git!,
        [
          "submodule",
          "add",
          "https://github.com/mathrunet/firebase_masamune_functions.git",
          path,
        ],
        runInShell: true,
      );
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
