part of masamune_builder;

Builder masamuneBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      CollectionGenerator(),
      DocumentGenerator(),
      PageGenerator(),
    ],
    ".m.dart",
    header:
        "// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors",
  );
}
