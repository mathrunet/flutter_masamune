part of katana_localization_builder;

/// Builder factory for translation.
///
/// 翻訳用のビルダーファクトリー。
Builder katanaLocalizationBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      GoogleSpreadSheetLocalizeGenerator(),
    ],
    ".localize.dart",
    header:
        "// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering",
  );
}
