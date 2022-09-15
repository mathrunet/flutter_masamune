part of masamune_builder;

Field pathField(ClassModel mode, String path) {
  return Field(
    (f) => f
      ..name = "_${mode.name.toCamelCase()}Path"
      ..modifier = FieldModifier.constant
      ..assignment = Code("\"$path\""),
  );
}
