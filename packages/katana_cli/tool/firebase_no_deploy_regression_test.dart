// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/firebase/init.dart";
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";
import "package:katana_cli/katana_cli.dart";

/// Offline regression checks for `katana apply --no-deploy`.
///
/// Every external command (`firebase`, `flutter`, `flutterfire`, `gsutil`) is
/// replaced by a recording fixture, so no network access or real deployment
/// happens.
Future<void> main() async {
  final packageRoot = File.fromUri(Platform.script).parent.parent;
  final cli = Platform.environment["KATANA_TEST_CLI"] ??
      "${packageRoot.path}/bin/katana.dart";

  await _verifyHelp(cli);
  await _verifyNoDeployApply(cli);
  await _verifyNoDeployInProcess();
  await _verifyNormalApply(cli);
  await _verifyLocalApplyRejectsMissingDependency(cli);
  await _verifyInternalFailureStops(cli);
  await _verifyScheduling();
  await _verifyDeployCommandGuard();
  stdout.writeln("All Firebase --no-deploy regression checks passed.");
}

/// The help lists the new option and the argument validator accepts it.
Future<void> _verifyHelp(String cli) async {
  final root = await Directory.systemTemp.createTemp("katana_no_deploy_help_");
  try {
    final result = await Process.run(
      Platform.resolvedExecutable,
      [cli, "apply", "--help"],
      workingDirectory: root.path,
    );
    _expect(result.exitCode == 0, "apply --help succeeds");
    _expect(result.stdout.toString().contains("[--no-deploy]"),
        "apply --help lists --no-deploy: ${result.stdout}");
  } finally {
    await root.delete(recursive: true);
  }
}

/// Existing Firestore/Storage settings plus missing auth dependencies:
/// dependencies and settings are applied, deploys and reservations are 0.
Future<void> _verifyNoDeployApply(String cli) async {
  final fixture = await _Fixture.create();
  try {
    final result = await fixture.run(cli, ["apply", "--no-deploy"]);
    final calls = fixture.calls;
    _expect(result.exitCode == 0,
        "--no-deploy apply succeeds: ${result.stdout}\n${result.stderr}");
    _expect(
      calls.contains("flutter:pub add firebase_auth katana_auth_firebase"),
      "--no-deploy adds the missing authentication dependencies: $calls",
    );
    _expectEqual(fixture.deployCount, 0,
        "--no-deploy runs no immediate Firebase deploy: $calls");
    _expect(!calls.any((e) => e.startsWith("gsutil:")),
        "--no-deploy does not touch remote Storage settings: $calls");
    _expect(
      result.stdout.toString().contains(
            "Skip firebase deploy (--no-deploy): firestore,storage",
          ),
      "--no-deploy records the skipped deploy targets",
    );
    _expect(
        fixture.file("lib/katana/firebase/firebase_options.dart").existsSync(),
        "--no-deploy writes the Firebase options selector");
    _expect(
      fixture
          .file("android/app/build.gradle.kts")
          .readAsStringSync()
          .contains("com.google.gms.google-services"),
      "--no-deploy reflects the Android Firebase settings",
    );
  } finally {
    await fixture.delete();
  }
}

/// Runs FirebaseInit in-process to count reservations precisely.
Future<void> _verifyNoDeployInProcess() async {
  final fixture = await _Fixture.create();
  final previous = Directory.current;
  try {
    Directory.current = fixture.root;
    final context = ExecContext(
      yaml: fixture.yaml,
      args: const ["apply", "--no-deploy"],
    );
    await runApplyCommands(
      () => const FirebaseInitCliAction().exec(context),
      noDeploy: context.noDeploy,
    );
    _expect(!isError, "In-process --no-deploy FirebaseInit succeeds");
    _expectEqual(context.postActions.length, 0,
        "--no-deploy schedules no deployment post action");
    _expectEqual(fixture.deployCount, 0,
        "--no-deploy runs no immediate deployment in-process");
    _expect(
      fixture.calls
          .contains("flutter:pub add firebase_auth katana_auth_firebase"),
      "In-process --no-deploy adds authentication dependencies",
    );
  } finally {
    Directory.current = previous;
    await fixture.delete();
  }
}

/// The normal apply keeps deploying existing enabled Firebase services.
Future<void> _verifyNormalApply(String cli) async {
  final fixture = await _Fixture.create();
  try {
    final result = await fixture.run(cli, ["apply"]);
    final calls = fixture.calls;
    _expect(result.exitCode == 0,
        "Normal apply succeeds: ${result.stdout}\n${result.stderr}");
    _expect(
      calls.contains("flutter:pub add firebase_auth katana_auth_firebase"),
      "Normal apply adds the missing authentication dependencies: $calls",
    );
    _expect(
      calls.contains(
          "firebase:deploy --only firestore,storage --project fixture"),
      "Normal apply keeps deploying enabled Firestore and Storage: $calls",
    );
    _expectEqual(fixture.deployCount, 1, "Normal apply deploys once: $calls");
  } finally {
    await fixture.delete();
  }
}

/// `--local` still rejects missing dependencies without changing them.
Future<void> _verifyLocalApplyRejectsMissingDependency(String cli) async {
  final fixture = await _Fixture.create(local: true);
  try {
    final pubspec = fixture.file("pubspec.yaml").readAsStringSync();
    final lock = fixture.file("pubspec.lock").readAsStringSync();
    final result = await fixture.run(cli, ["apply", "--local"]);
    final calls = fixture.calls;
    _expect(result.exitCode != 0,
        "--local rejects missing authentication dependencies");
    _expect(
      "${result.stdout}${result.stderr}".contains("firebase_auth"),
      "--local reports the missing dependency: ${result.stderr}",
    );
    _expect(!calls.any((e) => e.startsWith("flutter:")),
        "--local does not add dependencies: $calls");
    _expectEqual(fixture.deployCount, 0, "--local does not deploy: $calls");
    _expectEqual(fixture.file("pubspec.yaml").readAsStringSync(), pubspec,
        "--local keeps pubspec.yaml");
    _expectEqual(fixture.file("pubspec.lock").readAsStringSync(), lock,
        "--local keeps pubspec.lock");
  } finally {
    await fixture.delete();
  }
}

/// A failing dependency command stops the apply with a non-zero exit.
Future<void> _verifyInternalFailureStops(String cli) async {
  for (final arguments in [
    ["apply", "--no-deploy"],
    ["apply"],
  ]) {
    final fixture = await _Fixture.create(failPubAdd: true);
    try {
      final gradle = fixture.file("android/app/build.gradle.kts");
      final before = gradle.readAsStringSync();
      final result = await fixture.run(cli, arguments);
      final calls = fixture.calls;
      _expect(result.exitCode != 0,
          "${arguments.join(" ")}: a failing pub add propagates: $calls");
      _expect(
          calls.contains("flutter:pub add firebase_auth katana_auth_firebase"),
          "${arguments.join(" ")}: the failure boundary is reached: $calls");
      _expectEqual(fixture.deployCount, 0,
          "${arguments.join(" ")}: no deploy after a failure: $calls");
      _expectEqual(gradle.readAsStringSync(), before,
          "${arguments.join(" ")}: later settings are not applied");
    } finally {
      await fixture.delete();
    }
  }
}

/// Reservations are dropped with --no-deploy and kept otherwise.
Future<void> _verifyScheduling() async {
  final normal = ExecContext(yaml: const {}, args: const ["apply"]);
  await runApplyCommands(() async {
    normal.requestFirebaseDeploy(FirebaseDeployPostActionType.firestore);
    normal.requestFirebaseDeploy(FirebaseDeployPostActionType.storage);
  });
  _expectEqual(normal.postActions.length, 1,
      "Normal apply still schedules one merged deploy post action");

  final noDeploy =
      ExecContext(yaml: const {}, args: const ["apply", "--no-deploy"]);
  await runApplyCommands(() async {
    noDeploy.requestFirebaseDeploy(FirebaseDeployPostActionType.firestore);
    noDeploy.requestFirebaseDeploy(FirebaseDeployPostActionType.storage);
    noDeploy.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
  }, noDeploy: true);
  _expectEqual(noDeploy.postActions.length, 0,
      "--no-deploy schedules no deploy post action");

  // A post action leaked into a --no-deploy context must fail closed.
  final leaked = ExecContext(
    yaml: const {
      "firebase": {"project_id": "fixture"},
      "bin": {"firebase": "/nonexistent/firebase"},
    },
    args: const ["apply", "--no-deploy"],
  );
  leaked.postActions.addAll(normal.postActions);
  var rejected = false;
  try {
    for (final action in leaked.postActions) {
      await action.exec(leaked);
    }
  } on StateError {
    rejected = true;
  }
  _expect(rejected, "A leaked deploy post action is rejected by --no-deploy");
}

/// `command()` refuses deploy subcommands under --no-deploy.
Future<void> _verifyDeployCommandGuard() async {
  final root = await Directory.systemTemp.createTemp("katana_no_deploy_cmd_");
  try {
    final marker = File("${root.path}/called");
    final fake = File("${root.path}/firebase-fake");
    await fake.writeAsString("#!/bin/sh\ntouch '${marker.path}'\n");
    await Process.run("chmod", ["+x", fake.path]);
    var rejected = false;
    try {
      await runApplyCommands(
        () => command("Run firebase deploy", [fake.path, "deploy"]),
        noDeploy: true,
      );
    } on StateError {
      rejected = true;
    }
    _expect(rejected && !marker.existsSync(),
        "--no-deploy refuses an unexpected deploy command");
  } finally {
    await root.delete(recursive: true);
  }
}

class _Fixture {
  _Fixture._(this.root, this.yaml);

  final Directory root;
  final Map<String, dynamic> yaml;

  File file(String path) => File("${root.path}/$path");

  String get _trace => "${root.path}/calls";

  List<String> get calls =>
      File(_trace).existsSync() ? File(_trace).readAsLinesSync() : <String>[];

  int get deployCount =>
      calls.where((e) => e.startsWith("firebase:deploy")).length;

  Future<ProcessResult> run(String cli, List<String> arguments) {
    return Process.run(
      Platform.resolvedExecutable,
      [cli, ...arguments],
      workingDirectory: root.path,
    );
  }

  Future<void> delete() => root.delete(recursive: true);

  static Future<_Fixture> create({
    bool local = false,
    bool failPubAdd = false,
  }) async {
    final root = await Directory.systemTemp.createTemp("katana_no_deploy_");
    Future<void> write(String name, String content) async {
      final file = File("${root.path}/$name");
      await file.parent.create(recursive: true);
      await file.writeAsString(content);
    }

    final trace = "${root.path}/calls";
    await write("firebase-fake", """
#!/bin/sh
echo "firebase:\$*" >> '$trace'
if [ "\$1" = "login:list" ]; then
  echo 'Logged in as fixture@example.com'
elif [ "\$1" = "projects:list" ]; then
  echo '{"status":"success","result":[{"projectId":"fixture"}]}'
fi
exit 0
""");
    await write("flutter-fake", """
#!/bin/sh
echo "flutter:\$*" >> '$trace'
${failPubAdd ? '[ "\$1" = "pub" ] && [ "\$2" = "add" ] && { echo "fixture pub add failure" >&2; exit 17; }' : ""}
exit 0
""");
    for (final name in ["flutterfire", "gsutil"]) {
      await write("$name-fake", """
#!/bin/sh
echo "$name:\$*" >> '$trace'
exit 0
""");
    }
    for (final name in ["firebase", "flutter", "flutterfire", "gsutil"]) {
      await Process.run("chmod", ["+x", "${root.path}/$name-fake"]);
    }
    final yaml = <String, dynamic>{
      "bin": {
        for (final name in ["firebase", "flutter", "flutterfire", "gsutil"])
          name: "${root.path}/$name-fake",
      },
      "firebase": {
        "project_id": "fixture",
        "firestore": {"enable": true},
        "storage": {"enable": true},
        "authentication": {"enable": true},
      },
    };
    await write("katana.yaml", jsonEncode(yaml));
    final installed = [
      "firebase_core",
      "cloud_firestore",
      "katana_model_firestore",
      "firebase_storage",
      "katana_storage_firebase",
    ];
    await write(
      "pubspec.yaml",
      "name: fixture\ndependencies:\n"
          "${installed.map((e) => e == "cloud_firestore" ? "  $e: ^7.1.0" : "  $e: any").join("\n")}\n",
    );
    await write(
      "pubspec.lock",
      "packages:\n"
          "${installed.map((e) => e == "cloud_firestore" ? "  $e:\n    version: '7.1.0'" : "  $e: {}").join("\n")}\n",
    );
    if (local) {
      await write(
        ".dart_tool/package_config.json",
        jsonEncode({
          "configVersion": 2,
          "packages": [
            for (final name in installed)
              {
                "name": name,
                "rootUri": "../installed/$name",
                "packageUri": "lib/",
                "languageVersion": "3.0",
              },
          ],
        }),
      );
      for (final name in installed) {
        await write("installed/$name/pubspec.yaml", "name: $name\n");
      }
    }
    await write("firebase/firebase.json", '{"firestore":{},"storage":{}}');
    await write("firebase/.gitignore", ".env\n");
    await write(
      "android/app/src/katanaFirebase/prod/google-services.json",
      '{"project_info":{"project_id":"fixture"}}',
    );
    for (final platform in ["ios", "macos"]) {
      await write(
        "$platform/Runner/Firebase/prod/GoogleService-Info.plist",
        "<plist><dict><key>PROJECT_ID</key><string>fixture</string></dict></plist>",
      );
    }
    await write(
        "lib/katana/firebase/prod/firebase_options.dart", "// fixture\n");
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
    await write(
      "android/settings.gradle.kts",
      'plugins {\n    id("com.android.application") version "8.7.0" apply false\n}\n',
    );
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
    return _Fixture._(root, yaml);
  }
}

void _expect(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual != expected) {
    throw StateError("$message: expected <$expected>, actual <$actual>");
  }
}
