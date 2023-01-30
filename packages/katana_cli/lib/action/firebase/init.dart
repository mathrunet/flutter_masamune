// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Firebase initial configuration.
///
/// Firebaseの初期設定を行います。
class FirebaseInitCliAction extends CliCommand with CliActionMixin {
  /// Firebase initial configuration.
  ///
  /// Firebaseの初期設定を行います。
  const FirebaseInitCliAction();

  @override
  String get description =>
      "Initialize Firebase based on the information in `katana.yaml`. Please create a Firebase project beforehand. Also, make `firebase` and `flutterfire` commands available. `katana.yaml`の情報を元にFirebaseの初期設定を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final firestore = firebase.getAsMap("firestore").get("enable", false);
    final authentication =
        firebase.getAsMap("authentication").get("enable", false);
    final functions = firebase.getAsMap("functions").get("enable", false);
    final hosting = firebase.getAsMap("hosting").get("enable", false);
    final messaging = firebase.getAsMap("messaging").get("enable", false);
    return projectId.isNotEmpty &&
        (firestore || authentication || functions || hosting || messaging);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final npm = bin.get("npm", "npm");
    final firebaseCommand = bin.get("firebase", "firebase");
    final flutterfireCommand = bin.get("flutterfire", "flutterfire");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final hosting = firebase.getAsMap("hosting");
    final useFlutter = hosting.get("use_flutter", false);
    final enabledFirestore =
        firebase.getAsMap("firestore").get("enable", false);
    final enabledAuthentication =
        firebase.getAsMap("authentication").get("enable", false);
    final enabledFunctions =
        firebase.getAsMap("functions").get("enable", false);
    final enabledHosting = hosting.get("enable", false);
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    label("Create firebase directory");
    final firebaseDir = Directory("firebase");
    if (!firebaseDir.existsSync()) {
      await firebaseDir.create();
    }
    label("Check status");
    final firebaseFunctionsIndex = File("firebase/functions/src/index.ts");
    final firebaseFunctionsIndexExists = firebaseFunctionsIndex.existsSync();
    label("Load data");
    final gradle = AppGradle();
    await gradle.load();
    final androidApplicationId = gradle.android?.defaultConfig.applicationId
        .replaceAll('"', "")
        .replaceAll("'", "");
    if (androidApplicationId.isEmpty) {
      error(
        "Application ID is not set in [android]->[defaultConfig]->[applicationId] in `android/app/build.gradle`.",
      );
      return;
    }
    final xcode = XCode();
    await xcode.load();
    final bundleId = xcode.pbxBuildConfiguration
        .map(
          (e) => e.buildSettings
              .firstWhereOrNull((e) => e.key == "PRODUCT_BUNDLE_IDENTIFIER")
              ?.value,
        )
        .firstWhereOrNull((e) => e != null)
        ?.replaceAll('"', "")
        .replaceAll("'", "");
    if (bundleId.isEmpty) {
      error(
        "Bundle ID is not set in your XCode project. Please open `ios/Runner.xcodeproj` and check the settings.",
      );
      return;
    }
    label("Run flutterfire configure");
    await command(
      "Run flutterfire configure",
      [
        flutterfireCommand,
        "configure",
        "-y",
        "--project=$projectId",
        "--ios-bundle-id=$bundleId",
        "--macos-bundle-id=$bundleId",
        "--android-package-name=$androidApplicationId",
      ],
    );
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "firebase_core",
        if (enabledAuthentication) ...[
          "firebase_auth",
          "katana_auth_firebase",
        ],
        if (enabledFirestore) ...[
          "cloud_firestore",
          "katana_model_firestore",
        ],
        if (enabledFunctions) ...[
          "firebase_storage",
          "katana_storage_firebase",
        ],
      ],
    );
    if (enabledHosting) {
      final hostingProcess = await Process.start(
        firebaseCommand,
        [
          "init",
          "hosting",
          "--project",
          projectId,
        ],
        runInShell: true,
        workingDirectory: "firebase",
        mode: ProcessStartMode.normal,
      );
      hostingProcess.stdout.transform(utf8.decoder).forEach((line) {
        // ignore: avoid_print
        print(line);
        if (line.startsWith(
          "? What do you want to use as your public directory?",
        )) {
          hostingProcess.stdin.write("hosting\n");
        }
        if (line.startsWith(
          "? Configure as a single-page app (rewrite all urls to /index.html)?",
        )) {
          if (useFlutter) {
            hostingProcess.stdin.write("y\n");
          } else {
            hostingProcess.stdin.write("n\n");
          }
        }
        if (line.startsWith(
          "? File public/index.html already exists. Overwrite?",
        )) {
          hostingProcess.stdin.write("n\n");
        }
      });
      await hostingProcess.exitCode;
    }
    if (enabledFunctions) {
      final functionsProcess = await Process.start(
        firebaseCommand,
        [
          "init",
          "functions",
          "--project",
          projectId,
        ],
        runInShell: true,
        workingDirectory: "firebase",
        mode: ProcessStartMode.normal,
      );
      functionsProcess.stdout.transform(utf8.decoder).forEach((line) {
        // ignore: avoid_print
        print(line);
        if (line.startsWith(
          "? What language would you like to use to write Cloud Functions?",
        )) {
          functionsProcess.stdin.write("k\n");
        }
        if (line.startsWith(
          "? Do you want to use ESLint to catch probable bugs and enforce style?",
        )) {
          functionsProcess.stdin.write("y\n");
        }
        if (line.startsWith(
          "? Do you want to install dependencies with npm now?",
        )) {
          functionsProcess.stdin.write("Y\n");
        }
      });
      await functionsProcess.exitCode;
      await command(
        "Package installation.",
        [
          npm,
          "install",
          "@mathrunet/masamune",
        ],
        workingDirectory: "firebase/functions",
      );
      if (!firebaseFunctionsIndexExists) {
        label("Data replacement for Firebase Functions.");
        await const FirebaseFunctionsIndexCliCode().generateFile("index.ts");
      }
    }
  }
}

/// Firebase Functions index.ts codebase.
///
/// Firebase Functionsのindex.tsのコードベース。
class FirebaseFunctionsIndexCliCode extends CliCode {
  /// Firebase Functions index.ts codebase.
  ///
  /// Firebase Functionsのindex.tsのコードベース。
  const FirebaseFunctionsIndexCliCode();

  @override
  String get name => "index";

  @override
  String get prefix => "index";

  @override
  String get directory => "firebase/functions/src";

  @override
  String get description =>
      "Define the code for index.ts in Firebase Functions. Firebase Functionsのindex.tsのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import * as m from "@mathrunet/masamune";

""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
// Define [m.Functions.xxxx] for the functions to be added to Functions.
// 
// Functionsに追加する機能を[m.Functions.xxxx]を定義してください。
m.deploy(
    exports,
    [],
);
""";
  }
}

/// Firebase Hosting index.html codebase.
///
/// Firebase Hostingのindex.htmlのコードベース。
class FirebaseHostingIndexCliCode extends CliCode {
  /// Firebase Hosting index.html codebase.
  ///
  /// Firebase Hostingのindex.htmlのコードベース。
  const FirebaseHostingIndexCliCode();

  @override
  String get name => "index";

  @override
  String get prefix => "index";

  @override
  String get directory => "firebase/functions/src";

  @override
  String get description =>
      "Define the code for index.html in Firebase Hosting.Firebase Hostingのindex.htmlのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
""";
  }
}
