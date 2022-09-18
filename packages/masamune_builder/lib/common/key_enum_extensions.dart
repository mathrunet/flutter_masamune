part of masamune_builder;

Extension keyEnumExtensions(ClassModel model, String suffix) {
  return Extension(
    (e) => e
      ..name = "\$${model.name}${suffix}Extensions"
      ..on = Reference("${model.name}$suffix")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "id"
            ..type = MethodType.getter
            ..returns = const Reference("String")
            ..body = Code(
                "switch(this){case ${model.name}$suffix.uid: return \"uid\";${model.parameters.map((param) {
              return "case ${model.name}$suffix.${param.name}: return \"${param.name}\";";
            }).join("")}}"),
        )
      ]),
  );
}
