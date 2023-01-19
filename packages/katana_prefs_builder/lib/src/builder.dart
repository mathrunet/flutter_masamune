part of katana_prefs_builder;

/// Builder to create a class to read and write SharedPreferences.
///
/// SharedPreferencesの読み書きを行うためのクラスを作成するビルダー。
Builder katanaPrefsBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      PrefsGenerator(),
    ],
    ".prefs.dart",
    header:
        "// GENERATED CODE - DO NOT MODIFY BY HAND\r\n\r\n// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check",
  );
}
