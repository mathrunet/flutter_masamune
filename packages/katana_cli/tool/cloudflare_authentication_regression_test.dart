// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/authentication.dart";
import "package:katana_cli/action/cloudflare/deploy.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  final template = katanaYamlCode(true);
  _expectCount(template, "  authentication:\n", 2);
  _expect(
    template.contains(
      "cloudflare:\n  # Set the Cloudflare project ID.",
    ),
    "The Cloudflare configuration must remain present.",
  );
  _expect(
    template.contains(
      "    delete_user:\n      enable: false\n",
    ),
    "The Cloudflare delete-user configuration must be generated.",
  );
  _expect(
    katanaSecretsYamlCode().contains(
      "cloudflare:\n  authentication:\n    delete_user:",
    ),
    "The service account must be available in katana_secrets.yaml.",
  );
  _expect(
    !const CloudflareAuthenticationCliAction().checkEnabled(
      ExecContext(
        yaml: {
          "firebase": {
            "authentication": {
              "delete_user": {"enable": true},
            },
          },
        },
        args: const [],
      ),
    ),
    "The Firebase Functions delete-user setting must not enable the Cloudflare action.",
  );

  await _testSecretsValueTakesPriorityAndApplyIsIdempotent();
  await _testServiceAccountFileDiscovery();
  await _testSelectsMatchingProjectAndPreservesCustomWorker();
  await _testRejectedAccountsDoNotWrite();
  await _testDeployRejectsStaticProjectMismatch();
  await _testDeployChecksWranglerFlavorAndPreservesRuntimeSource();
  await _testFlavorMappedServiceAccounts();
  stdout.writeln("All Cloudflare Authentication checks passed.");
}

Future<void> _testSecretsValueTakesPriorityAndApplyIsIdempotent() async {
  const yamlServiceAccount =
      '{"type":"service_account","project_id":"firebase-test","client_email":"yaml@example.com","private_key":"yaml-key"}';
  const secretsServiceAccount =
      '{"type":"service_account","project_id":"firebase-test","client_email":"secret@example.com","private_key":"secret-key"}';
  await _withFixture(
    serviceAccountFile: null,
    run: (fixture) async {
      final context = fixture.context(
        yamlServiceAccount: yamlServiceAccount,
        secretsServiceAccount: secretsServiceAccount,
      );
      const action = CloudflareAuthenticationCliAction();
      _expect(action.checkEnabled(context), "The action must be enabled.");
      await action.exec(context);
      await action.exec(context);

      final index = await File("cloudflare/src/edge.ts").readAsString();
      _expectCount(
        index,
        'import * as auth from "@mathrunet/masamune_cloudflare_auth";',
        1,
      );
      _expectCount(index, "auth.Functions.deleteUser(", 1);
      _expect(
        index.contains("auth.Functions.deleteUser()"),
        "Delete-user must use the selected flavor's service account project.",
      );
      _expect(
        index.contains(
          'new m.FirebaseAuthAdapter({ projectId: "firebase-test" })',
        ),
        "The shared Worker source must use the selected flavor's Firebase project.",
      );
      _expectEqual(
        await fixture.secretOutput.readAsString(),
        "$secretsServiceAccount\n",
        "katana_secrets.yaml must take precedence over katana.yaml.",
      );
      _expect(
        !fixture.npmLog.existsSync(),
        "A declared Cloudflare Auth package must not be reinstalled.",
      );
      _expect(
        (await File("cloudflare/package.json").readAsString()).contains(
          '"@mathrunet/masamune_cloudflare_auth": "3.1.0"',
        ),
        "Applying twice must preserve an exact npm dependency version.",
      );
    },
  );
}

Future<void> _testServiceAccountFileDiscovery() async {
  const discoveredServiceAccount =
      '{"type":"service_account","project_id":"firebase-test","client_email":"file@example.com","private_key":"file-key"}';
  await _withFixture(
    serviceAccountFile: discoveredServiceAccount,
    run: (fixture) async {
      await const CloudflareAuthenticationCliAction().exec(
        fixture.context(),
      );
      _expectEqual(
        await fixture.secretOutput.readAsString(),
        "$discoveredServiceAccount\n",
        "A service account JSON under cloudflare/ must be discovered.",
      );
    },
  );
}

Future<void> _testSelectsMatchingProjectAndPreservesCustomWorker() async {
  const selected =
      '{"type":"service_account","project_id":"firebase-test","client_email":"dev@example.com","private_key":"dev-key"}';
  const other =
      '{"type":"service_account","project_id":"other-project","client_email":"prod@example.com","private_key":"prod-key"}';
  await _withFixture(
    serviceAccountFile: other,
    run: (fixture) async {
      await File("cloudflare/selected.json").writeAsString(selected);
      const custom = '''
import * as m from "@mathrunet/masamune_cloudflare";
import * as auth from "@mathrunet/masamune_cloudflare_auth";

class EnvironmentFirebaseAuthAdapter {
  build(context) {
    return new m.FirebaseAuthAdapter({ projectId: resolveFirebaseProjectId(context.env) });
  }
}

function isAllowedRequest(flavor, method, url) {
  return flavor === "prod" && url.hostname === "tabelia.net" && method === "GET";
}
const tabeliaWeb = new TabeliaWebWorker();
export default m.deploy([
  tabeliaWeb,
  auth.Functions.deleteUser(),
], { auth: new EnvironmentFirebaseAuthAdapter() });
''';
      await File("cloudflare/src/edge.ts").writeAsString(custom);
      for (final (projectId, expected) in [
        ("firebase-test", selected),
        ("other-project", other),
        ("firebase-test", selected),
      ]) {
        await const CloudflareAuthenticationCliAction()
            .exec(fixture.context(firebaseProjectId: projectId));
        _expectEqual(await fixture.secretOutput.readAsString(), "$expected\n",
            "The account must match the selected Firebase project.");
        _expectEqual(
            await File("cloudflare/src/edge.ts").readAsString(),
            custom,
            "Repeated apply must preserve TABELIA's Worker entrypoint.");
      }
    },
  );
}

Future<void> _testRejectedAccountsDoNotWrite() async {
  const first =
      '{"type":"service_account","project_id":"firebase-test","client_email":"first@example.com","private_key":"first-key"}';
  const second =
      '{"type":"service_account","project_id":"firebase-test","client_email":"second@example.com","private_key":"second-key"}';
  await _withFixture(
    serviceAccountFile: first,
    run: (fixture) async {
      await File("cloudflare/second.json").writeAsString(second);
      final source = await File("cloudflare/src/edge.ts").readAsString();
      await _expectFails(
        () => const CloudflareAuthenticationCliAction().exec(fixture.context()),
        "Multiple Firebase service accounts",
      );
      await File("cloudflare/second.json").delete();
      await _expectFails(
        () => const CloudflareAuthenticationCliAction().exec(
          fixture.context(firebaseProjectId: "unknown-project"),
        ),
        "No Firebase service account matches",
      );
      await _expectFails(
        () => const CloudflareAuthenticationCliAction().exec(
          fixture.context(
              yamlServiceAccount: second, messagingServiceAccount: first),
        ),
        "different Firebase service accounts",
      );
      _expect(!fixture.secretOutput.existsSync(),
          "Rejected accounts must not be uploaded.");
      _expectEqual(await File("cloudflare/src/edge.ts").readAsString(), source,
          "Rejected accounts must not alter Worker source.");
    },
  );
}

Future<void> _testDeployRejectsStaticProjectMismatch() async {
  await _withFixture(
    serviceAccountFile: null,
    run: (fixture) async {
      final source = await File("cloudflare/src/edge.ts").readAsString();
      await _expectFails(
        () => const CloudflareDeployCliAction().exec(
          fixture.context(firebaseProjectId: "other-project"),
        ),
        "different Firebase project",
      );
      _expectEqual(await File("cloudflare/src/edge.ts").readAsString(), source,
          "Deploy must not alter Worker source.");
      _expect(!fixture.secretOutput.existsSync(),
          "Deploy must not upload Worker secrets.");
    },
  );
}

Future<void> _testDeployChecksWranglerFlavorAndPreservesRuntimeSource() async {
  await _withFixture(
    serviceAccountFile: null,
    run: (fixture) async {
      const source = '''
import * as m from "@mathrunet/masamune_cloudflare";
class EnvironmentFirebaseAuthAdapter {
  build(context) {
    return new m.FirebaseAuthAdapter({ projectId: resolveFirebaseProjectId(context.env) });
  }
}
export default m.deploy([], { auth: new EnvironmentFirebaseAuthAdapter() });
''';
      await File("cloudflare/src/edge.ts").writeAsString(source);
      final wrangler = File("cloudflare/wrangler.jsonc");
      await wrangler.writeAsString(_wranglerFixture("dev", "other-project"));
      await _expectFails(
        () => const CloudflareDeployCliAction().exec(
          fixture.context(firebaseProjectId: "other-project"),
        ),
        "FLAVOR/FIREBASE_PROJECT_ID",
      );
      _expect(!fixture.wranglerLog.existsSync(),
          "A mismatched FLAVOR must stop before invoking Wrangler.");
      await wrangler.writeAsString(_wranglerFixture("prod", "wrong-project"));
      await _expectFails(
        () => const CloudflareDeployCliAction().exec(
          fixture.context(firebaseProjectId: "other-project"),
        ),
        "FLAVOR/FIREBASE_PROJECT_ID",
      );
      _expect(!fixture.wranglerLog.existsSync(),
          "A mismatched project must stop before invoking Wrangler.");
      await wrangler.writeAsString(_wranglerFixture("prod", "other-project"));
      await const CloudflareDeployCliAction().exec(
        fixture.context(firebaseProjectId: "other-project"),
      );
      final calls = await fixture.wranglerLog.readAsLines();
      _expect(calls.any((call) => call.startsWith("deployments list")),
          "Deploy must check the existing Worker.");
      _expect(calls.any((call) => call.startsWith("deploy --env prod")),
          "A matching runtime source must be deployable.");
      _expect(!calls.any((call) => call.startsWith("secret put")),
          "Deploy must never write a Worker secret.");
      _expectEqual(await File("cloudflare/src/edge.ts").readAsString(), source,
          "Deploy must preserve runtime Worker source.");
    },
  );
}

String _wranglerFixture(String flavor, String projectId) => '''
{
  "name": "fixture",
  // KATANA ENVIRONMENTS BEGIN
  "env": {
    "prod": {
      "name": "fixture",
      "vars": { "FLAVOR": "$flavor", "FIREBASE_PROJECT_ID": "$projectId" }
    }
  },
  // KATANA ENVIRONMENTS END
}
''';

Future<void> _testFlavorMappedServiceAccounts() async {
  const dev =
      '{"type":"service_account","project_id":"firebase-dev","client_email":"dev@example.com","private_key":"dev-key"}';
  const prod =
      '{"type":"service_account","project_id":"firebase-prod","client_email":"prod@example.com","private_key":"prod-key"}';
  final yaml = {
    "firebase": {
      "project_id": {"dev": "firebase-dev", "prod": "firebase-prod"},
      "messaging": {
        "service_account": {"dev": dev, "prod": prod},
      },
    },
  };
  final secrets = {
    "cloudflare": {
      "authentication": {
        "delete_user": {
          "service_account": {"dev": dev, "prod": prod},
        },
      },
    },
  };
  for (final (flavor, projectId, expected) in [
    ("dev", "firebase-dev", dev),
    ("prod", "firebase-prod", prod),
  ]) {
    final resolved = FlavorContext.resolve(
      yaml: yaml,
      secrets: secrets,
      arguments: ["apply", "--flavor", flavor],
    );
    final selected = await resolveCloudflareFirebaseServiceAccount(
      ExecContext(
        yaml: resolved.yaml,
        secrets: resolved.secrets,
        args: ["apply", "--flavor", flavor],
        flavorContext: resolved,
      ),
      projectId: projectId,
    );
    _expectEqual(selected, expected,
        "The $flavor service account map must resolve to its own project.");
  }
  await _expectFails(
    () => resolveCloudflareFirebaseServiceAccount(
      ExecContext(
        yaml: {
          "cloudflare": {
            "authentication": {
              "delete_user": {"service_account": 123},
            },
          },
        },
        args: const ["apply"],
      ),
      projectId: "firebase-dev",
    ).then((_) {}),
    "must be a JSON string",
  );
}

Future<void> _withFixture({
  required String? serviceAccountFile,
  required Future<void> Function(_Fixture fixture) run,
}) async {
  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_authentication_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
    await File("cloudflare/src/edge.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([], {
  auth: new m.FirebaseAuthAdapter({ projectId: "firebase-test" }),
});
""");
    await File("cloudflare/package.json").writeAsString("""
{
  "dependencies": {
    "@mathrunet/masamune_cloudflare_auth": "3.1.0"
  }
}
""");
    if (serviceAccountFile != null) {
      await File("cloudflare/firebase-admin.json")
          .writeAsString(serviceAccountFile);
    }
    await File("pubspec.yaml").writeAsString("""
name: test_app
dependencies:
  masamune_auth_firebase: any
  masamune_functions_cloudflare: any
""");
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
if [ "\$1" = "deployments" ] || [ "\$1" = "deploy" ]; then
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
    String yamlServiceAccount = "",
    String secretsServiceAccount = "",
    String messagingServiceAccount = "",
    String firebaseProjectId = "firebase-test",
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
            "enable_firebase_auth": true,
          },
          "authentication": {
            "delete_user": {
              "enable": true,
              "service_account": yamlServiceAccount,
            },
          },
        },
        "firebase": {
          "project_id": firebaseProjectId,
          "authentication": {"enable": true},
          "messaging": {"service_account": messagingServiceAccount},
        },
      },
      secrets: {
        "cloudflare": {
          "authentication": {
            "delete_user": {
              "service_account": secretsServiceAccount,
            },
          },
        },
      },
      args: const [],
    );
  }
}

void _expect(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

void _expectCount(String source, String pattern, int expected) {
  final actual = RegExp(RegExp.escape(pattern)).allMatches(source).length;
  if (actual != expected) {
    throw StateError(
      "Expected $expected occurrences of `$pattern`, found $actual.",
    );
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual != expected) {
    throw StateError("$message Expected $expected, got $actual.");
  }
}

Future<void> _expectFails(
    Future<void> Function() action, String expected) async {
  try {
    await action();
  } on StateError catch (error) {
    _expect(error.message.toString().contains(expected),
        "Expected failure containing `$expected`, got `${error.message}`.");
    return;
  }
  throw StateError("Expected a failure containing `$expected`.");
}
