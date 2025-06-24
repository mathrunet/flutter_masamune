part of "/katana_localization_builder.dart";

const _kBaseName = "Base";

const _kYamlKey = "key";

final _keyRegExp = RegExp(r"([^\{\}]+)|\{([a-zA-Z0-9_-]+)\}");
final _variableRegExp = RegExp(r"\{([a-zA-Z0-9_-]+)\}");

final _ignoreWords = <String>[
  "in",
  "new",
  "class",
  "set",
  "get",
];
