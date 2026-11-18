import "dart:io";

import "package:katana_cli/action/cloudflare/authentication.dart";
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

/// Runs [body] in a temporary project with a fake `wrangler` / `gh` that log calls.
Future<List<String>> _fixture(
  Future<void> Function(String fakeCommand) body,
) async {
  final previous = Directory.current;
  final temporaryRoot = Directory(".tmp")..createSync(recursive: true);
  final temporary = temporaryRoot.createTempSync("no-secrets-").absolute;
  try {
    Directory.current = temporary;
    Directory("cloudflare/src").createSync(recursive: true);
    File("pubspec.yaml").writeAsStringSync(
      "name: fixture\ndependencies:\n"
      "  masamune_auth_firebase: any\n"
      "  masamune_functions_cloudflare: any\n",
    );
    File("cloudflare/package.json").writeAsStringSync(
      '{"dependencies": {"@mathrunet/masamune_cloudflare_auth": "1.0.0"}}',
    );
    File("cloudflare/src/edge.ts").writeAsStringSync(
      'import * as m from "@mathrunet/masamune_cloudflare";\n'
      "export default m.deploy([\n], {});\n",
    );
    final fake = File("fake-command").absolute;
    fake.writeAsStringSync(
      '#!/bin/sh\nprintf \'%s\\n\' "\$*" >> "${temporary.path}/calls.log"\n'
      "cat > /dev/null\nexit 0\n",
    );
    final chmod = await Process.run("chmod", ["+x", fake.path]);
    _check(chmod.exitCode == 0, "Fixture executable could not be prepared");
    await body(fake.path);
    final log = File("${temporary.path}/calls.log");
    return log.existsSync() ? log.readAsLinesSync() : [];
  } finally {
    Directory.current = previous;
    temporary.deleteSync(recursive: true);
  }
}

ExecContext _authContext(String wrangler, {required bool noSecrets}) {
  return ExecContext(
    yaml: {
      "bin": {"wrangler": wrangler, "npm": wrangler},
      "firebase": {
        "project_id": "fixture-project",
        "authentication": {"enable": true},
      },
      "cloudflare": {
        "workers": {"enable": true, "enable_firebase_auth": true},
        "authentication": {
          "delete_user": {"enable": true},
        },
      },
    },
    args: ["apply", if (noSecrets) "--no-secrets"],
  );
}

Future<void> main() async {
  await _purchaseCliRegression();
  // putWranglerSecret is skipped with --no-secrets and runs otherwise.
  final skippedWrangler = await _fixture((fake) async {
    await runApplyCommands(
      () => putWranglerSecret(
        wrangler: fake,
        environment: "dev",
        name: "FIXTURE",
        value: "fixture-value",
      ),
      noSecrets: true,
    );
  });
  _check(skippedWrangler.isEmpty, "wrangler was called with --no-secrets");
  final putWrangler = await _fixture((fake) async {
    await runApplyCommands(
      () => putWranglerSecret(
        wrangler: fake,
        environment: "dev",
        name: "FIXTURE",
        value: "fixture-value",
      ),
    );
  });
  _check(
    putWrangler.length == 1 &&
        putWrangler.single == "secret put FIXTURE --env dev",
    "wrangler secret put was not called by default: $putWrangler",
  );

  // githubSecret is skipped with --no-secrets and runs otherwise.
  final skippedGithub = await _fixture((fake) async {
    await runApplyCommands(
      () => githubSecret("Fixture", gh: fake, name: "FIXTURE", value: "v"),
      noSecrets: true,
    );
  });
  _check(skippedGithub.isEmpty, "gh was called with --no-secrets");
  final putGithub = await _fixture((fake) async {
    await runApplyCommands(
      () => githubSecret("Fixture", gh: fake, name: "FIXTURE", value: "v"),
    );
  });
  _check(
    putGithub.length == 1 && putGithub.single == "secret set FIXTURE",
    "gh secret set was not called by default: $putGithub",
  );

  // The Worker service account is neither resolved nor put with --no-secrets,
  // while the Worker source is still updated.
  late String edge;
  final skippedAuth = await _fixture((fake) async {
    final context = _authContext(fake, noSecrets: true);
    await runApplyCommands(
      () => const CloudflareAuthenticationCliAction().exec(context),
      noSecrets: context.noSecrets,
    );
    edge = File("cloudflare/src/edge.ts").readAsStringSync();
  });
  _check(skippedAuth.isEmpty, "External commands ran with --no-secrets");
  _check(
    edge.contains("auth.Functions.deleteUser()"),
    "Worker source was not updated with --no-secrets",
  );

  // Without --no-secrets the service account is resolved (and fails here
  // because the fixture has none), so the default behavior is unchanged.
  var resolved = false;
  final defaultAuth = await _fixture((fake) async {
    final context = _authContext(fake, noSecrets: false);
    try {
      await runApplyCommands(
        () => const CloudflareAuthenticationCliAction().exec(context),
        noSecrets: context.noSecrets,
      );
    } on StateError catch (e) {
      resolved = e.message.contains("Firebase service account");
    }
  });
  _check(resolved, "Service account was not resolved by default");
  _check(defaultAuth.isEmpty, "No secret should be put when resolution fails");

  // ignore: avoid_print
  print("no_secrets_apply_test: OK");
}

/// Exercises the public apply entrypoint with synthetic credentials only.
Future<void> _purchaseCliRegression() async {
  final cliRoot = File.fromUri(Platform.script).parent.parent.absolute;
  final root = Directory(".tmp")..createSync(recursive: true);
  final fixture = root.createTempSync("purchase-no-secrets-").absolute;
  try {
    for (final path in [
      "android/app/src/main",
      "ios/Runner.xcodeproj",
      "cloudflare/src",
      "bin"
    ]) {
      Directory("${fixture.path}/$path").createSync(recursive: true);
    }
    void write(String path, String data) =>
        File("${fixture.path}/$path").writeAsStringSync(data);
    write("pubspec.yaml", "name: fixture\ndependencies: {}\n");
    write("katana.yaml", """
purchase:
  enable: true
  google_play:
    enable: true
    pubsub_topic: fixture-topic
  app_store:
    enable: true
    shared_secret: \${KATANA_SYNTHETIC_PURCHASE_UNSET}
cloudflare:
  workers:
    enable: true
    enable_firebase_auth: true
bin:
  npm: ${fixture.path}/bin/npm
  wrangler: ${fixture.path}/bin/wrangler
""");
    // Invalid YAML proves the bootstrap never reads the secrets file.
    write("katana_secrets.yaml", "[invalid: YAML");
    // Invalid JSON proves no store credential file is parsed.
    write("android/synthetic.json", "INVALID SYNTHETIC CREDENTIAL");
    write("android/app/src/main/AndroidManifest.xml",
        '<manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools"><application /></manifest>');
    write("android/app/build.gradle", "android {\n compileSdkVersion 35\n}\n");
    write("android/build.gradle",
        "buildscript {\n ext.kotlin_version = '2.1.0'\n}\n");
    write("android/settings.gradle", "plugins {\n}\n");
    write("ios/Runner.xcodeproj/project.pbxproj", """
/* Begin PBXFileReference section */
AAAAAAAAAAAAAAAAAAAAAAAA /* StoreKit.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = StoreKit.framework; path = System/Library/Frameworks/StoreKit.framework; sourceTree = SDKROOT; };
/* End PBXFileReference section */
PRODUCT_BUNDLE_IDENTIFIER = net.example.fixture;
""");
    write("cloudflare/package.json", '{"dependencies": {}}');
    write("cloudflare/src/edge.ts",
        'import * as m from "@mathrunet/masamune_cloudflare";\nexport default m.deploy([], {});\n');
    for (final name in ["flutter", "npm", "wrangler"]) {
      write("bin/$name",
          '#!/bin/sh\nprintf \'%s %s\\n\' "$name" "\$*" >> "${fixture.path}/calls.log"\nexit 0\n');
      final chmod =
          await Process.run("chmod", ["+x", "${fixture.path}/bin/$name"]);
      _check(chmod.exitCode == 0, "Fixture executable could not be prepared");
    }
    Future<ProcessResult> run({required bool noSecrets}) => Process.run(
          Platform.resolvedExecutable,
          [
            "--packages=${cliRoot.path}/.dart_tool/package_config.json",
            "${cliRoot.path}/bin/katana.dart",
            "apply",
            "--only",
            "purchase",
            "--no-deploy",
            if (noSecrets) "--no-secrets"
          ],
          workingDirectory: fixture.path,
          environment: {
            "PATH": "${fixture.path}/bin:${Platform.environment["PATH"]}"
          },
        );
    final isolated = await run(noSecrets: true);
    _check(isolated.exitCode == 0,
        "Purchase no-secrets apply failed: ${isolated.stdout}\n${isolated.stderr}");
    final calls = File("${fixture.path}/calls.log").readAsStringSync();
    _check(
        calls.contains(
            "flutter pub add masamune_purchase_mobile masamune_functions_cloudflare"),
        "Purchase dependencies were not requested");
    _check(
        calls.contains("npm install @mathrunet/masamune_cloudflare_purchase"),
        "Purchase server dependency was not requested");
    _check(!calls.contains("wrangler"),
        "A Worker secret or deployment was attempted");
    final edge =
        File("${fixture.path}/cloudflare/src/edge.ts").readAsStringSync();
    for (final handler in [
      "consumableVerifyIOS",
      "nonconsumableVerifyIOS",
      "subscriptionVerifyIOS",
      "purchaseWebhookIOS",
      "consumableVerifyAndroid",
      "nonconsumableVerifyAndroid",
      "subscriptionVerifyAndroid",
      "purchaseWebhookAndroid"
    ]) {
      _check(edge.contains("purchase.Functions.$handler("),
          "Missing purchase handler: $handler");
    }
    // Firebase generation must not read or rewrite its legacy secret file.
    final workerYaml = File("${fixture.path}/katana.yaml").readAsStringSync();
    final firebaseYaml = workerYaml.replaceFirst(
        "workers:\n    enable: true", "workers:\n    enable: false");
    write("katana.yaml",
        "$firebaseYaml\nfirebase:\n  project_id: fixture\n  functions:\n    enable: true\n    region: asia-northeast1\n");
    Directory("${fixture.path}/firebase/functions/src")
        .createSync(recursive: true);
    write("firebase/functions/src/index.ts",
        'import * as mf from "@mathrunet/masamune_firebase";\nmf.deploy(exports, ["asia-northeast1"], []);\n');
    write("firebase/functions/.env", "SYNTHETIC_SENTINEL=unchanged\n");
    final firebase = await run(noSecrets: true);
    _check(firebase.exitCode == 0,
        "Firebase no-secrets apply failed: ${firebase.stdout} ${firebase.stderr}");
    _check(
        File("${fixture.path}/firebase/functions/.env").readAsStringSync() ==
            "SYNTHETIC_SENTINEL=unchanged\n",
        "Firebase secret file was rewritten");
    _check(
        File("${fixture.path}/firebase/functions/src/index.ts")
            .readAsStringSync()
            .contains("purchase.Functions.subscriptionVerifyIOS()"),
        "Firebase purchase source was not generated");
    write(
        "katana.yaml",
        workerYaml.replaceAll(
            r"    shared_secret: ${KATANA_SYNTHETIC_PURCHASE_UNSET}", ""));
    final callsBeforeValidation =
        File("${fixture.path}/calls.log").readAsStringSync();
    // Default mode still parses the store JSON and rejects missing iOS secrets.
    write("katana_secrets.yaml", "{}\n");
    final android = await run(noSecrets: false);
    _check(
        android.exitCode != 0 &&
            android.stderr
                .toString()
                .contains("Json for service account is broken"),
        "Default mode did not read the store credential JSON: ${android.stdout} ${android.stderr}");
    write("android/synthetic.json",
        '{"client_email":"fixture@example.invalid","private_key":"synthetic-only"}');
    final ios = await run(noSecrets: false);
    _check(ios.exitCode != 0 && ios.stderr.toString().contains("shared_secret"),
        "Default mode did not require the App Store shared secret");
    _check(
        File("${fixture.path}/calls.log").readAsStringSync() ==
            callsBeforeValidation,
        "Default validation unexpectedly ran external commands");
    write("katana.yaml", "{}\n");
    final empty = await run(noSecrets: true);
    _check(empty.exitCode != 0,
        "No-secrets apply accepted an empty configuration");
  } finally {
    fixture.deleteSync(recursive: true);
  }
}
