part of katana_router_builder;

final _pathRegExp = RegExp(r":([^/]+)");

final _ignoreWords = <String>[
  "build",
  "query",
  "value",
  "path",
  "redirect",
  "route"
];
