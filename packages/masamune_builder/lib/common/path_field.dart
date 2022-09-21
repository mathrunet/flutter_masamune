part of masamune_builder;

Field pathField(ClassModel model, PathModel path) {
  return Field(
    (f) => f
      ..name = "_${model.name.toCamelCase()}Path"
      ..modifier = FieldModifier.constant
      ..type = const Reference("String")
      ..assignment = Code("\"${path.path}\""),
  );
}
