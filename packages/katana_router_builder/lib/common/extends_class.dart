part of katana_router_builder;

List<Class> extendsClass(ClassModel model, PathModel path) {
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
                      ..type = Reference(param.type.toString())
                      ..name = param.name,
                  );
                }),
              ])
              ..initializers = ListBuilder([
                ...model.parameters
                    .map((param) => Code("_${param.name} = ${param.name}")),
                const Code("super._()"),
              ]),
          )
        ])
        ..fields = ListBuilder([
          ...model.parameters.map((param) {
            return Field(
              (f) => f
                ..modifier = FieldModifier.final$
                ..type = Reference(param.type.toString())
                ..name = "_${param.name}",
            );
          }),
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "create"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = Reference("\$${model.name}")
              ..body = Code(
                "return \$${model.name}(${model.parameters.map((param) => "${param.name}:_${param.name}").join(",")});",
              ),
          ),
          Method(
            (m) => m
              ..name = "createState"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = Reference("_${model.name}State")
              ..lambda = true
              ..body = Code("_${model.name}State()"),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}"
        ..abstract = true
        ..extend = Reference("PageWidgetBuilder<\$${model.name}>")
        ..annotations = ListBuilder([const Reference("immutable")])
        ..constructors = ListBuilder([Constructor((c) => c..constant = true)])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "create"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = Reference("\$${model.name}")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_${model.name}State"
        ..extend = Reference(
          "PageWidgetBuilderState<\$${model.name}, _${model.name}>",
        ),
    ),
  ];
}
