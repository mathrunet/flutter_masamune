part of masamune_builder;

Method convertMethod(ClassModel model, String suffix) {
  return Method(
    (m) => m
      ..name = "_convert"
      ..optionalParameters = ListBuilder([
        ...model.parameters.map((param) {
          return Parameter(
            (p) => p
              ..name = param.name
              ..named = true
              ..type = Reference(
                "${param.type.toString().trimStringRight("?")}?",
              ),
          );
        }),
      ])
      ..returns = const Reference("Map<String, dynamic>")
      ..body = Code(
        "return {${model.parameters.map(
              (param) =>
                  "if (${param.name} != null) ${model.name}$suffix.${param.name}: _converter.convertTo(${param.name})",
            ).join(",")},};",
      ),
  );
}
