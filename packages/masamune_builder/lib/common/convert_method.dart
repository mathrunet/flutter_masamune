part of masamune_builder;

Method convertMethod(ClassModel model, String suffix) {
  return Method(
    (m) => m
      ..name = "_${model.name.toCamelCase()}Convert"
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
                  "if (${param.name} != null) ${model.name}$suffix.${param.name}.id: _${model.name.toCamelCase()}Converter.convertTo(${param.name})",
            ).join(",")},};",
      ),
  );
}
