// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:katana_cli/config.dart';
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
    final dataconnect = firebase.getAsMap("dataconnect").get("enable", false);
    final authentication =
        firebase.getAsMap("authentication").get("enable", false);
    final logger = firebase.getAsMap("logger").get("enable", false);
    final functions = firebase.getAsMap("functions").get("enable", false);
    final storage = firebase.getAsMap("storage").get("enable", false);
    final hosting = firebase.getAsMap("hosting").get("enable", false);
    final messaging = firebase.getAsMap("messaging").get("enable", false);
    return projectId.isNotEmpty &&
        (firestore ||
            dataconnect ||
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
    final npx = bin.get("npx", "npx");
    final firebaseCommand = bin.get("firebase", "firebase");
    final gsutil = bin.get("gsutil", "gsutil");
    final flutterfireCommand = bin.get("flutterfire", "flutterfire");
    final firebase = context.yaml.getAsMap("firebase");
    final github = context.yaml.getAsMap("github");
    final action = github.getAsMap("action");
    final enableGithubAction = action.get("enable", false);
    final platformGithubAction = action.get("platform", "");
    final webGithubAction = action.getAsMap("web");
    final repositoryFirebaseWebGithubAction =
        webGithubAction.get("repository", "");
    final projectId = firebase.get("project_id", "");
    final hosting = firebase.getAsMap("hosting");
    final useFlutter = hosting.get("use_flutter", false);
    final firestore = firebase.getAsMap("firestore");
    final dataconnect = firebase.getAsMap("dataconnect");
    // final overwriteFirestoreRule = firestore.get("overwrite_rule", false);
    final enabledFirestore = firestore.get("enable", false);
    final enabledDataconnect = dataconnect.get("enable", false);
    final enabledAuthentication =
        firebase.getAsMap("authentication").get("enable", false);
    final enabledFunctions =
        firebase.getAsMap("functions").get("enable", false);
    final storage = firebase.getAsMap("storage");
    // final overwriteStorageRule = storage.get("overwrite_rule", false);
    final enabledStorage = storage.get("enable", false);
    final enabledCors = storage.get("cors", false);
    final enabledHosting = hosting.get("enable", false);
    final enableActions = hosting.get("github_actions", false);
    final enabledLogger = firebase.getAsMap("logger").get("enable", false);
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    if (enableActions && !enableGithubAction) {
      error(
        "The item [hosting]->[github_actions] is true, but the item [github]->[action]->[enable] is false. Please set the item [github]->[action]->[enable] to true.",
      );
      return;
    }
    if (enableActions && !platformGithubAction.contains("web")) {
      error(
        "The item [hosting]->[github_actions] is true, but the item [github]->[action]->[platform] does not contain `web`. Please set the item [github]->[action]->[platform] to `web`.",
      );
      return;
    }
    if (enableActions && repositoryFirebaseWebGithubAction.isEmpty) {
      error(
        "The item [github]->[action]->[web]->[repository] is missing. Please provide the repository name for the Firebase Web configuration.",
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
    final firebaseJsonFileExists = firebaseJsonFile.existsSync();
    final firebaseJson = firebaseJsonFileExists
        ? jsonDecodeAsMap(await firebaseJsonFile.readAsString())
        : <String, dynamic>{};
    label("Check status");
    final firebaseFunctionsIndex = File("firebase/functions/src/index.ts");
    final firebaseFunctionsIndexExists = firebaseFunctionsIndex.existsSync();
    label("Load data");
    final gradle = AppGradle();
    await gradle.load();
    final androidApplicationId = gradle.android?.defaultConfig.applicationId
        .trim()
        .replaceAll('"', "")
        .replaceAll("'", "");
    final xcode = XCode();
    await xcode.load();
    final bundleId = xcode.pbxBuildConfiguration
        .map(
          (e) => e.buildSettings
              .firstWhereOrNull((e) => e.key == "PRODUCT_BUNDLE_IDENTIFIER")
              ?.value,
        )
        .firstWhereOrNull((e) => e != null)
        ?.trim()
        .replaceAll('"', "")
        .replaceAll("'", "");
    if (bundleId.isEmpty) {
      error(
        "Bundle ID is not set in your XCode project. Please open `ios/Runner.xcodeproj` and check the settings.",
      );
      return;
    }
    if (!firebaseJsonFileExists) {
      await command(
        "Run flutterfire configure",
        [
          flutterfireCommand,
          "configure",
          "-y",
          "--project=$projectId",
          "--ios-bundle-id=$bundleId",
          "--macos-bundle-id=$bundleId",
          if (androidApplicationId.isNotEmpty)
            "--android-package-name=$androidApplicationId",
        ],
      );
    }
    await addFlutterImport(
      [
        "firebase_core",
        if (enabledAuthentication) ...[
          "firebase_auth",
          "katana_auth_firebase",
        ],
        if (enabledFirestore) ...[
          "cloud_firestore",
          "katana_model_firestore",
        ],
        if (enabledDataconnect) ...[
          "firebase_data_connect",
          "masamune_model_firebase_data_connect",
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
    await addFlutterImport(
      [
        if (enabledDataconnect) ...[
          "masamune_model_firebase_data_connect_builder",
        ],
      ],
      development: true,
    );
    final commandStack = <String>[];
    if (enabledFirestore) {
      if (!firebaseJson.containsKey("firestore")) {
        await command(
            "Initialize Firestore",
            [
              firebaseCommand,
              "init",
              "firestore",
              "--project",
              projectId,
            ],
            runInShell: true,
            workingDirectory: "firebase", action: (process, line) {
          _runCommandStack(
            line,
            "? Are you ready to proceed?",
            commandStack,
            () => process.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? What file should be used for Firestore Rules?",
            commandStack,
            () => process.stdin.write("\n"),
          );
          _runCommandStack(
            line,
            "? File firestore.indexes.json already exists.",
            commandStack,
            () => process.stdin.write("n\n"),
          );
          _runCommandStack(
            line,
            "? File firestore.rules already exists.",
            commandStack,
            () => process.stdin.write("n\n"),
          );
          _runCommandStack(
            line,
            "? Would you like to delete these indexes?",
            commandStack,
            () => process.stdin.write("n\n"),
          );
          _runCommandStack(
            line,
            "? What file should be used for Firestore indexes?",
            commandStack,
            () => process.stdin.write("\n"),
          );
        });
        label("Rewriting Rules");
        await const FirestoreRulesCliCode().generateFile("firestore.rules");
      }
    }
    if (enabledDataconnect) {
      if (!firebaseJson.containsKey("dataconnect")) {
        await command(
            "Initialize Data Connect",
            [
              firebaseCommand,
              "init",
              "dataconnect",
              "--project",
              projectId,
            ],
            runInShell: true,
            workingDirectory: "firebase", action: (process, line) {
          _runCommandStack(
            line,
            "? Your project already has existing services. Which would you like to set up",
            commandStack,
            () => process.stdin.write("\n"),
          );
        });
      }
      final adapter =
          File("lib/adapters/firebase_data_connect_model_adapter.dart");
      if (!adapter.existsSync()) {
        label("Create Adapter");
        await const FirebaseDataConnectModelAdapterCliCode().generateDartCode(
            "lib/adapters/firebase_data_connect_model_adapter",
            "firebase_data_connect_model_adapter");
        await command(
          "Run the project's build_runner to generate code.",
          [
            flutter,
            "packages",
            "pub",
            "run",
            "build_runner",
            "build",
            "--delete-conflicting-outputs",
          ],
        );
      }
      final connector = File("lib/dataconnect/connector.dart");
      if (!connector.existsSync()) {
        label("Create Dummy Connector");
        await const FirebaseDataConnectDummyConnectorCliCode()
            .generateDartCode("lib/dataconnect/connector", "connector");
      }
    }
    if (enabledStorage) {
      if (!firebaseJson.containsKey("storage")) {
        await command(
            "Initialize Storage",
            [
              firebaseCommand,
              "init",
              "storage",
              "--project",
              projectId,
            ],
            runInShell: true,
            workingDirectory: "firebase", action: (process, line) {
          _runCommandStack(
            line,
            "? Are you ready to proceed?",
            commandStack,
            () => process.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? File storage.rules already exists.",
            commandStack,
            () => process.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? What file should be used for Storage Rules?",
            commandStack,
            () => process.stdin.write("\n"),
          );
        });
        label("Rewriting Rules");
        await const FirebaseStorageRulesCliCode().generateFile("storage.rules");
        if (enabledCors) {
          label("Set the cors.json");
          await const FirebaseStorageCorsCliCode().generateFile("cors.json");
          await command(
            "Run cors.json deploy",
            [
              gsutil,
              "cors",
              "set",
              "cors.json",
              "gs://$projectId.appspot.com",
            ],
            workingDirectory: "firebase",
          );
        }
      }
    }
    if (enabledHosting) {
      if (!firebaseJson.containsKey("hosting")) {
        await command(
            "Initialize Hosting",
            [
              firebaseCommand,
              "init",
              "hosting",
              "--project",
              projectId,
            ],
            runInShell: true,
            workingDirectory: "firebase", action: (process, line) {
          _runCommandStack(
            line,
            "? Are you ready to proceed?",
            commandStack,
            () => process.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? What do you want to use as your public directory?",
            commandStack,
            () => process.stdin.write("hosting\n"),
          );
          _runCommandStack(
            line,
            "? Configure as a single-page app",
            commandStack,
            () {
              if (useFlutter) {
                process.stdin.write("y\n");
              } else {
                process.stdin.write("n\n");
              }
            },
          );
          _runCommandStack(
            line,
            "? Set up automatic builds and deploys with GitHub?",
            commandStack,
            () => process.stdin.write(
              enableActions ? "y\n" : "n\n",
            ),
          );
          _runCommandStack(
            line,
            "? File hosting/index.html already exists. Overwrite?",
            commandStack,
            () => process.stdin.write("n\n"),
          );
          _runCommandStack(
            line,
            "? File hosting/404.html already exists. Overwrite?",
            commandStack,
            () => process.stdin.write("n\n"),
          );
          _runCommandStack(
            line,
            "? For which GitHub repository would you like to set up a GitHub workflow?",
            commandStack,
            () => process.stdin.write("$repositoryFirebaseWebGithubAction\n"),
          );
          _runCommandStack(
            line,
            "? Set up the workflow to run a build script before every deploy?",
            commandStack,
            () => process.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? What script should be run before every deploy?",
            commandStack,
            () => process.stdin.write("\n"),
          );
          _runCommandStack(
            line,
            "? Set up automatic deployment to your site's live channel when a PR is merged?",
            commandStack,
            () => process.stdin.write("n\n"),
          );
        });
      }
    }
    if (enabledFunctions) {
      if (!firebaseJson.containsKey("functions")) {
        await command(
            "Initialize Functions",
            [
              firebaseCommand,
              "init",
              "functions",
              "--project",
              projectId,
            ],
            runInShell: true,
            workingDirectory: "firebase", action: (process, line) {
          _runCommandStack(
            line,
            "? Are you ready to proceed?",
            commandStack,
            () => process.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? What language would you like to use to write Cloud Functions?",
            commandStack,
            () => process.stdin.write("j\n"),
          );
          _runCommandStack(
            line,
            "? Do you want to use ESLint to catch probable bugs and enforce style?",
            commandStack,
            () => process.stdin.write("y\n"),
          );
          _runCommandStack(
            line,
            "? Do you want to install dependencies with npm now?",
            commandStack,
            () => process.stdin.write("y\n"),
          );
        });
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
      await command(
        "Package installation for dev.",
        [
          npm,
          "install",
          "--save-dev",
          "jest",
          "ts-jest",
          "@types/jest",
        ],
        workingDirectory: "firebase/functions",
      );
      await command(
        "Initialize Jest",
        [
          npx,
          "ts-jest",
          "config:init",
        ],
        workingDirectory: "firebase/functions",
      );
      if (!firebaseFunctionsIndexExists) {
        label("Data replacement for Firebase Functions.");
        await const FirebaseFunctionsIndexCliCode().generateFile("index.ts");
      }
      await command(
        "Fix lint errors.",
        [
          "eslint",
          "--ext",
          ".js,.ts",
          "--fix",
          ".",
        ],
        workingDirectory: "firebase/functions",
      );
    }
    label("Edit config.properties");
    final configPropertiesFile = File("android/config.properties");
    if (!configPropertiesFile.existsSync()) {
      await configPropertiesFile.writeAsString("");
    }
    final configProperties = await configPropertiesFile.readAsLines();
    if (!configProperties
        .any((element) => element.startsWith("flutter.minSdkVersion"))) {
      await configPropertiesFile.writeAsString([
        ...configProperties,
        "flutter.minSdkVersion=${Config.firebaseMinSdkVersion}",
      ].join("\n"));
    }
    label("Edit build.gradle");
    if (!gradle.loadProperties.any((e) => e.name == "configProperties")) {
      gradle.loadProperties.add(
        GradleLoadProperties(
          path: "config.properties",
          name: "configProperties",
          file: "configPropertiesFile",
        ),
      );
    }
    if (!gradle.plugins
        .any((e) => e.plugin == "com.google.gms.google-services")) {
      gradle.plugins.add(
        GradlePlugin(
          plugin: "com.google.gms.google-services",
        ),
      );
    }
    gradle.android?.defaultConfig.minSdkVersion =
        "configProperties[\"flutter.minSdkVersion\"].toInteger()";
    await gradle.save();
    label("Edit settings.gradle.");
    final settingsGradle = SettingsGradle();
    await settingsGradle.load();
    if (!settingsGradle.plugins.any((element) =>
        element.package.startsWith("com.google.gms.google-services"))) {
      settingsGradle.plugins.add(
        SettingsGradlePlugins(
          package: "com.google.gms.google-services",
          version: Config.googleServicesVersion,
          apply: false,
        ),
      );
    }
    await settingsGradle.save();
    label("Rewrite `package.json`");
    final packageJson = File("firebase/functions/package.json");
    if (packageJson.existsSync()) {
      final json = jsonDecodeAsMap(await packageJson.readAsString());
      final scripts = json.getAsMap("scripts");
      scripts["test"] = "firebase emulators:exec --only firestore 'npx jest'";
      json["scripts"] = scripts;
      await packageJson.writeAsString(jsonEncode(json));
    }
    label("Create functions test folder.");
    final functionsTest = Directory("firebase/functions/test");
    if (!functionsTest.existsSync()) {
      await functionsTest.create();
    }
    label("Rewrite `.gitignore`.");
    final gitignore = File("firebase/.gitignore");
    if (!gitignore.existsSync()) {
      error("Cannot find `firebase/.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
      if (!gitignores.any((e) => e.startsWith(".env"))) {
        gitignores.add(".env");
      }
    } else {
      gitignores.removeWhere((e) => e.startsWith(".env"));
    }
    await gitignore.writeAsString(gitignores.join("\n"));
    if (enabledFirestore) {
      label("Import firestore.indexes.json");
      final firestoreIndexes = File("firebase/firestore.indexes.json");
      final indexData = await command(
        "Import indexes.",
        [
          firebaseCommand,
          "firestore:indexes",
        ],
        workingDirectory: "firebase",
      );
      await firestoreIndexes.writeAsString(indexData);
      if (firebaseJsonFileExists) {
        await command(
          "Run firebase deploy",
          [
            firebaseCommand,
            "deploy",
            if (enableActions) ...[
              "--except",
              "hosting",
            ]
          ],
          workingDirectory: "firebase",
        );
      }
    }
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
import * as admin from "firebase-admin";
if (admin.apps.length === 0) {
  admin.initializeApp();
}

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
      "Define the code for index.html in Firebase Hosting. Firebase Hostingのindex.htmlのコードを定義します。";

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
    return r"""
""";
  }
}

/// Firestore's Rules codebase.
///
/// FirestoreのRulesのコードベース。
class FirestoreRulesCliCode extends CliCode {
  /// Firestore's Rules codebase.
  ///
  /// FirestoreのRulesのコードベース。
  const FirestoreRulesCliCode();

  @override
  String get name => "firestore";

  @override
  String get prefix => "firestore";

  @override
  String get directory => "firebase";

  @override
  String get description =>
      "Define code for Firestore rules. Firestoreのルール用のコードを定義します。";

  /// Checks [fileName] and returns true if the file does not exist or if all access is unauthorized.
  ///
  /// [fileName]をチェックしファイルが存在しない場合と、すべてのアクセスが未許可の場合にtrueを返します。
  Future<bool> check(String fileName) async {
    if (directory.isNotEmpty) {
      final dir = Directory(directory);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
    }
    final file = File("${directory.isNotEmpty ? "$directory/" : ""}$fileName");
    if (!file.existsSync()) {
      return true;
    }
    final res = await file.readAsString();
    return res.contains("allow read, write: if false;");
  }

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
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
""";
  }
}

/// Firebase Storage's Rules codebase.
///
/// Firebase StorageのRulesのコードベース。
class FirebaseStorageRulesCliCode extends CliCode {
  /// Firebase Storage's Rules codebase.
  ///
  /// Firebase StorageのRulesのコードベース。
  const FirebaseStorageRulesCliCode();

  @override
  String get name => "storage";

  @override
  String get prefix => "storage";

  @override
  String get directory => "firebase";

  @override
  String get description =>
      "Define code for Firebase Storage rules.Firebase Storageのルール用のコードを定義します。";

  /// Checks [fileName] and returns true if the file does not exist or if all access is unauthorized.
  ///
  /// [fileName]をチェックしファイルが存在しない場合と、すべてのアクセスが未許可の場合にtrueを返します。
  Future<bool> check(String fileName) async {
    if (directory.isNotEmpty) {
      final dir = Directory(directory);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
    }
    final file = File("${directory.isNotEmpty ? "$directory/" : ""}$fileName");
    if (!file.existsSync()) {
      return true;
    }
    final res = await file.readAsString();
    return res.contains("allow read, write: if false;");
  }

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
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
""";
  }
}

/// Firebase Storage cors.json codebase.
///
/// Firebase Storageのcors.jsonのコードベース。
class FirebaseStorageCorsCliCode extends CliCode {
  /// Firebase Storage cors.json codebase.
  ///
  /// Firebase Storageのcors.jsonのコードベース。
  const FirebaseStorageCorsCliCode();

  @override
  String get name => "cors";

  @override
  String get prefix => "cors";

  @override
  String get directory => "firebase";

  @override
  String get description =>
      "Firebase Storage cors.json codebase. Firebase Storageのcors.jsonのコードベース。";

  /// Checks [fileName] and returns true if the file does not exist.
  ///
  /// [fileName]をチェックしファイルが存在しない場合にtrueを返します。
  Future<bool> check(String fileName) async {
    if (directory.isNotEmpty) {
      final dir = Directory(directory);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
    }
    final file = File("${directory.isNotEmpty ? "$directory/" : ""}$fileName");
    if (!file.existsSync()) {
      return true;
    }
    return false;
  }

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
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
""";
  }
}

/// Create a ModelAdapter base class for FirebaseDataConnect.
///
/// FirebaseDataConnect用のModelAdapterのベースクラスを作成します。
class FirebaseDataConnectModelAdapterCliCode extends CliCode {
  /// Create a ModelAdapter base class for FirebaseDataConnect.
  ///
  /// FirebaseDataConnect用のModelAdapterのベースクラスを作成します。
  const FirebaseDataConnectModelAdapterCliCode();

  @override
  String get name => "firebase_data_connect_model_adapter";

  @override
  String get prefix => "firebase_data_connect_model_adapter";

  @override
  String get directory => "lib/adapters";

  @override
  String get description =>
      "Create a ModelAdapter base class for FirebaseDataConnect in `$directory/(filepath).dart`. FirebaseDataConnect用のModelAdapterのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
// ignore: unused_import, unnecessary_import
import 'package:flutter/foundation.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune_model_firebase_data_connect/masamune_model_firebase_data_connect.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
// ignore: unused_import, unnecessary_import
import '/dataconnect/connector.dart';

part 'firebase_data_connect_model_adapter.dataconnect.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// If you use FirebaseDataConnect, specify this ModelAdapter as `adapter` in [CollectionModelPath] or [DocumentModelPath].
///
/// If you want to use it as a whole, you can also specify it as a `modelAdapter` in [MasamuneApp].
const firebaseDataConnectModelAdapter = FirebaseDataConnectModelAdapter();

/// ModelAdapter to use FirebaseDataConnect.
@immutable
@firebaseDataConnectAdapter
class FirebaseDataConnectModelAdapter
    extends _\$FirebaseDataConnectModelAdapter {
  const FirebaseDataConnectModelAdapter();
}
""";
  }
}

/// Create a dummy connector file for FirebaseDataConnect.
///
/// FirebaseDataConnect用のダミーのコネクターファイルを作成します。
class FirebaseDataConnectDummyConnectorCliCode extends CliCode {
  /// Create a dummy connector file for FirebaseDataConnect.
  ///
  /// FirebaseDataConnect用のダミーのコネクターファイルを作成します。
  const FirebaseDataConnectDummyConnectorCliCode();

  @override
  String get name => "connector";

  @override
  String get prefix => "connector";

  @override
  String get directory => "lib/dataconnect";

  @override
  String get description =>
      "Create a dummy connector file for FirebaseDataConnect in `$directory/(filepath).dart`. FirebaseDataConnect用のダミーのコネクターファイルを`$directory/(filepath).dart`に作成します。";

  @override
  String import(String path, String baseName, String className) {
    return """
library connector;
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return "";
  }
}
