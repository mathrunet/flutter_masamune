part of katana_router_builder;

final _pathRegExp = RegExp(r":([^/]+)");

final _ignoreWords = <String>[
  "build",
  "query",
  "key",
  "path",
  "redirect",
  "route",
  "name",
];
