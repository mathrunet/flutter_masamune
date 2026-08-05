// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/authentication.dart";
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
      "    delete_user:\n      enable: false\n      service_account:",
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
  stdout.writeln("All Cloudflare Authentication checks passed.");
}

Future<void> _testSecretsValueTakesPriorityAndApplyIsIdempotent() async {
  const yamlServiceAccount =
      '{"type":"service_account","client_email":"yaml@example.com","private_key":"yaml-key"}';
  const secretsServiceAccount =
      '{"type":"service_account","client_email":"secret@example.com","private_key":"secret-key"}';
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

      final index = await File("cloudflare/src/index.ts").readAsString();
      _expectCount(
        index,
        'import * as auth from "@mathrunet/masamune_cloudflare_auth";',
        1,
      );
      _expectCount(index, "auth.Functions.deleteUser(", 1);
      _expect(
        index.contains(
          'auth.Functions.deleteUser({ projectId: "firebase-test" })',
        ),
        "The configured Firebase project ID must be passed to the Worker.",
      );
      _expectEqual(
        await fixture.secretOutput.readAsString(),
        "$secretsServiceAccount\n",
        "katana_secrets.yaml must take precedence over katana.yaml.",
      );
      final npmLog = await fixture.npmLog.readAsLines();
      _expect(
        npmLog.every(
          (line) => line == "install @mathrunet/masamune_cloudflare_auth",
        ),
        "The Cloudflare Auth npm package must be installed.",
      );
    },
  );
}

Future<void> _testServiceAccountFileDiscovery() async {
  const discoveredServiceAccount =
      '{"type":"service_account","client_email":"file@example.com","private_key":"file-key"}';
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
    await File("cloudflare/src/index.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([
]);
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
    await wrangler.writeAsString("""
#!/bin/sh
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
  });

  final File npm;
  final File wrangler;
  final File npmLog;
  final File secretOutput;

  ExecContext context({
    String yamlServiceAccount = "",
    String secretsServiceAccount = "",
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
          "project_id": "firebase-test",
          "authentication": {"enable": true},
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
