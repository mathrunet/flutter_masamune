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
