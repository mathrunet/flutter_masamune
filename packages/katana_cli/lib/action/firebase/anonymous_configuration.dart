// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Explicit, development-only Firebase anonymous authentication configuration.
///
/// Ordinary apply runs never enable this action. Credentials stay in memory.
class FirebaseAnonymousConfigurationCliAction extends CliCommand
    with CliActionMixin {
  /// Creates the explicit configuration action.
  const FirebaseAnonymousConfigurationCliAction();

  @override
  String get description =>
      "Inspect Firebase Auth config; explicitly initialize/enable anonymous auth in dev only.";

  @override
  bool checkEnabled(ExecContext context) =>
      context.args.contains("--auth-config");

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final project = firebase.get("project_id", "");
    final expected = _option(context.args, "--auth-project");
    final account = _option(context.args, "--auth-account");
    if (isLocalApply ||
        context.flavorContext?.explicit != true ||
        context.flavorContext?.flavor != KatanaFlavor.dev ||
        project.isEmpty ||
        project != expected ||
        !RegExp(r"^[a-z][a-z0-9-]{4,28}[a-z0-9]$").hasMatch(project) ||
        !firebase.getAsMap("authentication").get("enable", false) ||
        account == null ||
        account.isEmpty) {
      throw StateError(
          "Auth config requires explicit dev flavor, matching --auth-project, enabled authentication, and --auth-account; --local is unsupported.");
    }
    // Capture credential output without printing or persisting it.
    final credential = await Process.run("gcloud", [
      "auth",
      "print-access-token",
      "--account=$account",
    ]).timeout(const Duration(seconds: 30));
    if (credential.exitCode != 0 ||
        credential.stdout.toString().trim().isEmpty) {
      throw StateError("Could not obtain the selected account credential.");
    }
    final token = credential.stdout.toString().trim();
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 30);
    try {
      final result = await configureFirebaseAnonymousAuth(
        project: project,
        initialize: context.args.contains("--initialize-auth"),
        enableAnonymous: context.args.contains("--enable-anonymous"),
        request: (method, path, body) async {
          final uri = Uri.https(
              "identitytoolkit.googleapis.com",
              path,
              method == "PATCH"
                  ? {"updateMask": "signIn.anonymous.enabled"}
                  : null);
          final request = await client.openUrl(method, uri);
          request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
          request.headers.set("x-goog-user-project", project);
          if (body != null) {
            request.headers.contentType = ContentType.json;
            request.write(jsonEncode(body));
          }
          final response = await request.close();
          final text = await utf8.decoder.bind(response).join();
          final decoded =
              text.trim().isEmpty ? <String, dynamic>{} : jsonDecode(text);
          return AuthConfigResponse(response.statusCode,
              decoded is Map ? Map<String, dynamic>.from(decoded) : {});
        },
      ).timeout(const Duration(seconds: 90));
      stdout.writeln(jsonEncode(result));
    } finally {
      client.close(force: true);
    }
  }
}

String? _option(List<String> args, String name) {
  final index = args.indexOf(name);
  return index >= 0 && index + 1 < args.length ? args[index + 1] : null;
}

/// A management API response; raw error bodies are never logged.
class AuthConfigResponse {
  /// Creates a response.
  const AuthConfigResponse(this.status, this.body);

  /// HTTP status.
  final int status;

  /// Parsed response, kept only in memory.
  final Map<String, dynamic> body;
}

/// Requests only the selected project's management endpoint.
typedef AuthConfigRequest = Future<AuthConfigResponse> Function(
    String method, String path, Map<String, dynamic>? body);

/// Inspects configuration and applies only explicitly authorized missing state.
///
/// Only CONFIGURATION_NOT_FOUND allows initialization. No other provider is
/// included in the update mask, and a fresh GET must verify the resulting state.
Future<Map<String, dynamic>> configureFirebaseAnonymousAuth({
  required String project,
  required bool initialize,
  required bool enableAnonymous,
  required AuthConfigRequest request,
}) async {
  final path = "/admin/v2/projects/$project/config";
  var response = await request("GET", path, null);
  var initialized = false;
  var updated = false;
  if (response.status == 404 &&
      (response.body["error"] as Map?)?["message"] ==
          "CONFIGURATION_NOT_FOUND" &&
      initialize) {
    final created = await request(
        "POST", "/v2/projects/$project/identityPlatform:initializeAuth", null);
    _requireSuccess(created, "initialize");
    initialized = true;
    response = await request("GET", path, null);
  }
  _requireSuccess(response, "get");
  final before = response.body;
  if (_anonymousEnabled(before) != true && enableAnonymous) {
    final changed = await request("PATCH", path, {
      "name": "projects/$project/config",
      "signIn": {
        "anonymous": {"enabled": true}
      },
    });
    _requireSuccess(changed, "update");
    updated = true;
    response = await request("GET", path, null);
    _requireSuccess(response, "verify");
    if (_anonymousEnabled(response.body) != true) {
      throw StateError("Fresh Auth config does not confirm anonymous enabled.");
    }
    // Compare every other sign-in field, ignoring only the approved field.
    final oldSignIn = Map<String, dynamic>.from(before["signIn"] as Map? ?? {});
    final newSignIn =
        Map<String, dynamic>.from(response.body["signIn"] as Map? ?? {});
    for (final map in [oldSignIn, newSignIn]) {
      final anonymous =
          Map<String, dynamic>.from(map["anonymous"] as Map? ?? {});
      anonymous.remove("enabled");
      map.remove("anonymous");
      if (anonymous.isNotEmpty) {
        map["anonymous"] = anonymous;
      }
    }
    if (_canonical(oldSignIn) != _canonical(newSignIn)) {
      throw StateError(
          "Unrelated sign-in configuration changed during verification.");
    }
  }
  return {
    "project_id": project,
    "config_present": true,
    "anonymous_enabled": _anonymousEnabled(response.body),
    "initialized": initialized,
    "anonymous_updated": updated,
    "other_signin_fields_preserved": true,
    "verified_at": DateTime.now().toUtc().toIso8601String(),
  };
}

Object? _anonymousEnabled(Map<String, dynamic> body) =>
    (body["signIn"] as Map?)?["anonymous"] is Map
        ? ((body["signIn"] as Map)["anonymous"] as Map)["enabled"] ?? false
        : false;

String _canonical(Object? value) {
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return "{${keys.map((key) => '${jsonEncode(key)}:${_canonical(value[key])}').join(',')}}";
  }
  if (value is List) {
    return "[${value.map(_canonical).join(',')}]";
  }
  return jsonEncode(value);
}

void _requireSuccess(AuthConfigResponse response, String operation) {
  if (response.status < 200 || response.status >= 300) {
    final message = (response.body["error"] as Map?)?["message"];
    final reason = message is String &&
            message.length <= 300 &&
            !RegExp(r"Bearer|ya29|AIza|BEGIN .*KEY|refresh_token|access_token",
                    caseSensitive: false)
                .hasMatch(message)
        ? ": ${jsonEncode(message)}"
        : "";
    throw StateError(
        "Auth config $operation failed (HTTP ${response.status})$reason.");
  }
}
