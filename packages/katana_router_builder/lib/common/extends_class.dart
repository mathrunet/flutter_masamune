part of katana_router_builder;

List<Class> extendsClass(
  ClassModel model,
  PathModel path,
  AnnotationModel annotation,
) {
  return [
    Class(
      (c) => c
        ..name = "_${model.name}"
        ..extend = Reference(model.name)
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
              ])
              ..initializers = ListBuilder([
                const Code("super._()"),
              ]),
          )
        ])
        ..fields = ListBuilder([
          ...model.parameters.map((param) {
            return Field(
              (f) => f
                ..modifier = FieldModifier.final$
                ..annotations = ListBuilder([const Reference("override")])
                ..type = Reference(param.type.toString())
                ..name = param.name,
            );
          }),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}"
        ..abstract = true
        ..annotations = ListBuilder([const Reference("immutable")])
        ..fields = ListBuilder([])
        ..methods = ListBuilder([
          ...model.parameters.map((param) {
            return Method(
              (f) => f
                ..type = MethodType.getter
                ..returns = Reference(param.type.toString())
                ..name = param.name
                ..lambda = true
                ..body = const Code("throw UnimplementedError();"),
            );
          }),
        ]),
    ),
  ];
}
