part of "/katana_router_builder.dart";

/// Create a class for the router.
///
/// Create a list of parsed queries in [queries].
///
/// ルーター用のクラスを作成します。
///
/// [queries]に解析されたクエリーのリストを作成します。
List<Class> routerClass(
  List<QueryValue> queries,
) {
  return [
    Class((c) => c
          ..name = r"AutoRouter"
          ..extend = const Reference("AppRouter")
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "unknown"
                      ..named = true
                      ..toSuper = true,
                  ),
                  Parameter(
                    (p) => p
                      ..name = "boot"
                      ..named = true
                      ..toSuper = true,
                  ),
                  Parameter(
                    (p) => p
                      ..name = "initialPath"
                      ..toSuper = true
                      ..named = true,
                  ),
                  Parameter(
                    (p) => p
                      ..name = "initialQuery"
                      ..toSuper = true
                      ..named = true,
                  ),
                  Parameter(
                    (p) => p
                      ..name = "redirect"
                      ..toSuper = true
                      ..named = true
                      ..defaultTo = const Code("const []"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "observers"
                      ..toSuper = true
                      ..named = true
                      ..defaultTo = const Code("const []"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "redirectLimit"
                      ..toSuper = true
                      ..named = true
                      ..defaultTo = const Code("5"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "navigatorKey"
                      ..named = true
                      ..toSuper = true,
                  ),
                  Parameter(
                    (p) => p
                      ..name = "restorationScopeId"
                      ..named = true
                      ..toSuper = true,
                  ),
                  Parameter(
                    (p) => p
                      ..name = "defaultTransitionQuery"
                      ..named = true
                      ..toSuper = true,
                  ),
                  Parameter(
                    (p) => p
                      ..name = "pages"
                      ..named = true
                      ..type = const Reference("List<RouteQueryBuilder>?"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "reportsRouteUpdateToEngine"
                      ..named = true
                      ..toSuper = true
                      ..defaultTo = const Code("true"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "backgroundWidget"
                      ..named = true
                      ..toSuper = true
                      ..defaultTo = const Code("const Scaffold()"),
                  ),
                  Parameter(
                    (p) => p
                      ..name = "loggerAdapters"
                      ..named = true
                      ..toSuper = true,
                  ),
                ])
                ..initializers.addAll([
                  Code(
                    "super(pages: pages ?? [${queries.map((e) => e.query).join(",")}])",
                  ),
                ]),
            )
          ])
          ..fields.addAll([
            ...queries.map((query) {
              return Field(
                (f) => f
                  ..name = query.element.name3?.toCamelCase()
                  ..static = true
                  ..modifier = FieldModifier.constant
                  ..assignment = Code(query.query),
              );
            }),
            Field(
              (f) => f
                ..name = "queryMap"
                ..type = const Reference("Map<RouteQueryBuilder, String>")
                ..assignment = Code(
                  "{${queries.map((q) => "${q.query}:\"/${q.path}\"").join(",")}}",
                ),
            )
          ])
        // TODO: 非アクティブにするが一応残しておく
        // ..methods.addAll([
        //   Method(
        //     (m) => m
        //       ..name = "setPathUrlStrategy"
        //       ..static = true
        //       ..returns = const Reference("void")
        //       ..lambda = true
        //       ..body = const Code("AppRouter.setPathUrlStrategy()"),
        //   )
        // ]),
        ),
  ];
}
