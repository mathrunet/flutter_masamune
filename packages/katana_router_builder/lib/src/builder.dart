part of katana_router_builder;

Builder katanaRouterBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      PageGenerator(),
    ],
    ".router.dart",
    header:
        "// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators",
  );
}
