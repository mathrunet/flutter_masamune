// Dart imports:
import "dart:io";

import "package:katana_cli/action/firebase/messaging.dart";
import "package:katana_cli/action/purchase/purchase.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main(List<String> arguments) async {
  final packageRoot = File.fromUri(Platform.script).parent.parent;
  final cli = File("${packageRoot.path}/bin/katana.dart");

  await _verifyLocalCloudflareSecrets(
      messagingOnly: arguments.contains("--messaging-only"));
  if (arguments.contains("--messaging-only")) {
    stdout.writeln("Messaging local regression checks passed.");
    return;
  }
  if (arguments.contains("--secrets-only")) {
    stdout.writeln("Messaging/Purchase local regression checks passed.");
    return;
  }
  if (arguments.contains("--cloudflare-only")) {
    await _verifyLocalCloudflare(cli);
    stdout.writeln("Cloudflare local regression checks passed.");
    return;
  }
  await _verifyLocalCloudflare(cli);
  if (arguments.contains("--hook-only")) {
    await _verifyLocalHooks(cli);
    stdout.writeln("All local hook regression checks passed.");
    return;
  }
  await _verifyLocalHooks(cli);
  await _verifyHelpHasNoSideEffects(cli, "--help");
  await _verifyHelpHasNoSideEffects(cli, "-h");
  await _verifyUnknownArgumentHasNoSideEffects(cli);

  await _verifyLocalApply(cli);

  stdout.writeln("All apply help regression checks passed.");
}

Future<void> _verifyHelpHasNoSideEffects(File cli, String helpFlag) async {
  final fixture = await _createFixture();
  try {
    final before = await _snapshot(fixture.root);
    final result = await _runCli(cli, fixture.root, ["apply", helpFlag]);
    final after = await _snapshot(fixture.root);

    _expectEqual(result.exitCode, 0, "$helpFlag exits successfully");
    _expect(
      result.stdout.toString().contains("Usage: katana apply"),
      "$helpFlag displays apply usage",
    );
    _expectEqual(
      after.toString(),
      before.toString(),
      "$helpFlag does not generate or update files",
    );
    _expect(
      !fixture.externalCommandMarker.existsSync(),
      "$helpFlag does not execute configured external commands",
    );
  } finally {
    await fixture.root.delete(recursive: true);
  }
}

Future<void> _verifyUnknownArgumentHasNoSideEffects(File cli) async {
  final fixture = await _createFixture();
  try {
    final before = await _snapshot(fixture.root);
    final result = await _runCli(
      cli,
      fixture.root,
      ["apply", "--unknown-option"],
    );
    final after = await _snapshot(fixture.root);

    _expect(result.exitCode != 0, "an unknown apply option fails");
    _expect(
      result.stderr.toString().contains("Unknown argument"),
      "an unknown apply option reports the invalid argument",
    );
    _expectEqual(
      after.toString(),
      before.toString(),
      "an unknown apply option does not generate or update files",
    );
    _expect(
      !fixture.externalCommandMarker.existsSync(),
      "an unknown apply option does not execute configured external commands",
    );
  } finally {
    await fixture.root.delete(recursive: true);
  }
}

Future<_Fixture> _createFixture() async {
  final root = await Directory.systemTemp.createTemp("katana_apply_help_");
  final externalCommandMarker = File("${root.path}/external-command-called");
  final fakeWrangler = File("${root.path}/fake-wrangler.sh");
  await fakeWrangler.writeAsString("""
#!/bin/sh
touch "${externalCommandMarker.path}"
exit 1
""");
  final chmod = await Process.run("chmod", ["+x", fakeWrangler.path]);
  _expectEqual(chmod.exitCode, 0, "the fake external command is executable");
  await File("${root.path}/pubspec.yaml").writeAsString("name: fixture\n");
  await File("${root.path}/katana.yaml").writeAsString("""
bin:
  wrangler: ${fakeWrangler.path}
cloudflare:
  project_id: fixture
  workers:
    enable: true
""");
  return _Fixture(
    root: root,
    externalCommandMarker: externalCommandMarker,
  );
}

Future<ProcessResult> _runCli(
  File cli,
  Directory workingDirectory,
  List<String> arguments,
) {
  return Process.run(
    Platform.resolvedExecutable,
    [cli.path, ...arguments],
    workingDirectory: workingDirectory.path,
  );
}

Future<Map<String, String>> _snapshot(Directory root) async {
  final snapshot = <String, String>{};
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    final relativePath = entity.path.substring(root.path.length + 1);
    if (entity is File) {
      snapshot[relativePath] = await entity.readAsString();
    } else if (entity is Directory) {
      snapshot["$relativePath/"] = "";
    }
  }
  return Map.fromEntries(
    snapshot.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual != expected) {
    throw StateError("$message: expected <$expected>, actual <$actual>");
  }
}

class _Fixture {
  const _Fixture({
    required this.root,
    required this.externalCommandMarker,
  });

  final Directory root;
  final File externalCommandMarker;
}

Future<void> _verifyLocalApply(File cli) async {
  final root = await Directory.systemTemp.createTemp("katana_apply_local_");
  try {
    await File("${root.path}/pubspec.yaml").writeAsString("name: fixture\n");
    await File("${root.path}/pubspec.lock").writeAsString("packages: {}\n");
    await Directory("${root.path}/.dart_tool").create();
    await File("${root.path}/.dart_tool/package_config.json")
        .writeAsString('{"configVersion":2,"packages":[]}');
    await File("${root.path}/katana.yaml").writeAsString("app: {}\n");
    final manifest =
        File("${root.path}/android/app/src/main/AndroidManifest.xml");
    await manifest.parent.create(recursive: true);
    await manifest.writeAsString(
        '<manifest xmlns:android="http://schemas.android.com/apk/res/android"><application/><queries><package android:name="example.package"/></queries><queries><package android:name="example.package"/></queries></manifest>');
    await manifest.writeAsString(
        r'<manifest xmlns:android="http://schemas.android.com/apk/res/android"><application><meta-data android:name="fixture.key" android:value="${FIXTURE_KEY}"/></application></manifest>');
    final gradle = File("${root.path}/android/app/build.gradle.kts");
    await gradle.writeAsString(
        'android {\n    defaultConfig {\n        applicationId = "com.example.fixture"\n    }\n}\n');
    final before = await gradle.readAsString();
    final result = await _runCli(cli, root, ["apply", "--local"]);
    _expectEqual(
        result.exitCode, 0, "--local は既存依存でローカル設定を反映できる: ${result.stderr}");
    _expect(await gradle.readAsString() != before, "ローカル設定が実際に生成される");
    _expectEqual(await File("${root.path}/pubspec.lock").readAsString(),
        "packages: {}\n", "lockを保持する");
    _expectEqual(await File("${root.path}/pubspec.yaml").readAsString(),
        "name: fixture\n", "依存宣言を保持する");
  } finally {
    await root.delete(recursive: true);
  }
}

Future<void> _verifyLocalHooks(File cli) async {
  for (final installed in [false, true]) {
    final root = await Directory.systemTemp.createTemp("katana_local_hooks_");
    try {
      Future<void> write(String path, String contents) async {
        final file = File("${root.path}/$path");
        await file.parent.create(recursive: true);
        await file.writeAsString(contents);
      }

      await write(".git/hooks/pre-commit", "既存hookを保持\n");
      await write("pubspec.yaml",
          "name: fixture\ndev_dependencies:\n  import_sorter: any\n");
      await write("pubspec.lock", "packages:\n  import_sorter: {}\n");
      await write(".dart_tool/package_config.json",
          '{"configVersion":2,"packages":[{"name":"import_sorter","rootUri":"../installed/import_sorter","packageUri":"lib/"}]}');
      await write(
          "installed/import_sorter/pubspec.yaml", "name: import_sorter\n");
      await write("firebase/functions/package.json", '{"dependencies":{}}');
      await write("firebase/functions/package-lock.json",
          '{"lockfileVersion":3,"packages":{"":{}}}');
      await write("katana.yaml",
          "bin:\n  lefthook: ${root.path}/bin/lefthook\ngit:\n  pre_commit:\n    enable: true\n");
      final marker = File("${root.path}/hook-install-called");
      if (installed) {
        await write(
            "bin/lefthook", "#!/bin/sh\n: > '${marker.path}'\nexit 0\n");
        final chmod =
            await Process.run("chmod", ["+x", "${root.path}/bin/lefthook"]);
        _expectEqual(chmod.exitCode, 0, "偽のhook実行境界を準備する");
      }
      final protected = <String, String>{};
      for (final path in [
        "pubspec.yaml",
        "pubspec.lock",
        "firebase/functions/package.json",
        "firebase/functions/package-lock.json",
        ".git/hooks/pre-commit"
      ]) {
        protected[path] = await File("${root.path}/$path").readAsString();
      }
      final result = await _runCli(cli, root, ["apply", "--local"]);
      _expectEqual(result.exitCode, 0,
          "lefthook導入有無によらずローカル設定を反映する (installed=$installed): ${result.stderr}");
      _expect(
          File("${root.path}/lefthook.yaml")
              .readAsStringSync()
              .contains("pre-commit:"),
          "hook設定ファイルを実際に生成する");
      _expect(!marker.existsSync(), "--local はhookを有効化しない");
      for (final entry in protected.entries) {
        _expectEqual(await File("${root.path}/${entry.key}").readAsString(),
            entry.value, "${entry.key}を保持する");
      }
      if (installed) {
        final normal = await _runCli(cli, root, ["apply"]);
        _expectEqual(
            normal.exitCode, 0, "通常applyのhook有効化は維持する: ${normal.stderr}");
        _expect(marker.existsSync(), "通常applyでは既存のlefthook installを実行する");
      }
    } finally {
      await root.delete(recursive: true);
    }
  }
}

Future<void> _verifyLocalCloudflare(File cli) async {
  for (final scenario in [
    "valid",
    "missing",
    "version",
    "lock",
    "init",
    "rotation",
    "storage_missing",
    "storage_invalid"
  ]) {
    final root =
        await Directory.systemTemp.createTemp("katana_local_cloudflare_");
    try {
      Future<void> write(String path, String content) async {
        final file = File("${root.path}/$path");
        await file.parent.create(recursive: true);
        await file.writeAsString(content);
      }

      const dartPackages = [
        "masamune_functions_cloudflare",
        "masamune_model_turso",
        "masamune_storage_cloudflare"
      ];
      const nodePackages = [
        "hono",
        "@mathrunet/masamune",
        "@mathrunet/masamune_cloudflare",
        "@mathrunet/masamune_cloudflare_turso",
        "@mathrunet/masamune_cloudflare_storage"
      ];
      await write("pubspec.yaml",
          "name: fixture\ndependencies:\n${dartPackages.map((p) => '  $p: any').join('\n')}\n");
      await write("pubspec.lock",
          "packages:\n${dartPackages.map((p) => '  $p: {}').join('\n')}\n");
      await write(".dart_tool/package_config.json",
          '{"configVersion":2,"packages":[${dartPackages.map((p) => '{"name":"$p","rootUri":"../installed/$p","packageUri":"lib/"}').join(",")}]}');
      for (final p in dartPackages) {
        await write("installed/$p/pubspec.yaml", "name: $p\n");
      }
      final dependencies = nodePackages.map((p) => '"$p":"1.0.0"').join(",");
      await write(
          "cloudflare/package.json", '{"dependencies":{$dependencies}}');
      await write("cloudflare/package-lock.json",
          '{"lockfileVersion":3,"packages":{"":{"dependencies":{$dependencies}},${nodePackages.map((p) => '"node_modules/$p":{"version":"1.0.0"}').join(",")}}}');
      for (final p in nodePackages) {
        if (scenario == "missing" && p == "hono") {
          continue;
        }
        await write("cloudflare/node_modules/$p/package.json",
            '{"name":"$p","version":"1.0.0"}');
      }
      await write("cloudflare/.gitignore", "node_modules\n");
      await write("cloudflare/src/index.ts",
          'import * as m from "@mathrunet/masamune_cloudflare";\nexport default m.deploy([], { rules: {} });\n');
      await write("cloudflare/wrangler.jsonc",
          '{"name":"fixture","main":"src/index.ts","routes":["example.invalid/*"]}');
      final marker = File("${root.path}/external-called");
      await write("external.sh", "#!/bin/sh\ntouch '${marker.path}'\nexit 9\n");
      await Process.run("chmod", ["+x", "${root.path}/external.sh"]);
      await write("katana.yaml",
          "bin:\n  npm: ${root.path}/external.sh\n  wrangler: ${root.path}/external.sh\ncloudflare:\n  project_id: fixture\n  workers:\n    enable: true\n  turso:\n    enable: true\n    organization: fixture\n    group: fixture\n");
      if (scenario == "version") {
        await write("cloudflare/node_modules/hono/package.json",
            '{"name":"hono","version":"2.0.0"}');
      }
      if (scenario == "lock") {
        await write("cloudflare/package-lock.json",
            '{"lockfileVersion":3,"packages":{}}');
      }
      if (scenario == "init") {
        await File("${root.path}/cloudflare/wrangler.jsonc").delete();
      }
      if (scenario == "rotation") {
        final config = File("${root.path}/katana.yaml");
        await config.writeAsString(
            "${await config.readAsString()}    rotate_legacy_tokens: true\n");
      }
      final config = File("${root.path}/katana.yaml");
      await config.writeAsString(
          "${await config.readAsString()}  storage:\n    enable: true\n    bucket_name: fixture-bucket\n    public_base_url: https://storage.invalid\n    backup:\n      enable: true\n      bucket_name: fixture-backup\n");
      await write("cloudflare/storage.yaml",
          "version: 1\ndownload_url_secret: fixture-only\n");
      await write("katana_secrets.yaml", "cloudflare: {}\n");
      if (scenario == "storage_missing") {
        await File(
                "${root.path}/cloudflare/node_modules/@mathrunet/masamune_cloudflare_storage/package.json")
            .delete();
      }
      if (scenario == "storage_invalid") {
        await config.writeAsString((await config.readAsString())
            .replaceFirst("bucket_name: fixture-bucket", "bucket_name: ''"));
      }
      final protected = <String, String>{};
      for (final path in [
        "pubspec.yaml",
        "pubspec.lock",
        "cloudflare/package.json",
        "cloudflare/package-lock.json",
        "cloudflare/storage.yaml",
        "katana_secrets.yaml"
      ]) {
        protected[path] = File("${root.path}/$path").readAsStringSync();
      }
      final before = await _snapshot(root);
      final result = await _runCli(cli, root, ["apply", "--local"]);
      if (scenario != "valid") {
        final expected = switch (scenario) {
          "init" => "wrangler.jsonc",
          "rotation" => "rotation",
          "storage_missing" => "masamune_cloudflare_storage",
          "storage_invalid" => "bucket_name",
          _ => "hono"
        };
        _expect(
            result.exitCode != 0 && result.stderr.toString().contains(expected),
            "前提不備を具体的に報告する ($scenario): ${result.stderr}");
        _expectEqual((await _snapshot(root)).toString(), before.toString(),
            "依存不足ならローカル生成前に停止する");
      } else {
        _expectEqual(
            result.exitCode, 0, "Workers/Tursoのローカル適用に成功する: ${result.stderr}");
        _expect(
            File("${root.path}/cloudflare/src/index.ts")
                .readAsStringSync()
                .contains("turso.Functions.turso("),
            "Turso関数を実際に同期する");
        final source =
            File("${root.path}/cloudflare/src/index.ts").readAsStringSync();
        _expect(
            source.contains("storage.Functions.storageCloudflare(") &&
                source.contains("storage.Functions.storageCloudflareBackup("),
            "Storageとbackup関数を同期する");
        final wrangler =
            File("${root.path}/cloudflare/wrangler.jsonc").readAsStringSync();
        _expect(
            wrangler.contains("TURSO_ORGANIZATION") &&
                wrangler.contains("example.invalid/*"),
            "ローカル変数を同期し既存routeを保持する");
        _expect(
            wrangler.contains("fixture-bucket") &&
                wrangler.contains("fixture-backup") &&
                wrangler.contains("consumers"),
            "R2とQueueのローカル設定を同期する");
      }
      _expect(!marker.existsSync(), "外部コマンドを実行しない");
      for (final entry in protected.entries) {
        _expectEqual(File("${root.path}/${entry.key}").readAsStringSync(),
            entry.value, "${entry.key}を保持する");
      }
    } finally {
      await root.delete(recursive: true);
    }
  }
}

Future<void> _verifyLocalCloudflareSecrets({bool messagingOnly = false}) async {
  final failures = <String>[];
  for (final messaging in [true, if (!messagingOnly) false]) {
    for (final local in [true, false]) {
      final root =
          await Directory.systemTemp.createTemp("katana_local_secrets_");
      final previous = Directory.current;
      try {
        Future<void> write(String path, String content) async {
          final file = File("${root.path}/$path");
          await file.parent.create(recursive: true);
          await file.writeAsString(content);
        }

        final dartPackages = [
          "masamune_notification_firebase",
          "masamune_purchase_mobile",
          "masamune_functions_cloudflare"
        ];
        final nodePackages = [
          "@mathrunet/masamune_cloudflare_notification",
          "@mathrunet/masamune_cloudflare_purchase",
          "@mathrunet/masamune_cloudflare_turso"
        ];
        await write("pubspec.yaml",
            "name: fixture\ndependencies:\n${dartPackages.map((p) => '  $p: any').join('\n')}\n");
        await write("pubspec.lock",
            "packages:\n${dartPackages.map((p) => '  $p: {}').join('\n')}\n");
        await write(".dart_tool/package_config.json",
            '{"configVersion":2,"packages":[${dartPackages.map((p) => '{"name":"$p","rootUri":"../installed/$p","packageUri":"lib/"}').join(",")}]}');
        for (final p in dartPackages) {
          await write("installed/$p/pubspec.yaml", "name: $p\n");
        }
        final dependencies = nodePackages.map((p) => '"$p":"1.0.0"').join(",");
        await write(
            "cloudflare/package.json", '{"dependencies":{$dependencies}}');
        await write("cloudflare/package-lock.json",
            '{"lockfileVersion":3,"packages":{"":{"dependencies":{$dependencies}},${nodePackages.map((p) => '"node_modules/$p":{"version":"1.0.0"}').join(",")}}}');
        for (final p in nodePackages) {
          await write("cloudflare/node_modules/$p/package.json",
              '{"name":"$p","version":"1.0.0"}');
        }
        await write("cloudflare/src/index.ts",
            'import * as m from "@mathrunet/masamune_cloudflare";\nexport default m.deploy([], { rules: {} });\n');
        await write("android/app/build.gradle.kts", """
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
    }
}
""");
        await write("android/build.gradle",
            "buildscript {\n    ext.kotlin_version = '1.9.0'\n}\n");
        await write("android/settings.gradle.kts",
            'plugins {\n    id("com.android.application") version "8.7.0" apply false\n}\n');
        await write("android/app/src/main/AndroidManifest.xml",
            '<manifest xmlns:android="http://schemas.android.com/apk/res/android"><application><activity android:name=".MainActivity" /></application></manifest>');
        await write("android/service-account.json",
            '{"type":"service_account","client_email":"fixture@example.invalid","private_key":"fixture-private-key"}');
        await write("ios/Runner/AppDelegate.swift",
            "    GeneratedPluginRegistrant.register(with: self)\n");
        await write("ios/Runner.xcodeproj/project.pbxproj", """
/* Begin PBXGroup section */
111111111111111111111111 /* Runner */ = {
    isa = PBXGroup;
    children = (
    );
    path = Runner;
    sourceTree = "<group>";
};
333333333333333333333333 /* Frameworks */ = {
    isa = PBXGroup;
    children = (
    );
    name = Frameworks;
    sourceTree = "<group>";
};
/* End PBXGroup section */
/* Begin PBXFrameworksBuildPhase section */
222222222222222222222222 /* Frameworks */ = {
    isa = PBXFrameworksBuildPhase;
    buildActionMask = 2147483647;
    files = (
    );
    runOnlyForDeploymentPostprocessing = 0;
};
/* End PBXFrameworksBuildPhase section */
""");
        await Directory("${root.path}/web").create();
        final marker = File("${root.path}/wrangler-calls");
        await write("wrangler-fake",
            "#!/bin/sh\necho \"\$*\" >> '${marker.path}'\ncat >/dev/null\n");
        await Process.run("chmod", ["+x", "${root.path}/wrangler-fake"]);
        final context = ExecContext(yaml: {
          "bin": {
            "npm": "${root.path}/forbidden-npm",
            "wrangler": "${root.path}/wrangler-fake"
          },
          "firebase": {
            "project_id": "fixture",
            "messaging": {
              "enable": true,
              "channel_id": "fixture",
              "service_account":
                  '{"type":"service_account","project_id":"fixture","client_email":"fixture@example.com","private_key":"fixture-secret"}'
            }
          },
          "cloudflare": {
            "workers": {"enable": true},
            "turso": {"enable": true}
          },
          "purchase": {
            "enable": true,
            "google_play": {"enable": true},
            "app_store": {
              "enable": true,
              "shared_secret": "fixture-shared-secret"
            }
          }
        }, args: [
          "apply",
          if (local) "--local"
        ]);
        final protected = {
          for (final path in [
            "pubspec.yaml",
            "pubspec.lock",
            "cloudflare/package.json",
            "cloudflare/package-lock.json",
            "android/service-account.json"
          ])
            path: File("${root.path}/$path").readAsStringSync()
        };
        Directory.current = root;
        await runApplyCommands(() async {
          if (messaging) {
            await const FirebaseMessagingCliAction().exec(context);
          } else {
            await const PurchaseCliAction().exec(context);
          }
        }, local: local);
        final source = File("cloudflare/src/index.ts").readAsStringSync();
        final functions = messaging
            ? ["notification.Functions.sendNotification"]
            : [
                for (final platform in ["IOS", "Android"])
                  for (final name in [
                    "consumableVerify",
                    "nonconsumableVerify",
                    "subscriptionVerify",
                    "purchaseWebhook"
                  ])
                    "purchase.Functions.$name$platform"
              ];
        for (final name in functions) {
          _expect(source.contains(name), "$name のローカル生成を維持する");
        }
        _expect(source.contains("new turso.TursoDatabaseAdapter()"),
            "Turso連携を維持する");
        _expect(
            context.postActions.isEmpty, "Cloudflare経路ではFirebase deployを登録しない");
        if (local) {
          _expect(!marker.existsSync(), "localではWranglerを起動しない");
        } else {
          final calls = marker.readAsLinesSync();
          final names = messaging
              ? ["GOOGLE_SERVICE_ACCOUNT"]
              : [
                  "PURCHASE_SUBSCRIPTIONPATH",
                  "PURCHASE_ANDROID_SERVICEACCOUNT_EMAIL",
                  "PURCHASE_ANDROID_SERVICEACCOUNT_PRIVATE_KEY",
                  "PURCHASE_IOS_SHAREDSECRET"
                ];
          _expectEqual(calls.length, names.length, "通常経路では全secret更新を維持する");
          for (final name in names) {
            _expect(calls.contains("secret put $name --env prod"),
                "$name の更新を維持する");
          }
        }
        for (final entry in protected.entries) {
          _expectEqual(File(entry.key).readAsStringSync(), entry.value,
              "${entry.key} を保持する");
        }
      } catch (error, stack) {
        failures.add(
            "${messaging ? 'Messaging' : 'Purchase'} local=$local: $error\n$stack");
      } finally {
        Directory.current = previous;
        await root.delete(recursive: true);
      }
    }
  }
  _expect(failures.isEmpty, failures.join("\n"));
}
