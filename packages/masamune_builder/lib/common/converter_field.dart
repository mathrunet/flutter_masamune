part of masamune_builder;

Field converterField(ClassModel model, String converter) {
  return Field(
    (f) => f
      ..name = "_${model.name.toCamelCase()}Converter"
      ..modifier = FieldModifier.constant
      ..assignment = Code("$converter()"),
  );
}
