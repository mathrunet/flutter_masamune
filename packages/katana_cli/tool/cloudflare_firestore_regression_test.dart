// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/firestore.dart";
import "package:katana_cli/action/firebase/init.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";

/// Firestoreのregion Workerアクセス（worker_access）とFirebase Storageルールの回帰テスト。
Future<void> main() async {
  _testTemplates();
  _testWarnings();
  _testStorageRules();
  await _testSecretsServiceAccountIsPutToRegionWorker();
  await _testFallbackServiceAccountAndDeclaredPackage();
  // `error()` keeps the global error flag, so error cases run last.
  await _testRegionWorkerRequired();
  await _testMismatchedServiceAccountIsRejected();
  stdout.writeln("All Cloudflare Firestore checks passed.");
}

const _serviceAccount =
    '{"type":"service_account","project_id":"firebase-test","client_email":"firestore@example.com","private_key":"firestore-key"}';

void _testTemplates() {
  final template = katanaYamlCode(true);
  _expect(
    template.contains(
      '  firestore:\n    enable: false\n    location_id: "nam5"\n    generate_rules_and_indexes: false\n    primary_remote_index: false\n    database:\n      - "(default)"\n    worker_access:\n      enable: false\n',
    ),
    "katana.yaml must contain [firebase]->[firestore]->[worker_access] disabled by default.",
  );
  final secrets = katanaSecretsYamlCode();
  final firebaseIndex = secrets.indexOf("\nfirebase:\n  firestore:\n");
  _expect(
    firebaseIndex >= 0 &&
        secrets.indexOf("    service_account:\n", firebaseIndex) > 0,
    "katana_secrets.yaml must contain [firebase]->[firestore]->[service_account].",
  );
  _expect(
    !const CloudflareFirestoreCliAction().checkEnabled(
      ExecContext(
        yaml: {
          "firebase": {
            "firestore": {"enable": true},
          },
        },
        args: const [],
      ),
    ),
    "worker_access must be disabled unless explicitly enabled.",
  );
}

void _testWarnings() {
  final disabled = cloudflareFirestoreWarnings({
    "firebase": {
      "firestore": {"enable": true},
    },
  });
  _expect(disabled.length == 2, "App Check and rules warnings are required.");
  _expect(
    disabled.any((e) => e.contains("[firebase]->[app_check]->[enable]")),
    "App Check warning is required.",
  );
  _expect(
    disabled.any(
      (e) =>
          e.contains("[firebase]->[firestore]->[generate_rules_and_indexes]"),
    ),
    "Rules generation warning is required.",
  );
  final enabled = cloudflareFirestoreWarnings({
    "firebase": {
      "firestore": {"enable": true, "generate_rules_and_indexes": true},
      "app_check": {"enable": true},
    },
  });
  _expect(enabled.isEmpty, "No warnings when App Check and rules are enabled.");
}

void _testStorageRules() {
  final rules = const FirebaseStorageRulesCliCode().body("", "", "");
  _expect(
    rules.contains("match /private/{userId}/{allPaths=**}") &&
        rules.contains("allow read, write: if isSpecifiedUser(userId);"),
    "Storage rules must restrict private files to the owner.",
  );
  _expect(
    rules.contains(
      "allow create, update: if isSpecifiedUser(userId) && isAssets(request.resource)",
    ),
    "Storage rules must restrict public uploads to the owner.",
  );
  _expect(
    rules
        .contains("match /{allPaths=**} {\n      allow read, write: if false;"),
    "Storage rules must deny other paths.",
  );
  _expect(
    firebaseDeployTargets(
      firestore: false,
      functions: false,
      storage: true,
      dataconnect: false,
      hosting: false,
      hostingGithubActions: false,
    ).contains("storage"),
    "Storage rules must be deployed when Storage is enabled.",
  );
}

Future<void> _testSecretsServiceAccountIsPutToRegionWorker() async {
  await _withFixture(
    run: (fixture) async {
      final context = fixture.context(secretsServiceAccount: _serviceAccount);
      const action = CloudflareFirestoreCliAction();
      _expect(action.checkEnabled(context), "The action must be enabled.");
      await action.exec(context);
      _expect(!isError, "The action must succeed.");
      _expectEqual(
        await fixture.secretOutput.readAsString(),
        "$_serviceAccount\n",
        "The service account in katana_secrets.yaml must be put.",
      );
      final wranglerLog = await fixture.wranglerLog.readAsString();
      _expect(
        wranglerLog.contains(
          "secret put GOOGLE_SERVICE_ACCOUNT --env prod -c wrangler.region.jsonc",
        ),
        "GOOGLE_SERVICE_ACCOUNT must be put to the region Worker: $wranglerLog",
      );
      _expect(
        (await fixture.npmLog.readAsString())
            .contains("install @mathrunet/masamune_cloudflare_firestore"),
        "The Firestore package must be added to cloudflare/package.json.",
      );
    },
  );
}

Future<void> _testFallbackServiceAccountAndDeclaredPackage() async {
  await _withFixture(
    declarePackage: true,
    run: (fixture) async {
      await File("cloudflare/firebase-admin.json")
          .writeAsString(_serviceAccount);
      await const CloudflareFirestoreCliAction().exec(fixture.context());
      _expect(!isError, "The action must succeed with file discovery.");
      _expectEqual(
        await fixture.secretOutput.readAsString(),
        "$_serviceAccount\n",
        "A service account JSON under cloudflare/ must be used as a fallback.",
      );
      _expect(
        !fixture.npmLog.existsSync(),
        "A declared Firestore package must not be reinstalled.",
      );
    },
  );
}

Future<void> _testRegionWorkerRequired() async {
  await _withFixture(
    run: (fixture) async {
      await const CloudflareFirestoreCliAction().exec(
        fixture.context(
          secretsServiceAccount: _serviceAccount,
          regionEnabled: false,
        ),
      );
      _expect(isError, "worker_access must fail without the region Worker.");
      _expect(
        !fixture.wranglerLog.existsSync() && !fixture.npmLog.existsSync(),
        "Nothing must be installed or put without the region Worker.",
      );
    },
  );
}

Future<void> _testMismatchedServiceAccountIsRejected() async {
  await _withFixture(
    run: (fixture) async {
      await const CloudflareFirestoreCliAction().exec(
        fixture.context(
          secretsServiceAccount: _serviceAccount.replaceFirst(
            "firebase-test",
            "other-project",
          ),
        ),
      );
      _expect(isError, "A service account of another project must fail.");
      _expect(
        !fixture.wranglerLog.existsSync(),
        "A mismatched service account must not be put.",
      );
    },
  );
}

Future<void> _withFixture({
  required Future<void> Function(_Fixture fixture) run,
  bool declarePackage = false,
}) async {
  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_firestore_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
    await File("cloudflare/src/region.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([]);
""");
    await File("cloudflare/wrangler.region.jsonc").writeAsString("{}\n");
    await File("cloudflare/package.json").writeAsString(
      jsonEncode({
        "dependencies": {
          "@mathrunet/masamune_cloudflare": "3.7.1",
          if (declarePackage) cloudflareFirestorePackage: "3.1.0",
        },
      }),
    );
    final npm = File("${temporary.path}/fake-npm.sh");
    final npmLog = File("${npm.path}.log");
    await npm.writeAsString("""
#!/bin/sh
echo "\$*" >> "${npmLog.path}"
""");
    final wrangler = File("${temporary.path}/fake-wrangler.sh");
    final secretOutput = File("${wrangler.path}.secret");
    final wranglerLog = File("${wrangler.path}.log");
    await wrangler.writeAsString("""
#!/bin/sh
echo "\$*" >> "${wranglerLog.path}"
if [ "\$1" = "secret" ] && [ "\$2" = "put" ] && [ "\$3" = "GOOGLE_SERVICE_ACCOUNT" ]; then
  cat > "${secretOutput.path}"
  exit 0
fi
exit 1
""");
    await Process.run("chmod", ["+x", npm.path, wrangler.path]);
    await run(
      _Fixture(
        npm: npm,
        wrangler: wrangler,
        npmLog: npmLog,
        secretOutput: secretOutput,
        wranglerLog: wranglerLog,
      ),
    );
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

class _Fixture {
  const _Fixture({
    required this.npm,
    required this.wrangler,
    required this.npmLog,
    required this.secretOutput,
    required this.wranglerLog,
  });

  final File npm;
  final File wrangler;
  final File npmLog;
  final File secretOutput;
  final File wranglerLog;

  ExecContext context({
    String secretsServiceAccount = "",
    bool regionEnabled = true,
  }) {
    return ExecContext(
      yaml: {
        "bin": {
          "npm": npm.path,
          "wrangler": wrangler.path,
        },
        "cloudflare": {
          "workers": {
            "enable": true,
            "region": {"enable": regionEnabled},
          },
        },
        "firebase": {
          "project_id": "firebase-test",
          "firestore": {
            "enable": true,
            "generate_rules_and_indexes": true,
            "worker_access": {"enable": true},
          },
          "app_check": {"enable": true},
        },
      },
      secrets: {
        "firebase": {
          "firestore": {"service_account": secretsServiceAccount},
        },
      },
      args: const [],
    );
  }
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual != expected) {
    throw StateError("$message\nExpected: $expected\nActual: $actual");
  }
}
