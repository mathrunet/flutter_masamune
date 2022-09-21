part of masamune_builder;

Extension keyEnumExtensions(ClassModel model) {
  return Extension(
    (e) => e
      ..name = "\$${model.name}KeysExtensions"
      ..on = Reference("${model.name}Keys")
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "id"
            ..type = MethodType.getter
            ..returns = const Reference("String")
            ..body = Code(
                "switch(this){case ${model.name}Keys.uid: return \"uid\";${model.parameters.map((param) {
              return "case ${model.name}Keys.${param.name}: return \"${param.name}\";";
            }).join("")}}"),
        )
      ]),
  );
}
