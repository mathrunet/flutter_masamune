part of katana_router_builder;

final pathRegExp = RegExp(r"\{([^\}]+)\}");

final ignoreWords = <String>[
  "uid",
  "time",
  "append",
  "fetch",
  "reload",
  "save",
  "loading",
  "saving",
  "create",
  "delete",
  "value",
  "transaction",
  "dispose",
  "document",
  "runtimeType",
  "toString",
  "addListener",
  "removeListener",
  "notifyListeners",
  "hasListeners"
];
