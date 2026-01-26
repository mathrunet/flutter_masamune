// Dart imports:
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
    r"m.deploy\([\s\S]*?exports,[\s\S]*?\[(?<regions>[^\]]*?)\],[\s\S]*?\[(?<functions>[^\]]*?)\],?[\s\S]*\);",
  );

  static final _importRegexp = RegExp(
    "import\\s+([\\s\\S]*?)\\s+from\\s+\"(@mathrunet/[\\s\\S]*?)\"\\s*;",
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
            .map((e) => e.trim().replaceAll(RegExp("^m.Functions."), ""))
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
      "import * as m from \"@mathrunet/masamune\";",
    ].distinct();
    _rawData = _rawData.replaceAll(_importRegexp, "");
    for (final import in imports) {
      _rawData = "$import\n$_rawData";
    }
    _rawData = _rawData.replaceAll(_functionRegExp, """
m.deploy(
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
  FunctionsEnv();

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
