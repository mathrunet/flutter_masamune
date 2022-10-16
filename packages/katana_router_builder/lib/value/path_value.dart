part of katana_router_builder;

class PathValue {
  PathValue(this.path) {
    parameters = pathRegExp.allMatches(path).mapAndRemoveEmpty(
          (e) => _PathValue(e.group(1)!),
        );
  }

  late final String path;
  late final List<_PathValue> parameters;

  @override
  String toString() {
    return "$path(${parameters.map((e) => e.toString()).join(", ")})";
  }
}

class _PathValue {
  _PathValue(String text) {
    snakeCase = text.toSnakeCase();
    camelCase = text.toCamelCase();
  }

  late final String snakeCase;
  late final String camelCase;

  @override
  String toString() {
    return "$camelCase($snakeCase)";
  }
}
