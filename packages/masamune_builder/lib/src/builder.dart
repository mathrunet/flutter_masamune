part of "/masamune_builder.dart";

/// Builder to generate codes for Controllers and Models.
///
/// コントローラーやModel用のコードをジェネレートするためのビルダー。
Builder masamuneBuilderFactory(BuilderOptions options) {
  return PartBuilder(
    [
      ControllerGenerator(),
      ControllerGroupGenerator(),
      DocumentModelGenerator(),
      CollectionModelGenerator(),
      FormValueGenerator(),
    ],
    ".m.dart",
    header:
        "// GENERATED CODE - DO NOT MODIFY BY HAND\r\n\r\n// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas",
  );
}
