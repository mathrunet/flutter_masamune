// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/firebase/anonymous_configuration.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  var count = 0;
  Future<void> scenario(String name, Future<void> Function() run) async {
    await run();
    count++;
    stdout.writeln("PASS $name");
  }

  Map<String, dynamic> config(bool enabled) => {
        "signIn": {
          "anonymous": {"enabled": enabled},
          "email": {"enabled": true, "passwordRequired": true},
        },
      };
  const missing = AuthConfigResponse(404, {
    "error": {"message": "CONFIGURATION_NOT_FOUND"},
  });
  Future<void> exercise({
    required List<AuthConfigResponse> replies,
    required List<String> expected,
    bool initialize = false,
    bool enable = false,
    bool fail = false,
  }) async {
    final calls = <String>[];
    var thrown = false;
    try {
      await configureFirebaseAnonymousAuth(
        project: "fixture-dev",
        initialize: initialize,
        enableAnonymous: enable,
        request: (method, path, body) async {
          calls.add(method);
          _expect(path.contains("projects/fixture-dev/"), "Wrong target");
          if (method == "PATCH") {
            _expect(body!.keys.length == 2, "Unexpected patch fields");
            _expect(body["signIn"].toString() == "{anonymous: {enabled: true}}",
                "Other provider must not be patched");
          }
          return replies.removeAt(0);
        },
      );
    } on StateError {
      thrown = true;
    }
    _expect(thrown == fail, "Unexpected success/failure");
    _expect(
        calls.join(",") == expected.join(","), "Unexpected API calls: $calls");
  }

  await scenario(
      "enabled state is read-only",
      () => exercise(
          replies: [AuthConfigResponse(200, config(true))],
          expected: ["GET"],
          initialize: true,
          enable: true));
  await scenario(
      "inspect disabled does not update",
      () => exercise(
          replies: [AuthConfigResponse(200, config(false))],
          expected: ["GET"]));
  await scenario(
      "initialize then enable and verify",
      () => exercise(replies: [
            missing,
            const AuthConfigResponse(200, {}),
            AuthConfigResponse(200, config(false)),
            const AuthConfigResponse(200, {}),
            AuthConfigResponse(200, config(true))
          ], expected: [
            "GET",
            "POST",
            "GET",
            "PATCH",
            "GET"
          ], initialize: true, enable: true));
  await scenario(
      "missing without initialize is rejected",
      () => exercise(
          replies: [missing], expected: ["GET"], enable: true, fail: true));
  for (final status in [400, 401, 403, 500]) {
    await scenario(
        "HTTP $status never initializes",
        () => exercise(
            replies: [AuthConfigResponse(status, {})],
            expected: ["GET"],
            initialize: true,
            enable: true,
            fail: true));
  }
  await scenario(
      "unrelated 404 never initializes",
      () => exercise(
          replies: [const AuthConfigResponse(404, {})],
          expected: ["GET"],
          initialize: true,
          enable: true,
          fail: true));
  await scenario(
      "failed initialize stops",
      () => exercise(
          replies: [missing, const AuthConfigResponse(403, {})],
          expected: ["GET", "POST"],
          initialize: true,
          enable: true,
          fail: true));
  await scenario(
      "failed update stops",
      () => exercise(replies: [
            AuthConfigResponse(200, config(false)),
            const AuthConfigResponse(403, {})
          ], expected: [
            "GET",
            "PATCH"
          ], enable: true, fail: true));
  await scenario(
      "fresh verification required",
      () => exercise(replies: [
            AuthConfigResponse(200, config(false)),
            const AuthConfigResponse(200, {}),
            AuthConfigResponse(200, config(false))
          ], expected: [
            "GET",
            "PATCH",
            "GET"
          ], enable: true, fail: true));
  await scenario(
      "unrelated provider changes rejected",
      () => exercise(replies: [
            AuthConfigResponse(200, config(false)),
            const AuthConfigResponse(200, {}),
            const AuthConfigResponse(200, {
              "signIn": {
                "anonymous": {"enabled": true}
              }
            })
          ], expected: [
            "GET",
            "PATCH",
            "GET"
          ], enable: true, fail: true));
  await scenario("normal apply is unaffected", () async {
    _expect(
        !const FirebaseAnonymousConfigurationCliAction()
            .checkEnabled(ExecContext(yaml: const {}, args: const ["apply"])),
        "Implicit action enabled");
  });
  for (final args in [
    <String>["--flavor", "prod"],
    <String>[]
  ]) {
    await scenario("reject non-explicit dev before credentials", () async {
      final flavor = FlavorContext.resolve(yaml: const {
        "firebase": {
          "project_id": {"dev": "fixture-dev", "prod": "fixture-prod"},
          "authentication": {"enable": true}
        }
      }, secrets: const {}, arguments: args);
      var rejected = false;
      try {
        await const FirebaseAnonymousConfigurationCliAction().exec(ExecContext(
            yaml: flavor.yaml,
            args: [
              ...args,
              "--auth-config",
              "--auth-project",
              "fixture-dev",
              "--auth-account",
              "fixture@example.com"
            ],
            flavorContext: flavor));
      } on StateError {
        rejected = true;
      }
      _expect(rejected, "Unsafe flavor accepted");
    });
  }
  stdout.writeln("$count checks passed.");
}

void _expect(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}
