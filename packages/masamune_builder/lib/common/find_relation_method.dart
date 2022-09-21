part of masamune_builder;

Method findRelationMethod(ClassModel model) {
  return Method(
    (m) => m
      ..name = "_find${model.name}Relation"
      ..types = ListBuilder([const Reference("T extends BuiltDocumentBase")])
      ..requiredParameters = ListBuilder([
        Parameter(
          (p) => p
            ..name = "original"
            ..type = const Reference("Map<String, dynamic>"),
        ),
        Parameter(
          (p) => p
            ..name = "additional"
            ..type = const Reference("List<T>?"),
        ),
        Parameter(
          (p) => p
            ..name = "originalKey"
            ..type = const Reference("String"),
        ),
      ])
      ..returns = const Reference("T?")
      ..body = const Code(
        "if(additional == null){return null;}final val = original.get(originalKey, \"\");return additional.firstWhereOrNull((e) { return val == e.uid; });",
      ),
  );
}
