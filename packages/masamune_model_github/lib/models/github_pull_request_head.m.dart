// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations

part of 'github_pull_request_head.dart';

// **************************************************************************
// FormValueGenerator
// **************************************************************************

@immutable
class _$GithubPullRequestHeadValueFormQuery {
  const _$GithubPullRequestHeadValueFormQuery();

  @useResult
  _$_GithubPullRequestHeadValueFormQuery call(
    GithubPullRequestHeadValue value,
  ) {
    return _$_GithubPullRequestHeadValueFormQuery(value);
  }
}

@immutable
class _$_GithubPullRequestHeadValueFormQuery
    extends FormControllerQueryBase<GithubPullRequestHeadValue> {
  const _$_GithubPullRequestHeadValueFormQuery(this.value);

  final GithubPullRequestHeadValue value;

  @override
  FormController<GithubPullRequestHeadValue> Function() call(Ref ref) =>
      () => FormController(value);

  @override
  String get queryName => value.hashCode.toString();

  @override
  bool get autoDisposeWhenUnreferenced => true;
}
