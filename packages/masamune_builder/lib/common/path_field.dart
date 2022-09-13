part of masamune_builder;

Field pathField(String path) {
  return Field(
    (f) => f
      ..name = "_path"
      ..modifier = FieldModifier.constant
      ..assignment = Code("\"$path\""),
  );
}
