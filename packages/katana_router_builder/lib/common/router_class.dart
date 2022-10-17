part of katana_router_builder;

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
    Class(
      (c) => c
        ..name = r"AppRouter"
        ..extend = const Reference("AppRouterBase")
        ..constructors = ListBuilder([
          Constructor(
            (c) => c
              ..optionalParameters = ListBuilder([
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
                    ..named = true
                    ..defaultTo = const Code("\"/\""),
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
              ])
              ..initializers = ListBuilder([
                Code(
                  "super(pages: [${queries.map((e) => e.query).join(",")}])",
                ),
              ]),
          )
        ])
        ..fields = ListBuilder([
          ...queries.map((query) {
            return Field(
              (f) => f
                ..name = query.element.name.toCamelCase()
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
        ]),
    ),
  ];
}
