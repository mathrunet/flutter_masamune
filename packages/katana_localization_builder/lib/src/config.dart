part of katana_localization_builder;

const _kBaseName = "Base";

final _keyRegExp = RegExp(r"([^\{\}]+)|\{([a-zA-Z0-9_-]+)\}");
final _variableRegExp = RegExp(r"\{([a-zA-Z0-9_-]+)\}");

final _ignoreWords = <String>[
  "build",
  "query",
  "key",
  "path",
  "redirect",
  "route",
  "name",
];
