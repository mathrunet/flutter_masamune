// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/src/debuggable.dart";

Future<void> main() async {
  _expect(
    const CodeCliCommand().commands.containsKey("debuggable"),
    "debuggable command is registered",
  );
  await _generatesComposeEnvironment();
  await _configuresAStandardProjectIdempotently();
  await _preservesAnExplicitAdapterList();
  await _rejectsInlineDebuggerInstances();
  await _rejectsUnsupportedProjectsBeforeWriting();
  stdout.writeln("All debuggable command regression checks passed.");
}

Future<void> _generatesComposeEnvironment() async {
  const apiKey = r"  fixture-key=abc$123#suffix  ";
  const accounts = r"admin@example.com:p=a:ss,user@example.com:${1:pw}";
  const key = "MASAMUNE_AI_DEBUGGER_API_KEY";
  const accountsKey = "MASAMUNE_AI_DEBUGGER_ACCOUNTS";
  final previous = Directory.current;
  final root = await Directory.systemTemp.createTemp("katana_compose_env_");
  try {
    Directory.current = root;
    for (final environment in <Map<String, String>>[
      {},
      {key: apiKey},
      {accountsKey: accounts},
      {key: "", accountsKey: ""},
      {key: apiKey, accountsKey: accounts, "UNRELATED_SECRET": "unused"},
      {key: apiKey, accountsKey: accounts, "SAMURAI_AI_EXECUTION": "0"},
      {key: apiKey, accountsKey: accounts, "SAMURAI_AI_EXECUTION": "1"},
    ]) {
      for (final flavor in flavors) {
        final code = DartDefinesCliCode.fromEnvironment(
          flavor: flavor,
          environment: environment,
        );
        await code.generateFile("$flavor.env");
        final content = await File("dart_defines/$flavor.env").readAsString();
        final expected = "FLAVOR=$flavor\n"
            '${environment.containsKey(key) ? "$key=${environment[key]}\n" : ""}'
            '${environment.containsKey(accountsKey) ? "$accountsKey=${environment[accountsKey]}\n" : ""}';
        _expect(content == expected, "$flavor の環境変数がそのまま生成されます");
      }
    }
    for (final name in [key, accountsKey]) {
      for (final newline in ["\n", "\r", "\r\n"]) {
        var rejected = false;
        try {
          DartDefinesCliCode.fromEnvironment(
            flavor: "dev",
            environment: {name: "secret${newline}injected=value"},
          );
        } on FormatException catch (exception) {
          rejected = true;
          _expect(exception.toString().contains(name), "エラーに対象キーを含めます");
          _expect(!exception.toString().contains("secret"), "秘密値を表示しません");
          _expect(exception.source == null, "例外のsourceにも秘密値を含めません");
        } catch (_) {
          rethrow;
        }
        _expect(rejected, "改行を含む値を拒否します");
      }
    }
    _expect(
      const DartDefinesCliCode(flavor: "dev").body("", "", "") ==
          "FLAVOR=dev\n",
      "createで使う通常テンプレートは変更しません",
    );

    // compose生成後にdebuggableを適用しても、取り込んだ値を保持します。
    await Directory("lib").create();
    await File("pubspec.yaml").writeAsString("name: fixture\n");
    await File("lib/main.dart").writeAsString(_mainFixture);
    await File("lib/adapter.dart").writeAsString(_adapterFixture);
    final synchronizer = DebuggableProjectSynchronizer(root);
    await synchronizer.apply(await synchronizer.createPlan());
    for (final flavor in flavors) {
      final content = await File("dart_defines/$flavor.env").readAsString();
      _expect(content.contains("$key=$apiKey\n"), "取り込んだAPIキーを保持します");
      _expect(content.contains("$accountsKey=$accounts\n"), "アカウント一覧を保持します");
    }
  } finally {
    Directory.current = previous;
    await root.delete(recursive: true);
  }
}

Future<void> _preservesAnExplicitAdapterList() async {
  final root = await Directory.systemTemp.createTemp("katana_debuggable_list_");
  try {
    await Directory("${root.path}/lib").create(recursive: true);
    await File("${root.path}/pubspec.yaml").writeAsString("name: fixture\n");
    await File("${root.path}/lib/main.dart").writeAsString(_mainFixture);
    final adapterFile = File("${root.path}/lib/adapter.dart");
    await adapterFile.writeAsString("""
import "package:masamune/masamune.dart";

final List<MasamuneAdapter> masamuneAdapters = [
  const UniversalMasamuneAdapter(),
];
""");

    final synchronizer = DebuggableProjectSynchronizer(root);
    await synchronizer.apply(await synchronizer.createPlan());
    final content = await adapterFile.readAsString();

    _expectCount(
      content,
      "const UniversalMasamuneAdapter(),",
      1,
      "explicit existing adapter is preserved",
    );
    _expectCount(
      content,
      "aiDebuggerMasamuneAdapter,",
      1,
      "debugger is added to an explicit list",
    );
  } finally {
    await root.delete(recursive: true);
  }
}

Future<void> _rejectsInlineDebuggerInstances() async {
  final root =
      await Directory.systemTemp.createTemp("katana_debuggable_inline_");
  try {
    await Directory("${root.path}/lib").create(recursive: true);
    await File("${root.path}/pubspec.yaml").writeAsString("name: fixture\n");
    await File("${root.path}/lib/main.dart").writeAsString(_mainFixture);
    final adapterFile = File("${root.path}/lib/adapter.dart");
    await adapterFile.writeAsString("""
import "package:masamune/masamune.dart";

final masamuneAdapters = <MasamuneAdapter>[
  AIDebuggerMasamuneAdapter(),
];
""");
    final before = await adapterFile.readAsString();

    try {
      await DebuggableProjectSynchronizer(root).createPlan();
      throw StateError("inline debugger instance was accepted");
    } on StateError catch (exception) {
      _expect(
        exception.message.toString().contains("top-level final"),
        "inline debugger reports a clear error",
      );
    }
    _expectEqual(
      await adapterFile.readAsString(),
      before,
      "rejected inline debugger does not update adapter.dart",
    );
  } finally {
    await root.delete(recursive: true);
  }
}

Future<void> _configuresAStandardProjectIdempotently() async {
  final root = await Directory.systemTemp.createTemp("katana_debuggable_");
  try {
    await Directory("${root.path}/lib").create(recursive: true);
    await Directory("${root.path}/dart_defines").create(recursive: true);
    await File("${root.path}/pubspec.yaml").writeAsString("""
name: fixture
dependencies:
  masamune: any
  masamune_ai_debugger: any
""");
    await File("${root.path}/lib/main.dart").writeAsString(_mainFixture);
    final adapterFile = File("${root.path}/lib/adapter.dart");
    await adapterFile.writeAsString(_adapterFixture);
    await File("${root.path}/dart_defines/dev.env").writeAsString("""
flavor=dev
MASAMUNE_AI_DEBUGGER_PROJECT_ID=existing-project
MASAMUNE_AI_DEBUGGER_ENDPOINT=https://existing.example.test
MASAMUNE_AI_DEBUGGER_API_KEY=secret-value
MASAMUNE_AI_DEBUGGER_ACCOUNTS=admin@example.com:pw
""");

    final synchronizer = DebuggableProjectSynchronizer(root);
    await synchronizer.apply(await synchronizer.createPlan());
    final firstAdapter = await adapterFile.readAsString();
    final firstEnvironments = await _environmentContents(root);
    await synchronizer.apply(await synchronizer.createPlan());
    final secondAdapter = await adapterFile.readAsString();
    final secondEnvironments = await _environmentContents(root);

    _expectEqual(secondAdapter, firstAdapter, "adapter update is idempotent");
    _expectEqual(
      secondEnvironments.toString(),
      firstEnvironments.toString(),
      "environment updates are idempotent",
    );
    _expectCount(
      firstAdapter,
      'import "package:masamune_ai_debugger/masamune_ai_debugger.dart";',
      1,
      "debugger import is unique",
    );
    _expectCount(
      firstAdapter,
      "AIDebuggerMasamuneAdapter()",
      1,
      "debugger instance is unique",
    );
    _expectCount(
      firstAdapter,
      "aiDebuggerMasamuneAdapter,",
      1,
      "debugger list entry is unique",
    );
    _expect(
      firstAdapter.contains("...runtimeMasamuneAdapters,"),
      "existing runtime adapters are preserved",
    );
    _expect(
      firstAdapter.contains("const UniversalMasamuneAdapter()"),
      "existing adapter declarations are preserved",
    );

    final dev = firstEnvironments["dev"]!;
    _expect(
      dev.contains("MASAMUNE_AI_DEBUGGER_PROJECT_ID=existing-project"),
      "existing project ID is preserved",
    );
    _expect(
      dev.contains(
        "MASAMUNE_AI_DEBUGGER_ENDPOINT=https://existing.example.test",
      ),
      "existing endpoint is preserved",
    );
    _expect(
      dev.contains("MASAMUNE_AI_DEBUGGER_API_KEY=secret-value"),
      "existing API key is preserved",
    );
    _expect(
      dev.contains("MASAMUNE_AI_DEBUGGER_ACCOUNTS=admin@example.com:pw"),
      "existing accounts value is preserved",
    );
    for (final flavor in const ["test", "stg", "prod"]) {
      final content = firstEnvironments[flavor]!;
      final physicalPath = root.resolveSymbolicLinksSync();
      final expectedProjectId =
          physicalPath.replaceFirst(RegExp(r"^/+"), "").replaceAll("/", "-");
      _expect(
        content.contains(
          "MASAMUNE_AI_DEBUGGER_PROJECT_ID=$expectedProjectId",
        ),
        "$flavor project ID is derived from the physical path",
      );
      _expect(
        content.contains(
          "MASAMUNE_AI_DEBUGGER_ENDPOINT="
          "${DebuggableProjectSynchronizer.defaultEndpoint}",
        ),
        "$flavor endpoint is added",
      );
      _expect(
        content.contains("MASAMUNE_AI_DEBUGGER_API_KEY=\n"),
        "$flavor API key placeholder is added",
      );
      _expect(
        content.contains("MASAMUNE_AI_DEBUGGER_ACCOUNTS=\n"),
        "$flavor accounts placeholder is added",
      );
    }
  } finally {
    await root.delete(recursive: true);
  }
}

Future<void> _rejectsUnsupportedProjectsBeforeWriting() async {
  final root = await Directory.systemTemp.createTemp("katana_debuggable_bad_");
  try {
    await Directory("${root.path}/lib").create(recursive: true);
    await File("${root.path}/pubspec.yaml").writeAsString("name: fixture\n");
    await File("${root.path}/lib/main.dart").writeAsString("void main() {}\n");
    final adapterFile = File("${root.path}/lib/adapter.dart");
    await adapterFile.writeAsString(_adapterFixture);
    final before = await adapterFile.readAsString();

    try {
      await DebuggableProjectSynchronizer(root).createPlan();
      throw StateError("unsupported main.dart was accepted");
    } on StateError catch (exception) {
      _expect(
        exception.message.toString().contains("standard Masamune"),
        "unsupported structure reports a clear error",
      );
    }
    _expectEqual(
      await adapterFile.readAsString(),
      before,
      "failed preflight does not update adapter.dart",
    );
    _expect(
      !Directory("${root.path}/dart_defines").existsSync(),
      "failed preflight does not create dart_defines",
    );
  } finally {
    await root.delete(recursive: true);
  }
}

Future<Map<String, String>> _environmentContents(Directory root) async {
  final result = <String, String>{};
  for (final flavor in const ["dev", "test", "stg", "prod"]) {
    result[flavor] =
        await File("${root.path}/dart_defines/$flavor.env").readAsString();
  }
  return result;
}

void _expect(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual != expected) {
    throw StateError("$message: expected $expected, got $actual");
  }
}

void _expectCount(String source, String pattern, int count, String message) {
  final actual = pattern.allMatches(source).length;
  if (actual != count) {
    throw StateError("$message: expected $count, got $actual");
  }
}

const _mainFixture = """
void main() {
  runMasamuneApp(
    (ref) => MasamuneApp(
      masamuneAdapters: ref.adapters,
    ),
    masamuneAdapters: masamuneAdapters,
  );
}
""";

const _adapterFixture = """
import "package:masamune/masamune.dart";
import "package:masamune_universal_ui/masamune_universal_ui.dart";

final masamuneAdapters = runtimeMasamuneAdapters;

final runtimeMasamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
];
""";
