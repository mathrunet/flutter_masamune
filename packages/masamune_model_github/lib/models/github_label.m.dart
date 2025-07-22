// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of 'github_label.dart';

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubLabelValueFormQuery {
  const _$GithubLabelValueFormQuery();

  @useResult
  _$_GithubLabelValueFormQuery call(GithubLabelValue value) {
    return _$_GithubLabelValueFormQuery(value);
  }
}

@immutable
class _$_GithubLabelValueFormQuery
    extends FormControllerQueryBase<GithubLabelValue> {
  const _$_GithubLabelValueFormQuery(this.value);

  final GithubLabelValue value;

  @override
  FormController<GithubLabelValue> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
