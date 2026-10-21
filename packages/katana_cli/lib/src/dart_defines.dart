// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/src/environment.dart";

/// Directory where expanded dart-define files are written.
///
/// 展開済みのdart-defineファイルを書き出すディレクトリ。
const kResolvedDartDefinesDirectory = "build/katana/dart_defines";

final _dartDefinesReferencePattern = RegExp(
  r"(\$?)\$\{([A-Za-z_][A-Za-z0-9_]*)(?::-([^}]*))?\}",
);

/// Exception thrown when an expanded dart-define value contains a line break.
///
/// 展開後のdart-defineの値に改行が含まれる場合にスローされる例外。
class KatanaDartDefinesException implements Exception {
  /// Exception thrown when an expanded dart-define value contains a line break.
  ///
  /// 展開後のdart-defineの値に改行が含まれる場合にスローされる例外。
  const KatanaDartDefinesException({
    required this.keys,
    required this.source,
  });

  /// Keys whose values contain a line break.
  ///
  /// 値に改行が含まれるキー。
  final List<String> keys;

  /// Name of the dart-define file.
  ///
  /// dart-defineファイル名。
  final String source;

  @override
  String toString() {
    return "Dart-define value(s) in $source must not contain line breaks: "
        "${keys.join(", ")}.";
  }
}

/// Returns the names of environment variables referenced by `${NAME}` in the dart-define file at [path].
///
/// References with a default value (`${NAME:-default}`) are included unless [requiredOnly] is `true`. Escaped references (`$${NAME}`) are not.
/// Returns an empty set if the file does not exist.
///
/// [path]のdart-defineファイルで`${NAME}`として参照されている環境変数名を返します。
///
/// デフォルト値付きの参照（`${NAME:-default}`）は[requiredOnly]が`true`でない限り含み、エスケープされた参照（`$${NAME}`）は含みません。
/// ファイルが存在しない場合は空のセットを返します。
Set<String> dartDefinesEnvironmentNames(
  String path, {
  bool requiredOnly = false,
}) {
  final file = File(path);
  if (!file.existsSync()) {
    return <String>{};
  }
  final names = <String>{};
  for (final line in file.readAsLinesSync()) {
    final value = _splitDefine(line)?.value;
    if (value == null) {
      continue;
    }
    for (final match in _dartDefinesReferencePattern.allMatches(value)) {
      if (match.group(1)!.isEmpty &&
          (!requiredOnly || match.group(3) == null)) {
        names.add(match.group(2)!);
      }
    }
  }
  return names;
}

/// Expands `${NAME}` in the values of the dart-define file at [path] and returns the path of the file to pass to Flutter.
///
/// If the file has no `${`, [path] is returned unchanged.
/// Otherwise the expanded file is written to [kResolvedDartDefinesDirectory] with owner-only permissions and its path is returned.
/// Keys, comments and blank lines are kept as they are. The syntax is the same as [expandEnvironmentVariables].
/// Throws [KatanaEnvironmentVariableException] for undefined variables and [KatanaDartDefinesException] for values with line breaks.
///
/// [path]のdart-defineファイルの値に含まれる`${NAME}`を展開し、Flutterに渡すファイルのパスを返します。
///
/// `${`を含まない場合は[path]をそのまま返します。
/// 含む場合は展開済みファイルを所有者のみ読み書きできる権限で[kResolvedDartDefinesDirectory]に書き出し、そのパスを返します。
/// キー、コメント、空行はそのまま残します。構文は[expandEnvironmentVariables]と同じです。
/// 未定義の変数がある場合は[KatanaEnvironmentVariableException]、値に改行が含まれる場合は[KatanaDartDefinesException]をスローします。
String resolveDartDefinesFile(
  String path, {
  Map<String, String>? environment,
}) {
  final file = File(path);
  if (!file.existsSync()) {
    return path;
  }
  final content = file.readAsStringSync();
  if (!content.contains(r"${")) {
    return path;
  }
  final missing = <String>{};
  final multiline = <String>[];
  final lines = content.split("\n").map((line) {
    final define = _splitDefine(line);
    if (define == null || !define.value.contains(r"${")) {
      return line;
    }
    final String value;
    try {
      value = expandEnvironmentVariables(
        define.value,
        environment: environment,
      ) as String;
    } on KatanaEnvironmentVariableException catch (e) {
      missing.addAll(e.names);
      return line;
    }
    if (value.contains("\n") || value.contains("\r")) {
      multiline.add(define.key.trim());
      return line;
    }
    return "${define.key}=$value${define.lineEnd}";
  }).toList();
  if (missing.isNotEmpty) {
    throw KatanaEnvironmentVariableException(
      names: missing.toList(),
      source: path,
    );
  }
  if (multiline.isNotEmpty) {
    throw KatanaDartDefinesException(keys: multiline, source: path);
  }
  final output = File(
    "$kResolvedDartDefinesDirectory/${file.uri.pathSegments.last}",
  );
  output.parent.createSync(recursive: true);
  output.writeAsStringSync("");
  if (!Platform.isWindows) {
    Process.runSync("chmod", ["600", output.path]);
  }
  output.writeAsStringSync(lines.join("\n"));
  return output.path;
}

/// Calls [resolveDartDefinesFile] and exits with an error message if it fails.
///
/// [resolveDartDefinesFile]を呼び出し、失敗した場合はエラーメッセージを出力して終了します。
String resolveDartDefinesFileOrExit(String path) {
  try {
    return resolveDartDefinesFile(path);
  } on KatanaEnvironmentVariableException catch (e) {
    stderr.writeln(e);
    exit(1);
  } on KatanaDartDefinesException catch (e) {
    stderr.writeln(e);
    exit(1);
  }
}

({String key, String value, String lineEnd})? _splitDefine(String line) {
  final trimmed = line.trimLeft();
  if (trimmed.isEmpty || trimmed.startsWith("#")) {
    return null;
  }
  final index = line.indexOf("=");
  if (index < 0) {
    return null;
  }
  final rest = line.substring(index + 1);
  final lineEnd = rest.endsWith("\r") ? "\r" : "";
  return (
    key: line.substring(0, index),
    value: lineEnd.isEmpty ? rest : rest.substring(0, rest.length - 1),
    lineEnd: lineEnd,
  );
}
