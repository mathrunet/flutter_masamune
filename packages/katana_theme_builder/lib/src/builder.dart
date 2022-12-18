part of katana_theme_builder;

/// Builder for creating data for themes.
///
/// テーマ用のデータを作成するためのビルダー。
Builder katanaThemeBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      ThemeGenerator(),
    ],
    ".theme.dart",
    header:
        "// GENERATED CODE - DO NOT MODIFY BY HAND\r\n\r\n// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, avoid_field_initializers_in_const_classes",
  );
}
