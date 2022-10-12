part of katana_router_builder;

List<Class> valueClass(
  ClassModel model,
  PathModel path,
  AnnotationModel annotation,
) {
  return [
    Class(
      (c) => c
        ..name = "\$${model.name}"
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
                ..modifier = FieldModifier.final$
                ..type = Reference(param.type.toString())
                ..name = param.name,
            );
          }),
        ])
        ..methods = ListBuilder([
          Method(
            (m) => m
              ..name = "copyWith"
              ..returns = Reference("\$${model.name}")
              ..optionalParameters = ListBuilder([
                ...model.parameters.map((param) {
                  return Parameter(
                    (p) => p
                      ..named = true
                      ..type = Reference(
                        "${param.type.toString().trimStringRight("?")}?",
                      )
                      ..name = param.name,
                  );
                }),
              ])
              ..body = Code(
                "return \$${model.name}(${model.parameters.map((param) => "${param.name}:${param.name} ?? this.${param.name}").join(",")});",
              ),
          ),
          Method(
            (m) => m
              ..name = "hashCode"
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("int")
              ..type = MethodType.getter
              ..lambda = true
              ..optionalParameters = ListBuilder([
                ...model.parameters.map((param) {
                  return Parameter(
                    (p) => p
                      ..named = true
                      ..type = Reference("${param.type.toString()}?")
                      ..name = param.name,
                  );
                }),
              ])
              ..body = Code(
                model.parameters.isEmpty
                    ? "super.hashCode"
                    : model.parameters
                        .map((param) => "${param.name}.hashCode")
                        .join("^"),
              ),
          ),
          Method(
            (m) => m
              ..name = "operator =="
              ..annotations = ListBuilder([const Reference("override")])
              ..returns = const Reference("bool")
              ..lambda = true
              ..requiredParameters = ListBuilder([
                Parameter(
                  (p) => p
                    ..type = const Reference("Object")
                    ..name = "other",
                )
              ])
              ..body = const Code("super.hashCode == hashCode"),
          ),
        ]),
    ),
  ];
}
