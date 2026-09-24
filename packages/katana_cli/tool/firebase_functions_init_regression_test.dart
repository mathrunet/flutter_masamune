// Dart imports:
import "dart:io";
import "dart:convert";

// Project imports:
import "package:katana_cli/action/firebase/init.dart";
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";

Future<void> main() async {
  _expectEqual(
    firebaseDeployTargets(
      firestore: true,
      functions: true,
      storage: false,
      dataconnect: false,
      hosting: false,
      hostingGithubActions: false,
    ),
    ["firestore", "functions"],
    "Disabled Firebase Storage must not be deployed.",
  );
  _expectEqual(
    firebaseDeployTargets(
      firestore: true,
      functions: true,
      storage: true,
      dataconnect: true,
      hosting: true,
      hostingGithubActions: false,
    ),
    ["firestore", "functions", "storage", "dataconnect", "hosting"],
    "Every enabled Firebase CLI service must be deployed in stable order.",
  );
  _expectEqual(
    firebaseDeployTargets(
      firestore: false,
      functions: false,
      storage: false,
      dataconnect: false,
      hosting: true,
      hostingGithubActions: true,
    ),
    <String>[],
    "Hosting deployed by GitHub Actions must not trigger a local deploy.",
  );
  _expectEqual(
    firebaseDeployTargets(
      firestore: false,
      functions: false,
      storage: false,
      dataconnect: false,
      hosting: false,
      hostingGithubActions: false,
    ),
    <String>[],
    "No Firebase CLI services must mean no deploy.",
  );
  const indexCode = FirebaseFunctionsIndexCliCode();
  final indexImports = indexCode.import("index.ts", "index", "Index");
  _expect(
    !indexImports.contains("firebase-admin"),
    "The generated index must delegate Firebase initialization to "
    "masamune_firebase.",
  );
  _expect(
    !indexImports.contains("initializeApp"),
    "The generated index must not initialize Firebase Admin directly.",
  );
  _expect(
    indexCode.body("index.ts", "index", "Index").contains("mf.deploy("),
    "The generated index must keep deployment registration through mf.deploy.",
  );

  final temporary = await Directory.systemTemp.createTemp(
    "katana_firebase_functions_init_",
  );
  try {
    final functionsDirectory = Directory("${temporary.path}/functions");
    await functionsDirectory.create();

    final initialPlan = FirebaseFunctionsToolingPlan.create(
      functionsDirectory: functionsDirectory,
    );
    _expect(
      initialPlan.initializeJest,
      "A missing Jest configuration must be initialized.",
    );
    final executableSuffix = Platform.isWindows ? ".cmd" : "";
    _expectEqual(
      initialPlan.initializeJestCommand,
      ["node_modules/.bin/ts-jest$executableSuffix", "config:init"],
      "Jest initialization must use the locally installed ts-jest.",
    );
    _expectEqual(
      initialPlan.fixLintCommand,
      [
        "node_modules/.bin/eslint$executableSuffix",
        "--ext",
        ".js,.ts",
        "--fix",
        ".",
      ],
      "Lint fixes must use the locally installed ESLint.",
    );
    await _writeFixtureExecutable(functionsDirectory, "ts-jest");
    await _writeFixtureExecutable(functionsDirectory, "eslint");
    await _expectLocalCommandRuns(
      initialPlan.initializeJestCommand,
      functionsDirectory,
      "ts-jest",
    );
    await _expectLocalCommandRuns(
      initialPlan.fixLintCommand,
      functionsDirectory,
      "eslint",
    );

    final existingConfig = File("${functionsDirectory.path}/jest.config.js");
    const existingContents = "module.exports = {preset: 'custom'};\n";
    await existingConfig.writeAsString(existingContents);
    final repeatedPlan = FirebaseFunctionsToolingPlan.create(
      functionsDirectory: functionsDirectory,
    );
    _expect(
      !repeatedPlan.initializeJest,
      "An existing Jest configuration must not be regenerated.",
    );
    _expectEqual(
      await existingConfig.readAsString(),
      existingContents,
      "Planning a repeated apply must preserve the Jest configuration.",
    );
  } finally {
    await temporary.delete(recursive: true);
  }
  final localContext = ExecContext(yaml: {}, args: ["apply", "--local"]);
  await runApplyCommands(() async {
    localContext.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
  }, local: true);
  _expect(localContext.postActions.isEmpty, "--local は後処理の本番deployを登録しない");
  await _verifyApplyProcessBoundaries();
  stdout.writeln("All Firebase Functions initialization checks passed.");
}

Future<void> _writeFixtureExecutable(
  Directory functionsDirectory,
  String name,
) async {
  final binDirectory =
      Directory("${functionsDirectory.path}/node_modules/.bin");
  await binDirectory.create(recursive: true);
  final suffix = Platform.isWindows ? ".cmd" : "";
  final executable = File("${binDirectory.path}/$name$suffix");
  await executable.writeAsString(
    Platform.isWindows
        ? "@echo off\r\ntype nul > $name.called\r\n"
        : "#!/bin/sh\n: > $name.called\n",
  );
  if (!Platform.isWindows) {
    final result = await Process.run("chmod", ["+x", executable.path]);
    _expect(result.exitCode == 0, "Failed to prepare the $name fixture.");
  }
}

Future<void> _expectLocalCommandRuns(
  List<String> command,
  Directory functionsDirectory,
  String name,
) async {
  final result = await Process.run(
    command.first,
    command.sublist(1),
    workingDirectory: functionsDirectory.path,
    runInShell: true,
  );
  _expect(
    result.exitCode == 0,
    "The local $name command failed: ${result.stderr}",
  );
  _expect(
    File("${functionsDirectory.path}/$name.called").existsSync(),
    "The local $name executable was not selected.",
  );
}

void _expect(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual is List<Object?> && expected is List<Object?>) {
    if (actual.length == expected.length) {
      for (var i = 0; i < actual.length; i++) {
        if (actual[i] != expected[i]) {
          throw StateError("$message Expected $expected, got $actual.");
        }
      }
      return;
    }
  } else if (actual == expected) {
    return;
  }
  throw StateError("$message Expected $expected, got $actual.");
}

// apply 全体を偽のプロセス境界で動かし、非0後のdeploy非起動を検証します。
Future<void> _verifyApplyProcessBoundaries() async {
  final packageRoot = File.fromUri(Platform.script).parent.parent;
  final cli = Platform.environment["KATANA_TEST_CLI"] ??
      "${packageRoot.path}/bin/katana.dart";
  for (final failure in [
    "firestore-new",
    "firestore-split",
    "firestore-mismatch",
    "firestore-init-failure",
    "install",
    "uninstall",
    "dev",
    "jest",
    "lint",
    "none",
    "local",
    "local-lock",
    "local-check",
    "local-missing",
    "local-config"
  ]) {
    final local = failure.startsWith("local");
    final root =
        await Directory.systemTemp.createTemp("katana_apply_boundary_");
    try {
      Future<void> write(String name, String content) async {
        final file = File("${root.path}/$name");
        await file.parent.create(recursive: true);
        await file.writeAsString(
            content.startsWith("\n#!/bin/sh") ? content.substring(1) : content);
      }

      final firestoreSetup = failure.startsWith("firestore-");
      final trace = "${root.path}/calls";
      final firebase = "${root.path}/firebase-fake";
      final npm = "${root.path}/npm-fake";
      await write("firebase-fake", """
#!/bin/sh
if [ "\$1" = "projects:list" ]; then
  echo 'firebase:projects:list' >> '$trace'
  echo '{"status":"success","result":[{"projectId":"fixture"}]}'
elif [ "\$1" = "init" ] && [ "\$2" = "firestore" ]; then
  echo "firebase:\$*" >> '$trace'
  [ '$failure' = 'firestore-init-failure' ] && exit 43
  printf '? Please select the location of your Firestore database:\n'
  [ '$failure' = 'firestore-split' ] && sleep 0.2
  printf '  eur3\n❯ nam5\n  nam7\n'
  if ! read -r -t 3 reply; then
    echo 'Unhandled Firestore location selection' >&2
    exit 42
  fi
  [ -z "\$reply" ] || exit 44
  echo 'firestore:location-confirmed' >> '$trace'
  echo '{"firestore":{},"functions":{}}' > firebase.json
else
  echo "firebase:\$*" >> '$trace'
fi
""");
      await write("npm-fake", """
#!/bin/sh
echo "\$*" >> '${root.path}/npm-arguments'
step=install
[ "\$1" = uninstall ] && step=uninstall
[ "\$2" = --save-dev ] && step=dev
[ "\$1" = ls ] && step=check
echo "\$step" >> '$trace'
if [ "\$step" = '${failure == "local-check" ? "check" : failure}' ]; then
  echo 'npm ERR! ERESOLVE unable to resolve dependency tree' >&2
  exit 17
fi
echo 'npm WARN fixture warning' >&2
exit 0
""");
      for (final tool in ["ts-jest", "eslint"]) {
        final step = tool == "ts-jest" ? "jest" : "lint";
        await write("firebase/functions/node_modules/.bin/$tool", """
#!/bin/sh
echo '$step' >> '$trace'
[ '$step' = '$failure' ] && exit 19
exit 0
""");
      }
      for (final path in [
        firebase,
        npm,
        "${root.path}/firebase/functions/node_modules/.bin/ts-jest",
        "${root.path}/firebase/functions/node_modules/.bin/eslint"
      ]) {
        await Process.run("chmod", ["+x", path]);
      }
      await write("pubspec.yaml",
          "name: fixture\ndependencies:\n  firebase_core: any\n  cloud_firestore: any\n  katana_model_firestore: any\n  katana_functions_firebase: any\n");
      await write("katana.yaml",
          "bin:\n  firebase: $firebase\n  npm: $npm\nfirebase:\n  project_id: fixture\n  firestore:\n    enable: true\n    location_id: ${failure == "firestore-mismatch" ? "eur3" : "nam5"}\n  functions:\n    enable: true\n");
      await write(
          "firebase/firebase.json",
          firestoreSetup
              ? '{"functions":{}}'
              : '{"firestore":{},"functions":{},"storage":{}}');
      await write("firebase/.gitignore", ".env\n");
      await write("firebase/functions/src/index.ts", "// 既存コード\n");
      await write("firebase/functions/package.json",
          '{"dependencies":{},"devDependencies":{}}');
      await write("android/app/src/katanaFirebase/prod/google-services.json",
          '{"project_info":{"project_id":"fixture"}}');
      for (final platform in ["ios", "macos"]) {
        await write("$platform/Runner/Firebase/prod/GoogleService-Info.plist",
            "<plist><dict><key>PROJECT_ID</key><string>fixture</string></dict></plist>");
      }
      await write(
          "lib/katana/firebase/prod/firebase_options.dart", "// 既存の設定\n");
      await write("android/app/build.gradle.kts", '''
plugins {
    id("com.android.application")
}
android {
    namespace = "com.example.fixture"
    compileSdk = 35
    defaultConfig {
        applicationId = "com.example.fixture"
        minSdk = 24
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }
}
''');
      await write("android/settings.gradle.kts",
          'plugins {\n    id("com.android.application") version "8.7.0" apply false\n}\n');
      await write("ios/Runner.xcodeproj/project.pbxproj", """
/* Begin XCBuildConfiguration section */
111111111111111111111111 /* Debug */ = {
    isa = XCBuildConfiguration;
    buildSettings = {
        PRODUCT_BUNDLE_IDENTIFIER = com.example.fixture;
    };
    name = Debug;
};
/* End XCBuildConfiguration section */
/* Begin PBXNativeTarget section */
    123ABC /* Runner */ = {
      isa = PBXNativeTarget;
      buildPhases = (
        AAA /* Sources */,
      );
    };
/* End PBXNativeTarget section */
/* Begin PBXShellScriptBuildPhase section */
    BBB /* Thin Binary */ = {
      isa = PBXShellScriptBuildPhase;
    };
/* End PBXShellScriptBuildPhase section */
""");
      if (local) {
        final names = [
          "firebase_core",
          "cloud_firestore",
          "katana_model_firestore",
          "katana_functions_firebase"
        ];
        await write("pubspec.lock",
            "packages:\n${names.map((e) => "  $e: {}").join("\n")}\n");
        await write(
            ".dart_tool/package_config.json",
            jsonEncode({
              "configVersion": 2,
              "packages": [
                for (final name in names)
                  {
                    "name": name,
                    "rootUri": "../installed/$name",
                    "packageUri": "lib/",
                    "languageVersion": "3.0"
                  }
              ]
            }));
        for (final name in names) {
          await write(
              "installed/$name/pubspec.yaml", "name: $name\nversion: 1.0.0\n");
        }
        if (failure == "local-missing") {
          await Directory("${root.path}/installed/firebase_core")
              .delete(recursive: true);
        }
        if (failure == "local-config") {
          await File(
                  "${root.path}/lib/katana/firebase/prod/firebase_options.dart")
              .delete();
        }
        final dependencies = {"@mathrunet/masamune": "1.0.0"};
        final devDependencies = {
          for (final name in [
            "jest",
            "ts-jest",
            "@types/jest",
            "typescript",
            "eslint"
          ])
            name: "1.0.0"
        };
        final package = {
          "dependencies": dependencies,
          "devDependencies": devDependencies
        };
        await write("firebase/functions/package.json", jsonEncode(package));
        await write(
            "firebase/functions/package-lock.json",
            jsonEncode({
              "lockfileVersion": 3,
              "packages": {"": failure == "local-lock" ? {} : package}
            }));
      }
      if (failure == "none") {
        await write(
            "firebase/functions/jest.config.js",
            'const { createDefaultPreset } = require("ts-jest");\n'
                "const tsJestTransformCfg = createDefaultPreset().transform;\n"
                "module.exports = { transform: { ...tsJestTransformCfg } };\n");
        await write("firebase/functions/tsconfig.dev.json",
            '{"include":[".eslintrc.js"],"compilerOptions":{"allowJs":true}}');
      }
      final protected = <String, String>{};
      for (final path in [
        "pubspec.yaml",
        "pubspec.lock",
        "firebase/functions/package.json",
        "firebase/functions/package-lock.json"
      ]) {
        final file = File("${root.path}/$path");
        if (file.existsSync()) {
          protected[path] = file.readAsStringSync();
        }
      }
      final result = await Process.run(
          Platform.resolvedExecutable, [cli, "apply", if (local) "--local"],
          workingDirectory: root.path);
      final calls =
          File(trace).existsSync() ? File(trace).readAsLinesSync() : <String>[];
      if (local) {
        for (final entry in protected.entries) {
          _expect(
              File("${root.path}/${entry.key}").readAsStringSync() ==
                  entry.value,
              "ローカル適用は${entry.key}を保持する");
        }
        _expect(
            !calls.any((e) =>
                e.startsWith("firebase:") ||
                ["install", "uninstall", "dev"].contains(e)),
            "ローカル適用は外部操作・依存変更を起動しない: $calls");
        if (failure == "local") {
          _expect(result.exitCode == 0,
              "ローカル生成成功: ${result.stdout}\n${result.stderr}");
          _expect(calls.join(",") == "check,jest,lint",
              "導入済み依存検証とローカルツールだけを実行する: $calls");
          _expect(
              File("${root.path}/firebase/functions/.eslintrc.js").existsSync(),
              "Functionsのローカル設定を生成する");
          _expect(
              File("${root.path}/lib/katana/firebase/firebase_options.dart")
                  .existsSync(),
              "Firebaseローカルselectorを生成する");
        } else {
          _expect(result.exitCode != 0, "不足・不整合を成功扱いしない: $failure");
          _expect(
              !File("${root.path}/lib/katana/firebase/firebase_options.dart")
                  .existsSync(),
              "不足・不整合は設定反映前に検出する");
          _expect(calls.isEmpty || calls.join(",") == "check",
              "不足・不整合後は処理しない: $calls");
        }
      } else if (firestoreSetup) {
        _expect(calls.any((e) => e.startsWith("firebase:init firestore")),
            "Reach the actual Firebase init boundary: $calls");
        if (["firestore-init-failure", "firestore-mismatch"]
            .contains(failure)) {
          _expect(
              result.exitCode != 0 &&
                  !calls.any((e) => e.startsWith("firebase:deploy")),
              "Firestore init failure or a different selected region must stop deploy: $calls");
        } else {
          _expect(
              result.exitCode == 0 &&
                  calls.contains("firestore:location-confirmed"),
              "Answer the configured region even across output chunks: $failure / $calls / ${result.stdout}\n${result.stderr}");
        }
      } else if (failure == "none") {
        final arguments =
            await File("${root.path}/npm-arguments").readAsString();
        _expect(arguments.contains("@mathrunet/masamune_firebase"),
            "Install the runtime package used by the generated Functions entry.");
        _expect(RegExp(r"typescript@\^5\.").hasMatch(arguments),
            "Keep TypeScript compatible with the generated ESLint toolchain.");
        final jest =
            await File("${root.path}/firebase/functions/jest.config.js")
                .readAsString();
        _expect(
            jest.contains('preset: "ts-jest"') &&
                !jest.contains("...tsJestTransformCfg"),
            "Normalize generated Jest configuration before lint.");
        final tsconfig = jsonDecode(
            await File("${root.path}/firebase/functions/tsconfig.dev.json")
                .readAsString()) as Map;
        _expect(
            (tsconfig["include"] as List).contains("jest.config.js") &&
                (tsconfig["compilerOptions"] as Map)["allowJs"] == true,
            "Include Jest for lint while preserving compiler options.");
        _expect(result.exitCode == 0,
            "stderr警告のみは成功を維持する: ${result.stdout}\n${result.stderr}");
        _expect(
            calls.contains(
                "firebase:deploy --only firestore,functions --project fixture"),
            "A stale storage section must not be deployed when Storage is disabled: $calls");
      } else {
        _expect(calls.contains(failure),
            "対象の失敗条件に到達する: $failure / $calls / ${result.stdout}\n${result.stderr}");
        _expect(result.exitCode != 0, "$failure の非0をapplyへ伝播する");
        _expect(calls.last == failure, "$failure の後続処理・deployを起動しない: $calls");
      }
    } finally {
      await root.delete(recursive: true);
    }
  }
}
