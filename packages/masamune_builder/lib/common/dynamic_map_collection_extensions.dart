part of masamune_builder;

Extension dynamicMapCollectionExtensions(ClassModel model) {
  return Extension(
    (e) => e
      ..name = "\$${model.name}DynamicMapCollectionExtensions"
      ..on = const Reference(
        "DynamicCollectionModel<DynamicDocumentModel>",
      )
      ..methods = ListBuilder([
        Method(
          (m) => m
            ..name = "to${model.name}"
            ..lambda = true
            ..returns = Reference("List<${model.name}>")
            ..body = Code("map((e) => e.to${model.name}()).toList()"),
        )
      ]),
  );
}
