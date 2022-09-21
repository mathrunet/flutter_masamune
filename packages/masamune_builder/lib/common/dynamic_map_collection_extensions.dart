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
            ..optionalParameters = ListBuilder([
              ...model.parameters
                  .where((param) => param.isRelation)
                  .map((param) {
                return Parameter(
                  (p) => p
                    ..name = param.name
                    ..type = Reference(
                      "List<${param.type.toString().trimString("?")}>?",
                    ),
                );
              }),
            ])
            ..returns = Reference("List<${model.name}>")
            ..body = Code(
              "map((e) => e.to${model.name}(${model.parameters.where((e) => e.isRelation).map((e) => "${e.name}:_find${model.name}Relation<${e.type.toString().trimString("?")}>(e, ${e.name}, \"${e.name}\")").join(",")})).toList()",
            ),
        )
      ]),
  );
}
