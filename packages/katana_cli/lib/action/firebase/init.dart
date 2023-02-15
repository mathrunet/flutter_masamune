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
    final logger = firebase.getAsMap("logger").get("enable", false);
    final functions = firebase.getAsMap("functions").get("enable", false);
    final storage = firebase.getAsMap("storage").get("enable", false);
    final hosting = firebase.getAsMap("hosting").get("enable", false);
    final messaging = firebase.getAsMap("messaging").get("enable", false);
    return projectId.isNotEmpty &&
        (firestore ||
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
    final enabledStorage = firebase.getAsMap("storage").get("enable", false);
    final enabledHosting = hosting.get("enable", false);
    final enabledLogger = firebase.getAsMap("logger").get("enable", false);
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
    label("Check firebase.json");
    final firebaseJsonFile = File("firebase/firebase.json");
    final firebaseJson = firebaseJsonFile.existsSync()
        ? jsonDecodeAsMap(await firebaseJsonFile.readAsString())
        : <String, dynamic>{};
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
        if (enabledStorage) ...[
          "firebase_storage",
          "katana_storage_firebase",
        ],
        if (enabledFunctions) ...[
          "katana_functions_firebase",
        ],
        if (enabledLogger) ...[
          "firebase_analytics",
          "firebase_crashlytics",
          "firebase_performance",
          "masamune_logger_firebase",
        ]
      ],
    );
    final commandStack = <String>[];
    if (enabledFirestore) {
      if (!firebaseJson.containsKey("firestore")) {
        final firestoreProcess = await Process.start(
          firebaseCommand,
          [
            "init",
            "firestore",
            "--project",
            projectId,
          ],
          runInShell: true,
          workingDirectory: "firebase",
          mode: ProcessStartMode.normal,
        );
        firestoreProcess.stdout.transform(utf8.decoder).forEach((line) {
          // ignore: avoid_print
          print(line);
          _runCommandStack(
            line,
            "? What file should be used for Firestore Rules?",
            commandStack,
            () => firestoreProcess.stdin.write("\n"),
          );
          _runCommandStack(
            line,
            "? What file should be used for Firestore indexes?",
            commandStack,
            () => firestoreProcess.stdin.write("\n"),
          );
        });
        await firestoreProcess.exitCode;
      }
    }
    if (enabledStorage) {
      if (!firebaseJson.containsKey("storage")) {
        final storageProcess = await Process.start(
          firebaseCommand,
          [
            "init",
            "storage",
            "--project",
            projectId,
          ],
          runInShell: true,
          workingDirectory: "firebase",
          mode: ProcessStartMode.normal,
        );
        storageProcess.stdout.transform(utf8.decoder).forEach((line) {
          // ignore: avoid_print
          print(line);
          _runCommandStack(
            line,
            "? What file should be used for Storage Rules?",
            commandStack,
            () => storageProcess.stdin.write("\n"),
          );
        });
        await storageProcess.exitCode;
      }
    }
    if (enabledHosting) {
      if (!firebaseJson.containsKey("hosting")) {
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
          _runCommandStack(
            line,
            "? What do you want to use as your public directory?",
            commandStack,
            () => hostingProcess.stdin.write("hosting\n"),
          );
          _runCommandStack(
            line,
            "? Configure as a single-page app (rewrite all urls to /index.html)?",
            commandStack,
            () {
              if (useFlutter) {
                hostingProcess.stdin.write("y\n");
              } else {
                hostingProcess.stdin.write("n\n");
              }
            },
          );
          _runCommandStack(
            line,
            "? Set up automatic builds and deploys with GitHub?",
            commandStack,
            () => hostingProcess.stdin.write("n\n"),
          );
          _runCommandStack(
            line,
            "? File hosting/index.html already exists. Overwrite?",
            commandStack,
            () => hostingProcess.stdin.write("n\n"),
          );
          _runCommandStack(
            line,
            "? File hosting/404.html already exists. Overwrite?",
            commandStack,
            () => hostingProcess.stdin.write("n\n"),
          );
        });
        await hostingProcess.exitCode;
      }
    }
    if (enabledFunctions) {
      if (!firebaseJson.containsKey("functions")) {
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
          _runCommandStack(
            line,
            "? what language would you like to use to write Cloud Functions?",
            commandStack,
            () => functionsProcess.stdin.write("k\n"),
          );
          _runCommandStack(
            line,
            "? do you want to use ESLint to catch probable bugs and enforce style?",
            commandStack,
            () => functionsProcess.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? do you want to install dependencies with npm now?",
            commandStack,
            () => functionsProcess.stdin.write("y\n"),
          );
        });
        await functionsProcess.exitCode;
      }
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
    label("Edit config.properties");
    final configPropertiesFile = File("android/config.properties");
    if (!configPropertiesFile.existsSync()) {
      error("`android/config.properties` is not found.");
      return;
    }
    final configProperties = await configPropertiesFile.readAsLines();
    if (!configProperties
        .any((element) => element.startsWith("flutter.minSdkVersion"))) {
      await configPropertiesFile.writeAsString([
        ...configProperties,
        "flutter.minSdkVersion=21",
      ].join("\n"));
    }
    label("Edit build.gradle");
    gradle.android?.defaultConfig.minSdkVersion =
        "configProperties[\"flutter.minSdkVersion\"]";
    await gradle.save();
  }

  void _runCommandStack(
    String line,
    String command,
    List<String> stack,
    void Function() callback,
  ) {
    if (!line.startsWith(command) || stack.contains(command)) {
      return;
    }
    stack.add(command);
    callback.call();
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
    ["us-central1", "asia-northeast1"],
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
