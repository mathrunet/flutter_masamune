part of masamune_builder;

Builder masamuneBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      CollectionGenerator(),
      DocumentGenerator(),
      PageGenerator(),
    ],
    ".m.dart",
  );
}
