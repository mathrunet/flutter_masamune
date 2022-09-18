part of masamune_builder;

Class pageQueryClass(ClassModel model, PathModel path) {
  return Class(
    (c) => c
      ..name = "${model.name}Query"
      ..extend = const Reference("PageQuery")
      ..constructors = ListBuilder([
        Constructor(
          (c) => c
            ..constant = true
            ..optionalParameters = ListBuilder([
              ...model.parameters.mapAndRemoveEmpty((param) {
                if (param.element.isRequired) {
                  return Parameter(
                    (p) => p
                      ..name = param.name
                      ..named = true
                      ..required = true
                      ..toThis = true,
                  );
                }
                if (param.defaultValue != null) {
                  return Parameter(
                    (p) => p
                      ..name = param.name
                      ..named = true
                      ..toThis = true
                      ..defaultTo = Code("${param.defaultValue}"),
                  );
                } else {
                  return Parameter(
                    (p) => p
                      ..name = param.name
                      ..named = true
                      ..toThis = true,
                  );
                }
              }),
              ...path.parameters.map((param) {
                return Parameter(
                  (f) => f
                    ..name = param.camelCase
                    ..named = true
                    ..required = true
                    ..toThis = true,
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
        ...path.parameters.map((param) {
          return Field(
            (f) => f
              ..name = param.camelCase
              ..modifier = FieldModifier.final$
              ..type = const Reference("String"),
          );
        }),
      ])
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "toString"
            ..lambda = true
            ..annotations = ListBuilder([const Reference("override")])
            ..returns = const Reference("String")
            ..body = Code(
                "\"${path.path.replaceAllMapped(RegExp(r"\{([^\}]+)\}"), (match) {
              return "\$${match.group(1)?.toCamelCase()}";
            })}\""),
        ),
        Method(
          (m) => m
            ..name = "toArguments"
            ..lambda = true
            ..annotations = ListBuilder([const Reference("override")])
            ..returns = const Reference("Map<String, dynamic>")
            ..body = Code(
              "{${model.parameters.map((e) => "\"${e.name}\":${e.name}").join(",")}}..removeWhere((key, value) => value == null)",
            ),
        ),
      ]),
  );
}
