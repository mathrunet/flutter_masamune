part of masamune_builder;

Class pageQueryClass(ClassModel model, PathModel path) {
  return Class(
    (c) => c
      ..name = "${model.name}Query"
      ..constructors = ListBuilder([
        Constructor(
          (c) => c
            ..name = "_"
            ..constant = true
            ..requiredParameters = ListBuilder([
              Parameter(
                (p) => p
                  ..name = "context"
                  ..type = const Reference("BuildContext"),
              ),
            ])
            ..initializers = ListBuilder([
              const Code("_context = context"),
            ]),
        )
      ])
      ..fields = ListBuilder([
        Field(
          (f) => f
            ..name = "_context"
            ..type = const Reference("BuildContext")
            ..modifier = FieldModifier.final$,
        ),
      ])
      ..methods = ListBuilder([
        ...model.parameters.map((param) {
          return Method(
            (m) => m
              ..name = param.name
              ..lambda = true
              ..type = MethodType.getter
              ..returns = Reference(param.type.toString())
              ..body = Code(
                "_context.get<${param.type}>(\"${param.name}\", ${param.defaultValue ?? _defaultValue(param)})",
              ),
          );
        }),
        ...path.parameters.map((param) {
          return Method(
            (m) => m
              ..name = param.camelCase
              ..lambda = true
              ..type = MethodType.getter
              ..returns = const Reference("String")
              ..body = Code(
                "_context.get<String>(\"${param.snakeCase}\", \"\")",
              ),
          );
        }),
      ]),
  );
}
