part of masamune_builder;

Extension dynamicMapExtensions(ClassModel model) {
  return Extension(
    (e) => e
      ..name = "\$${model.name}DynamicMapExtensions"
      ..on = const Reference("Map<String, dynamic>")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "to${model.name}"
            ..lambda = true
            ..optionalParameters = ListBuilder([
              ...model.parameters
                  .where((param) => param.isRelation)
                  .map((param) {
                return Parameter(
                  (p) => p
                    ..name = param.name
                    ..named = true
                    ..type = Reference(
                      "${param.type.toString().trimString("?")}?",
                    ),
                );
              })
            ])
            ..returns = Reference(model.name.toString())
            ..body = Code(
              "_${model.name}._(this, ${model.parameters.where((e) => e.isRelation).map((e) => "${e.name}:${e.name}").join(",")})",
            ),
        )
      ]),
  );
}
