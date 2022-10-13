part of katana_router_builder;

List<Class> queryClass(
  ClassModel model,
  PathModel path,
  AnnotationModel annotation,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}Query"
        ..extend = const Reference("PageQueryBuilder")
        ..annotations = ListBuilder([const Reference("immutable")])
        ..constructors = ListBuilder([
          Constructor(
            (c) => c..constant = true,
          )
        ])
        ..fields = ListBuilder([
          Field(
            (f) => f
              ..name = "_regExp"
              ..static = true
              ..modifier = FieldModifier.final$
              ..assignment = Code(
                "RegExp(r\"^${path.path.trimQuery().trimString("/").replaceAllMapped(pathRegExp, (match) {
                  return "(?<${match.group(1)?.toCamelCase()}>[^/?&]+)";
                })}\$\")",
              ),
          )
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "call"
              ..lambda = true
              ..returns = Reference("_\$_${model.name}Query")
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
                "_\$_${model.name}Query(${model.parameters.map((param) => "${param.name}:${param.name}").join(",")})",
              ),
          ),
          Method(
            (m) => m
              ..name = "resolve"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("PageQuery?")
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "path"
                    ..type = const Reference("String?"),
                )
              ])
              ..optionalParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..name = "force"
                    ..named = true
                    ..type = const Reference("bool")
                    ..defaultTo = const Code("false"),
                )
              ])
              ..body = Code(
                "final match = _regExp.firstMatch(path?.trimQuery().trimString(\"/\") ?? \"\"); if (match == null && !force) {return null;} return _\$_${model.name}Query(${model.parameters.map((param) => "${param.name}:match?.namedGroup(\"${param.name}\") ?? ${_defaultValue(param)}").join(",")});",
              ),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$_${model.name}Query"
        ..extend = const Reference("PageQuery")
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
                  "\"${path.path.trimQuery().trimString("/").replaceAllMapped(pathRegExp, (match) {
                return "\$${match.group(1)?.toCamelCase()}";
              })}\""),
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
              ..name = "route<T>"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("PageRouteQuery<T>")
              ..optionalParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..type = const Reference("RouteQuery?")
                    ..name = "query",
                )
              ])
              ..body = Code(
                "return PageRouteQuery<T>(path: path,routeQuery: query,builder: (context) {return _${model.name}(${model.parameters.map((param) => "${param.name}:${param.name}").join(",")});},transition: query?.transition ?? RouteQueryType.initial,);",
              ),
          ),
        ]),
    ),
  ];
}
