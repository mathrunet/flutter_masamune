// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Class for specifying Functions of Firebase Functions.
///
/// Firebase FunctionsのFunctionを指定するためのクラス。
class Functions {
  /// Class for specifying Functions of Firebase Functions.
  ///
  /// Firebase FunctionsのFunctionを指定するためのクラス。
  Functions();

  static final _functionRegExp = RegExp(
    r"mf.deploy\([\s\S]*?exports,[\s\S]*?\[(?<regions>[^\]]*?)\],[\s\S]*?\[(?<functions>[^\]]*?)\],?[\s\S]*\);",
  );

  static final _importRegexp = RegExp(
    "import\\s+([^;]*?)\\s+from\\s+\"(@mathrunet/[\\s\\S]*?)\"\\s*;",
  );

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// List of Functions.
  ///
  /// Functionの一覧。
  List<String> get functions => _functions;
  late List<String> _functions;

  /// List of Regions.
  ///
  /// Regionの一覧。
  List<String> get regions => _regions;
  late List<String> _regions;

  /// List of imports.
  ///
  /// importの一覧。
  List<String> get imports => _imports;
  late List<String> _imports;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    final index = File("firebase/functions/src/index.ts");
    _rawData = await index.readAsString();
    final imports = _importRegexp.allMatches(_rawData);
    _imports = imports
        .map((e) => e.group(0)?.trim() ?? "")
        .where((e) => e.isNotEmpty)
        .toList();
    final region = _functionRegExp.firstMatch(_rawData);
    if (region == null) {
      _regions = [];
      _functions = [];
      return;
    }
    _regions = region
            .namedGroup("regions")
            ?.split(",")
            .map((e) => e.trim().trimString('"').trimString("'"))
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
    _functions = region
            .namedGroup("functions")
            ?.split(",")
            .map((e) => e.trim().replaceAll(RegExp("^mf.Functions."), ""))
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    final imports = [
      ...this.imports,
      "import * as mf from \"@mathrunet/masamune_firebase\";",
    ].distinct();
    _rawData = _rawData.replaceAll(_importRegexp, "");
    for (final import in imports) {
      _rawData = "$import\n$_rawData";
    }
    _rawData = _rawData.replaceAll(_functionRegExp, """
mf.deploy(
  exports,
  [${regions.map((e) => '"$e"').join(", ")}],
  [
${functions.map((e) {
      return "    $e,";
    }).join("\n")}
  ],
);""");
    final gradle = File("firebase/functions/src/index.ts");
    await gradle.writeAsString(_rawData);
  }
}

/// Class for specifying environment variables of Firebase Functions.
///
/// Firebase Functionsの環境変数を指定するためのクラス。
class FunctionsEnv {
  /// Class for specifying environment variables of Firebase Functions.
  ///
  /// Firebase Functionsの環境変数を指定するためのクラス。
  FunctionsEnv({this.context});

  /// Execution context used to opt into file-free Secret Manager configuration.
  final ExecContext? context;

  final Map<String, String> _env = {};

  /// Get the environment variable.
  ///
  /// 環境変数を取得する。
  String operator [](String key) => _env[key] ?? "";

  /// Set the environment variable.
  ///
  /// 環境変数を設定する。
  void operator []=(String key, String value) => _env[key] = value;

  /// Get the environment variable.
  ///
  /// 環境変数を取得する。
  Future<void> load() async {
    _env.clear();
    if (context != null && FirebaseFunctionsSecrets.isEnabled(context!)) {
      FirebaseFunctionsSecrets.validateFiles();
      _env.addAll(FirebaseFunctionsSecrets._pending[context!] ?? {});
      return;
    }
    final env = File("firebase/functions/.env");
    if (!env.existsSync()) {
      await env.create(recursive: true);
    }
    final envContent = await env.readAsString();
    final envLines = envContent.split("\n");
    for (final line in envLines) {
      final index = line.trim().split("=");
      if (index.length < 2) {
        continue;
      }
      final key = index.first.trim();
      final value = index.sublist(1).join("=").trim();
      _env[key] = value;
    }
  }

  /// Save environment variables.
  ///
  /// 環境変数を保存する。
  Future<void> save() async {
    if (context != null && FirebaseFunctionsSecrets.isEnabled(context!)) {
      FirebaseFunctionsSecrets.validateFiles();
      FirebaseFunctionsSecrets._pending[context!] = Map.of(_env);
      await FirebaseFunctionsSecrets.synchronize(context!);
      return;
    }
    final env = File("firebase/functions/.env");
    if (!env.existsSync()) {
      await env.create(recursive: true);
    }
    final buffer = StringBuffer();
    for (final key in _env.keys) {
      buffer.writeln("$key=${_env[key]}");
    }
    await env.writeAsString(buffer.toString());
  }
}

/// Registers Functions settings without writing secret values to local files.
/// Only secret names are persisted in the generated v2 global options block.
class FirebaseFunctionsSecrets {
  FirebaseFunctionsSecrets._();

  static final _pending = Expando<Map<String, String>>();
  static final _block = RegExp(
    r"// BEGIN KATANA FIREBASE SECRETS[\s\S]*?// END KATANA FIREBASE SECRETS\n?",
  );
  static final _names = RegExp(r"// Secret names: (.*)");
  static const _indexPath = "firebase/functions/src/index.ts";

  /// Whether this project explicitly enables Secret Manager deployment.
  static bool isEnabled(ExecContext context) {
    final value = context.yaml
        .getAsMap("firebase")
        .getAsMap("functions")["secret_manager"];
    if (value != null && value is! bool) {
      throw const FormatException(
        "firebase.functions.secret_manager must be a boolean.",
      );
    }
    return value == true;
  }

  /// Refuses ambiguous deployment alongside legacy dotenv files, without reading them.
  static void validateFiles() {
    final directory = Directory("firebase/functions");
    if (!directory.existsSync()) {
      throw StateError(
          "Run katana apply to initialize Firebase Functions first.");
    }
    for (final entry in directory.listSync()) {
      final name = entry.uri.pathSegments.where((e) => e.isNotEmpty).last;
      if (name == ".env" || name.startsWith(".env.")) {
        throw StateError(
          "Secret Manager mode cannot use firebase/functions/$name. "
          "Migrate its settings to Samurai Passwords and remove the legacy "
          "dotenv file after confirming the migration. Katana will not read or delete it.",
        );
      }
    }
  }

  static Map<String, String> _values(ExecContext context) {
    final result = <String, String>{...?_pending[context]};
    final configured =
        context.yaml.getAsMap("firebase").getAsMap("functions")["secrets"];
    if (configured != null && configured is! Map) {
      throw const FormatException("firebase.functions.secrets must be a map.");
    }
    for (final entry in (configured as Map? ?? {}).entries) {
      if (entry.key is! String ||
          entry.value is! String ||
          (entry.value as String).isEmpty) {
        throw const FormatException(
          "firebase.functions.secrets must map secret names to non-empty strings. "
          "Use environment references such as \${API_KEY}.",
        );
      }
      result[entry.key as String] = entry.value as String;
    }
    for (final name in result.keys) {
      _validateName(name);
    }
    return result;
  }

  static void _validateName(String name) {
    if (!RegExp(r"^[A-Z_][A-Z0-9_]*$").hasMatch(name) ||
        name.startsWith("FIREBASE_") ||
        name.startsWith("X_GOOGLE_") ||
        name.startsWith("EXT_") ||
        const [
          "PORT",
          "K_SERVICE",
          "K_REVISION",
          "K_CONFIGURATION",
          "FUNCTION_TARGET",
          "FUNCTION_SIGNATURE_TYPE"
        ].contains(name)) {
      throw const FormatException("Invalid or reserved Firebase secret name.");
    }
  }

  /// Adds idempotent v2 secret bindings before any function definitions.
  /// Existing bindings are retained for standalone deploys and repeated apply.
  static Future<void> synchronize(ExecContext context) async {
    if (!isEnabled(context)) {
      return;
    }
    validateFiles();
    final values = _values(context);
    final index = File(_indexPath);
    final source = await index.readAsString();
    final existing = _block.firstMatch(source);
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final namesByFlavor = <String, List<String>>{};
    if (existing != null) {
      final encoded = _names.firstMatch(existing.group(0)!)?.group(1);
      if (encoded == null) {
        throw const FormatException("Malformed Katana Firebase secrets block.");
      }
      final decoded = jsonDecode(encoded);
      if (decoded is! Map) {
        throw const FormatException("Malformed Katana Firebase secret names.");
      }
      for (final entry in decoded.entries) {
        if (!const ["dev", "prod"].contains(entry.key) ||
            entry.value is! List ||
            (entry.value as List).any((name) => name is! String)) {
          throw const FormatException(
              "Malformed Katana Firebase secret names.");
        }
        namesByFlavor[entry.key as String] =
            (entry.value as List).cast<String>();
      }
    }
    final pluginNames = <String>{...?namesByFlavor[flavor]};
    pluginNames.addAll((_pending[context] ?? {})
        .entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => e.key));
    final names = <String>{...pluginNames};
    names.addAll(
        values.entries.where((e) => e.value.isNotEmpty).map((e) => e.key));
    for (final name in names) {
      _validateName(name);
    }
    if (names.isEmpty && existing == null) {
      return;
    }
    final rest = source.replaceAll(_block, "");
    if (RegExp(r"\bsetGlobalOptions\s*\(").hasMatch(rest)) {
      throw StateError(
        "Custom setGlobalOptions found in index.ts. Merge its options before "
        "enabling Katana-managed Firebase secrets to avoid overriding them.",
      );
    }
    final sortedNames = names.toList()..sort();
    namesByFlavor[flavor] = pluginNames.toList()..sort();
    final encoded = jsonEncode(sortedNames);
    final metadata = jsonEncode(namesByFlavor);
    final block = "// BEGIN KATANA FIREBASE SECRETS\n"
        "// Secret names: $metadata\n"
        'import {setGlobalOptions as katanaSecretOptions} from "firebase-functions/v2";\n'
        "katanaSecretOptions({secrets: $encoded});\n"
        "// END KATANA FIREBASE SECRETS\n";
    final updated = "$block$rest";
    if (updated != source) {
      await index.writeAsString(updated);
    }
  }

  static String _firebaseToolsDirectory(String executable) {
    // Follow npm executable symlinks, then locate their owning package.
    // Standalone Firebase binaries cannot provide the log-free Node API.
    final candidates = <String>[executable];
    // ignore: do_not_use_environment
    final paths = Platform.environment["PATH"] ?? "";
    if (!executable.contains("/") && !executable.contains("\\")) {
      candidates.addAll(paths
          .split(Platform.isWindows ? ";" : ":")
          .map((path) => "$path/$executable"));
    }
    for (final candidate in candidates) {
      final file = File(candidate);
      if (!file.existsSync()) {
        continue;
      }
      var directory = File(file.resolveSymbolicLinksSync()).parent;
      for (var depth = 0; depth < 5; depth++) {
        final manifest = File("${directory.path}/package.json");
        if (manifest.existsSync()) {
          final json = jsonDecode(manifest.readAsStringSync());
          if (json is Map && json["name"] == "firebase-tools") {
            return directory.absolute.path;
          }
        }
        if (directory.parent.path == directory.path) {
          break;
        }
        directory = directory.parent;
      }
    }
    throw StateError(
        "Secret Manager mode requires an npm-installed firebase-tools "
        "with its Node API. Set bin.firebase to that installation's executable.");
  }

  // Use the supported Node API instead of the CLI entrypoint: the latter logs
  // request bodies (including base64 secret payloads) to firebase-debug.log.
  static const _registerScript = r"""
const tools = require(process.argv[1]);
Promise.resolve().then(() => tools.functions.secrets.set(process.argv[2], {
  project: process.argv[3],
  dataFile: "-",
  format: "string",
  nonInteractive: true,
})).then(() => process.exit(0), () => process.exit(1));
""";

  /// Uploads values over stdin before the consolidated Functions deployment.
  /// Subprocess output is consumed but never printed, including on failures.
  static Future<void> prepareDeployment(ExecContext context) async {
    if (!isEnabled(context)) {
      return;
    }
    if (isLocalApply) {
      throw StateError(
          "Secret Manager registration is unavailable with --local.");
    }
    final projectId = context.yaml.getAsMap("firebase").get("project_id", "");
    if (projectId.isEmpty) {
      throw StateError(
          "firebase.project_id is required for secret registration.");
    }
    await synchronize(context);
    final bin = context.yaml.getAsMap("bin");
    final firebase = bin.get("firebase", "firebase");
    final node = bin.get("node", "node");
    final values = _values(context);
    if (values.values.every((value) => value.isEmpty)) {
      return;
    }
    final tools = _firebaseToolsDirectory(firebase);
    for (final entry in values.entries) {
      if (entry.value.isEmpty) {
        continue;
      }
      final process = await Process.start(
        node,
        ["-e", _registerScript, tools, entry.key, projectId],
        workingDirectory: "firebase",
        runInShell: false,
      );
      final out = process.stdout.drain<void>();
      final err = process.stderr.drain<void>();
      try {
        process.stdin.add(utf8.encode(entry.value));
        await process.stdin.close();
        final code = await process.exitCode;
        await Future.wait([out, err]);
        if (code != 0) {
          throw StateError(
              "Firebase secret registration failed for ${entry.key} "
              "in $projectId (exit $code). Check Firebase authentication and "
              "Secret Manager permissions. Deployment was stopped.");
        }
      } on Object {
        process.kill();
        rethrow;
      }
    }
  }
}
