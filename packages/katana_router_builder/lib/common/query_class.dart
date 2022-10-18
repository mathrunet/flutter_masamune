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
        ..name = "_\$${model.name}"
        ..extend = const Reference("RouteQueryBuilder")
        ..annotations = ListBuilder([const Reference("immutable")])
        ..constructors = ListBuilder([
          Constructor(
            (c) => c..constant = true,
          )
        ])
        ..fields = ListBuilder([
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
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "call"
              ..lambda = true
              ..returns = Reference("_\$_${model.name}")
              ..optionalParameters = ListBuilder([
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
                "_\$_${model.name}(${model.parameters.map((param) => "${param.name}:${param.name}").join(",")})",
              ),
          ),
          Method(
            (m) => m
              ..name = "resolve"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("RouteQuery?")
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "path"
                    ..type = const Reference("String?"),
                )
              ])
              ..body = Code(
                path == null
                    ? "return null;"
                    : "final match = _regExp.firstMatch(path?.trimQuery().trimString(\"/\") ?? \"\"); if (match == null) {return null;} return _\$_${model.name}(${model.parameters.map((param) => _defaultParsedValue(param)).join(",")});",
              ),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$_${model.name}"
        ..extend = const Reference("RouteQuery")
        ..annotations = ListBuilder([const Reference("immutable")])
        ..constructors = ListBuilder([
          Constructor(
            (c) => c
              ..constant = true
              ..optionalParameters = ListBuilder([
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
        ..fields = ListBuilder([
          ...model.parameters.map((param) {
            return Field(
              (f) => f
                ..name = param.name
                ..modifier = FieldModifier.final$
                ..type = Reference(param.type.toString()),
            );
          }),
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "path"
              ..type = MethodType.getter
              ..annotations = ListBuilder([const Reference("override")])
              ..lambda = true
              ..returns = const Reference("String")
              ..body = Code(
                path == null
                    ? "\"$uuid\""
                    : "\"${path.path.trimQuery().trimString("/").replaceAllMapped(_pathRegExp, (match) {
                        return "\$${match.group(1)?.toCamelCase()}";
                      })}\"",
              ),
          ),
          Method(
            (m) => m
              ..name = "key<E>"
              ..annotations = ListBuilder([const Reference("override")])
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
              ..annotations = ListBuilder([const Reference("override")])
              ..lambda = true
              ..returns = const Reference("List<RedirectQuery>")
              ..body = Code("const [${annotation.redirectQueries.join(",")}]"),
          ),
          Method(
            (m) => m
              ..name = "route<E>"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("AppPageRoute<E>")
              ..optionalParameters = ListBuilder([
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

String _defaultParsedValue(ParamaterValue param) {
  if (param.type.toString() == "String") {
    return "${param.name}:match.groupNames.contains(\"${param.pageParamName}\") ? match.namedGroup(\"${param.pageParamName}\") ?? ${_defaultValue(param)} : ${_defaultValue(param)}";
  } else {
    return "${param.name}:${_defaultValue(param)}";
  }
}
