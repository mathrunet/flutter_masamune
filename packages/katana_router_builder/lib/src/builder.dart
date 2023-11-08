part of '/katana_router_builder.dart';

/// Builder Factory for pages.
///
/// ページ用のビルダーファクトリー。
Builder katanaRouterPageBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      PageGenerator(),
      NestedPageGenerator(),
    ],
    ".page.dart",
    header:
        "// GENERATED CODE - DO NOT MODIFY BY HAND\r\n\r\n// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, unused_local_variable",
  );
}

/// Builder factory for routers.
///
/// ルーター用のビルダーファクトリー。
Builder katanaRouterRouterBuilderFactory(BuilderOptions options) {
  return source_gen.LibraryBuilder(
    RouterGenerator(),
    generatedExtension: ".router.dart",
    header:
        "// GENERATED CODE - DO NOT MODIFY BY HAND\r\n\r\n// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, depend_on_referenced_packages",
  );
}
