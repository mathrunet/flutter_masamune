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
                      ..name = param.name,
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
                    : "if (path == null) { return null; } if (path.contains(\"?\")) { final split = path.split(\"?\"); final match = _regExp.firstMatch(split.first.trimString(\"/\")); if (match == null) { return null; } final query = Uri.splitQueryString(split.last); return _\$_${model.name}Query(path, ${model.parameters.map((param) => _defaultParsedValue(param, true)).join(",")}); } else { path = path.trimQuery().trimString(\"/\"); final match = _regExp.firstMatch(path.trimQuery().trimString(\"/\")); if (match == null) { return null; } return _\$_${model.name}Query(path, ${model.parameters.map((param) => _defaultParsedValue(param, false)).join(",")}); }",
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
                      ..name = param.name,
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
                    ? "_path ?? \"${model.name.toSHA1()}\""
                    : "_path ?? \"${path.path.trimQuery().trimString("/").replaceAllMapped(_pathRegExp, (match) {
                        return "\$${match.group(1)?.toCamelCase()}";
                      })}\"",
              ),
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

String _defaultParsedValue(ParamaterValue param, bool existQuery) {
  if (existQuery) {
    if (param.type.toString() == "String") {
      return "${param.name}:match.groupNames.contains(\"${param.pageParamName}\") ? match.namedGroup(\"${param.pageParamName}\") ?? ( query.containsKey(\"${param.queryParamName}\") ? query[\"${param.queryParamName}\"] ?? ${_defaultValue(param)} : ${_defaultValue(param)}) : (query.containsKey(\"${param.queryParamName}\") ? query[\"${param.queryParamName}\"] ?? ${_defaultValue(param)} : ${_defaultValue(param)})";
    } else {
      return "${param.name}:(query.containsKey(\"${param.queryParamName}\") ? query[\"${param.queryParamName}\"] ?? ${_defaultValue(param)} : ${_defaultValue(param)})";
    }
  } else {
    if (param.type.toString() == "String") {
      return "${param.name}:match.groupNames.contains(\"${param.pageParamName}\") ? match.namedGroup(\"${param.pageParamName}\") ?? ${_defaultValue(param)} : ${_defaultValue(param)}";
    } else {
      return "${param.name}:${_defaultValue(param)}";
    }
  }
}
