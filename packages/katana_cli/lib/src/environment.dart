// Dart imports:
import "dart:io";

// Package imports:
import "package:yaml/yaml.dart";

// Project imports:
import "package:katana_cli/src/framework.dart";

final _environmentVariablePattern = RegExp(
  r"(\$?)\$\{([A-Za-z_][A-Za-z0-9_]*)(?::-([^}]*))?\}",
);

/// Exception thrown when an environment variable referenced by `${NAME}` is not defined.
///
/// `${NAME}`で参照された環境変数が定義されていない場合にスローされる例外。
class KatanaEnvironmentVariableException implements Exception {
  /// Exception thrown when an environment variable referenced by `${NAME}` is not defined.
  ///
  /// `${NAME}`で参照された環境変数が定義されていない場合にスローされる例外。
  const KatanaEnvironmentVariableException({
    required this.names,
    this.source,
  });

  /// Names of undefined environment variables.
  ///
  /// 未定義の環境変数名。
  final List<String> names;

  /// Name of the file containing the reference.
  ///
  /// 参照を含むファイル名。
  final String? source;

  @override
  String toString() {
    final file = source == null ? "" : " in $source";
    return "Undefined environment variable(s)$file: ${names.join(", ")}. "
        "Set them or use `\${NAME:-default}`.";
  }
}

/// Expands `${NAME}` in the string values of [object] with environment variables.
///
/// `${NAME:-default}` uses `default` when the variable is undefined or empty, and `$${NAME}` is kept as the literal `${NAME}`.
/// Maps and lists are processed recursively; map keys and non-string values are not changed.
/// [environment] defaults to [Platform.environment].
/// Throws [KatanaEnvironmentVariableException] if a variable without a default is undefined.
///
/// [object]の文字列値に含まれる`${NAME}`を環境変数で展開します。
///
/// `${NAME:-default}`は変数が未定義または空のとき`default`を使い、`$${NAME}`は文字列`${NAME}`のまま残します。
/// MapとListは再帰的に処理し、Mapのキーと文字列以外の値は変更しません。
/// [environment]の既定値は[Platform.environment]です。
/// デフォルト値のない変数が未定義の場合は[KatanaEnvironmentVariableException]をスローします。
dynamic expandEnvironmentVariables(
  dynamic object, {
  Map<String, String>? environment,
  String? source,
}) {
  final values = environment ?? Platform.environment;
  final missing = <String>{};
  final expanded = _expand(object, values, missing);
  if (missing.isNotEmpty) {
    throw KatanaEnvironmentVariableException(
      names: missing.toList(),
      source: source,
    );
  }
  return expanded;
}

/// Loads [content] as YAML into a modifiable object and expands `${NAME}` with environment variables.
///
/// [content]をYAMLとして変更可能なオブジェクトに読み込み、`${NAME}`を環境変数で展開します。
dynamic loadKatanaYaml(
  String content, {
  Map<String, String>? environment,
  String? source,
}) {
  return expandEnvironmentVariables(
    modifize(loadYaml(content)),
    environment: environment,
    source: source,
  );
}

dynamic _expand(
  dynamic object,
  Map<String, String> environment,
  Set<String> missing,
) {
  if (object is Map) {
    return object.map(
      (key, value) => MapEntry(key, _expand(value, environment, missing)),
    );
  } else if (object is List) {
    return object.map((e) => _expand(e, environment, missing)).toList();
  } else if (object is String) {
    return object.replaceAllMapped(_environmentVariablePattern, (match) {
      if (match.group(1)!.isNotEmpty) {
        return match.group(0)!.substring(1);
      }
      final name = match.group(2)!;
      final defaultValue = match.group(3);
      final value = environment[name];
      if (defaultValue != null) {
        return value == null || value.isEmpty ? defaultValue : value;
      }
      if (value == null) {
        missing.add(name);
        return "";
      }
      return value;
    });
  }
  return object;
}
