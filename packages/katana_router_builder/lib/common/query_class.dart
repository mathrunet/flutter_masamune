part of katana_router_builder;

/// Create classes for queries.
///
/// Pass the value for the query to [model], the path created from the annotation to [path], and the annotation value to [annotation].
///
/// クエリー用のクラスを作成します。
///
/// [model]にクエリー用の値を[path]にアノテーションから作成されたパスを[annotation]にアノテーションの値を渡します。
List<Class> queryClass(
  ClassValue model,
  PathValue? path,
  AnnotationValue annotation,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}Query"
        ..extend = const Reference("RouteQueryBuilder")
        ..annotations.addAll([const Reference("immutable")])
        ..constructors.addAll([
          Constructor(
            (c) => c..constant = true,
          )
        ])
        ..fields.addAll([
          if (path != null)
            Field(
              (f) => f
                ..name = "_regExp"
                ..static = true
                ..modifier = FieldModifier.final$
                ..assignment = Code(
                  "RegExp(r\"^${path.path.trimQuery().trimString("/").replaceAllMapped(_pathRegExp, (match) {
                    return "(?<${match.group(1)!}>[^/?&]+)";
                  })}\$\")",
                ),
            )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "call"
              ..lambda = true
              ..returns = Reference("_\$_${model.name}Query")
              ..annotations.addAll([const Reference("useResult")])
              ..optionalParameters.addAll([
                ...model.parameters.map((param) {
                  return Parameter(
                    (p) => p
                      ..required = param.element.isRequired
                      ..named = true
                      ..type = Reference(param.type.toString())
                      ..name = param.name
                      ..defaultTo = param.element.defaultValueCode != null
                          ? Code(param.element.defaultValueCode!)
                          : null,
                  );
                }),
              ])
              ..body = Code(
                "_\$_${model.name}Query(null, ${model.parameters.map((param) => "${param.name}:${param.name}").join(",")})",
              ),
          ),
          Method(
            (m) => m
              ..name = "resolve"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("RouteQuery?")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "path"
                    ..type = const Reference("String?"),
                )
              ])
              ..body = Code(
                path == null
                    ? "return null;"
                    : "if (path == null) { return null; } if (path.contains(\"?\")) { final split = path.split(\"?\"); final match = _regExp.firstMatch(split.first.trimString(\"/\")); if (match == null) { return null; } final query = Uri.splitQueryString(split.last); return _\$_${model.name}Query(path, ${model.parameters.map((param) => _defaultParsedValue(path, param, true)).where((e) => e.isNotEmpty).join(",")}); } else { path = path.trimQuery().trimString(\"/\"); final match = _regExp.firstMatch(path.trimQuery().trimString(\"/\")); if (match == null) { return null; } return _\$_${model.name}Query(path, ${model.parameters.map((param) => _defaultParsedValue(path, param, false)).where((e) => e.isNotEmpty).join(",")}); }",
              ),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$_${model.name}Query"
        ..extend = const Reference("RouteQuery")
        ..annotations.addAll([const Reference("immutable")])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..constant = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..toThis = true
                    ..name = "_path",
                )
              ])
              ..optionalParameters.addAll([
                ...model.parameters.map((param) {
                  return Parameter(
                    (p) => p
                      ..required = param.element.isRequired
                      ..named = true
                      ..toThis = true
                      ..name = param.name
                      ..defaultTo = param.element.defaultValueCode != null
                          ? Code(param.element.defaultValueCode!)
                          : null,
                  );
                }),
              ]),
          )
        ])
        ..fields.addAll([
          ...model.parameters.map((param) {
            return Field(
              (f) => f
                ..name = param.name
                ..modifier = FieldModifier.final$
                ..type = Reference(param.type.toString()),
            );
          }),
          Field(
            (f) => f
              ..name = "_path"
              ..modifier = FieldModifier.final$
              ..type = const Reference("String?"),
          ),
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "path"
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..lambda = true
              ..returns = const Reference("String")
              ..body = Code(
                path == null
                    ? "_path ?? \"${model.name.toSHA1()}\$_parameters\""
                    : "_path ?? \"${path.path.trimQuery().trimString("/").replaceAllMapped(_pathRegExp, (match) {
                        return "\$${match.group(1)?.toCamelCase()}";
                      })}\$_parameters\"",
              ),
          ),
          Method(
            (m) => m
              ..name = "_parameters"
              ..type = MethodType.getter
              ..returns = const Reference("String")
              ..body = Code(
                  "final \$q = <String, String>{}; ${model.parameters.map((e) => !e.isQueryParameter ? "" : "if (${e.name}?.toString().isNotEmpty ?? false) { \$q[\"${e.queryParamName}\"] = ${e.name}!.toString(); }").join("")} return \$q.isEmpty ? \"\" : \"?\${\$q.entries.map((e) => \"\${e.key}=\${e.value}\").join(\"&\")}\";"),
          ),
          Method(
            (m) => m
              ..name = "name"
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..lambda = true
              ..returns = const Reference("String")
              ..body = Code(
                annotation.name == null ? "path" : "\"${annotation.name}\"",
              ),
          ),
          Method(
            (m) => m
              ..name = "nested"
              ..annotations.addAll([const Reference("override")])
              ..type = MethodType.getter
              ..lambda = true
              ..returns = const Reference("bool")
              ..body = Code(path == null ? "true" : "false"),
          ),
          Method(
            (m) => m
              ..name = "key<E>"
              ..annotations.addAll([const Reference("override")])
              ..lambda = true
              ..returns = const Reference("E?")
              ..body = Code(
                annotation.keyString == "null"
                    ? "null"
                    : "${annotation.keyString} as E?",
              ),
          ),
          Method(
            (m) => m
              ..name = "widget<W extends Widget>"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("W?")
              ..body = Code(
                "final w = ${model.name}(${model.parameters.map((param) => "${param.name}:${param.name}").join(",")}); if(w is! W){ return null; } return w as W;",
              ),
          ),
          Method(
            (m) => m
              ..name = "redirect"
              ..annotations.addAll([const Reference("override")])
              ..lambda = true
              ..returns = const Reference("List<RedirectQuery>")
              ..body = Code("const [${annotation.redirectQueries.join(",")}]"),
          ),
          Method(
            (m) => m
              ..name = "route<E>"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("AppPageRoute<E>")
              ..optionalParameters.addAll([
                Parameter(
                  (p) => p
                    ..type = const Reference("TransitionQuery?")
                    ..name = "query",
                )
              ])
              ..body = Code(
                "return AppPageRoute<E>(path: path,transitionQuery: query,builder: (context) => ${model.name}(${model.parameters.map((param) => "${param.name}:${param.name}").join(",")}),);",
              ),
          ),
        ]),
    ),
  ];
}

String _defaultParsedValue(
    PathValue path, ParamaterValue param, bool existQuery) {
  if (existQuery) {
    if (param.type.toString().trimStringRight("?") == "String" ||
        param.type.toString().trimStringRight("?") == "Object") {
      final isPageParameter = param.isPageParameter ||
          path.path.contains(":${param.pageParamName}") ||
          path.path.contains(":${param.pageParamName.toSnakeCase()}") ||
          path.path.contains(":${param.pageParamName.toCamelCase()}");
      if (isPageParameter) {
        return "${param.name}: match.namedGroup(\"${param.pageParamName}\") ?? match.namedGroup(\"${param.pageParamName.toSnakeCase()}\") ?? match.namedGroup(\"${param.pageParamName.toCamelCase()}\") ?? query[\"${param.queryParamName}\"] ?? query[\"${param.queryParamName.toSnakeCase()}\"] ?? query[\"${param.queryParamName.toCamelCase()}\"] ?? ${_defaultValue(param)}";
      } else {
        return "${param.name}: query[\"${param.queryParamName}\"] ?? query[\"${param.queryParamName.toSnakeCase()}\"] ?? query[\"${param.queryParamName.toCamelCase()}\"] ?? ${_defaultValue(param)}";
      }
    } else if (param.type.toString().trimStringRight("?") == "int") {
      final res = _defaultValue(param);
      if (res == "null") {
        return "";
      }
      return "${param.name}: int.tryParse( query[\"${param.queryParamName}\"] ?? \"\" ) ?? int.tryParse( query[\"${param.queryParamName.toSnakeCase()}\"] ?? \"\" ) ?? int.tryParse( query[\"${param.queryParamName.toCamelCase()}\"] ?? \"\" ) ?? $res";
    } else if (param.type.toString().trimStringRight("?") == "num" ||
        param.type.toString().trimStringRight("?") == "double") {
      final res = _defaultValue(param);
      if (res == "null") {
        return "";
      }
      return "${param.name}: double.tryParse( query[\"${param.queryParamName}\"] ?? \"\" ) ?? double.tryParse( query[\"${param.queryParamName.toSnakeCase()}\"] ?? \"\" ) ?? double.tryParse( query[\"${param.queryParamName.toCamelCase()}\"] ?? \"\" ) ?? $res";
    } else if (param.type.toString().trimStringRight("?") == "bool") {
      final res = _defaultValue(param);
      if (res == "null") {
        return "";
      }
      return "${param.name}: ( query[\"${param.queryParamName}\"] ?? query[\"${param.queryParamName.toSnakeCase()}\"] ?? query[\"${param.queryParamName.toCamelCase()}\"] ?? \"$res\" ).toLowerCase() == \"true\"";
    } else {
      final res = _defaultValue(param);
      if (res == "null") {
        return "";
      }
      return "${param.name}: $res";
    }
  } else {
    if (param.type.toString().trimStringRight("?") == "String" ||
        param.type.toString().trimStringRight("?") == "Object") {
      final isPageParameter = param.isPageParameter ||
          path.path.contains(":${param.pageParamName}") ||
          path.path.contains(":${param.pageParamName.toSnakeCase()}") ||
          path.path.contains(":${param.pageParamName.toCamelCase()}");
      if (isPageParameter) {
        return "${param.name}: match.namedGroup(\"${param.pageParamName}\") ?? match.namedGroup(\"${param.pageParamName.toSnakeCase()}\") ?? match.namedGroup(\"${param.pageParamName.toCamelCase()}\") ?? ${_defaultValue(param)}";
      } else {
        return "${param.name}: ${_defaultValue(param)}";
      }
    } else {
      final res = _defaultValue(param);
      if (res == "null") {
        return "";
      }
      return "${param.name}: $res";
    }
  }
}
