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
            ..returns = Reference(model.name.toString())
            ..body = Code("_${model.name}._(this)"),
        )
      ]),
  );
}
