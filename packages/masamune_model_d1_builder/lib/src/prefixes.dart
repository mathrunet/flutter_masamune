// Copyright (c) 2025 mathru. All rights reserved.

/// Reads D1 database prefixes from a build runner option.
///
/// The option accepts either a YAML list from `build.yaml` or a comma-separated
/// string passed through build runner's `--define` option.
///
/// build runnerオプションからD1データベースのプレフィックスを読み込みます。
///
/// `build.yaml`のYAMLリスト、またはbuild runnerの`--define`オプションで
/// 渡されたカンマ区切り文字列を受け付けます。
List<String> readD1DatabasePrefixOption(Object? value) {
  if (value == null) {
    return const [];
  }
  if (value is String) {
    return value.split(",");
  }
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  throw ArgumentError.value(
    value,
    "prefixes",
    "D1 schema prefixes must be a list or comma-separated string.",
  );
}

/// Normalizes and validates D1 physical database prefixes.
///
/// D1の物理データベース用プレフィックスを正規化して検証します。
List<String> normalizeD1DatabasePrefixes(Iterable<String?> values) {
  final prefixes = <String>{};
  for (final value in values) {
    var normalized = value?.trim() ?? "";
    normalized = normalized.replaceFirst(RegExp(r"_+$"), "");
    if (normalized.isEmpty) {
      continue;
    }
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(normalized)) {
      throw ArgumentError.value(
        value,
        "prefixes",
        "D1 schema prefixes must be valid identifiers.",
      );
    }
    prefixes.add("${normalized}_");
  }
  return prefixes.toList();
}
