part of masamune_builder;

Field converterField(String converter) {
  return Field(
    (f) => f
      ..name = "_converter"
      ..modifier = FieldModifier.constant
      ..assignment = Code("$converter()"),
  );
}
