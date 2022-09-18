part of masamune_builder;

Field pathField(ClassModel model, String path) {
  return Field(
    (f) => f
      ..name = "_${model.name.toCamelCase()}Path"
      ..modifier = FieldModifier.constant
      ..type = const Reference("String")
      ..assignment = Code("\"$path\""),
  );
}
