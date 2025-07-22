// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check, library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations, prefer_const_declarations, unused_element_parameter, prefer_constructors_over_static_methods, matching_super_parameters, prefer_double_quotes, unused_local_variable, unnecessary_lambdas

part of "masamune_introduction.dart";

// **************************************************************************
// PageGenerator
// **************************************************************************

@immutable
class _$MasamuneIntroductionPageQuery extends RouteQueryBuilder {
  const _$MasamuneIntroductionPageQuery();

  static final _regExp = RegExp(r"^tutorial$");

  @useResult
  RouteQuery call({RouteQuery? routeQuery}) =>
      _$_MasamuneIntroductionPageQuery(null, routeQuery: routeQuery);

  @override
  RouteQuery? resolve(String? path) {
    if (path == null) {
      return null;
    }
    if (path.contains("?")) {
      final split = path.split("?");
      final match = _regExp.firstMatch(split.first.trimString("/"));
      if (match == null) {
        return null;
      }
      final query = Uri.splitQueryString(split.last);
      return _$_MasamuneIntroductionPageQuery(
        path,
      );
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_MasamuneIntroductionPageQuery(
        path,
      );
    }
  }
}

@immutable
class _$_MasamuneIntroductionPageQuery extends RouteQuery {
  const _$_MasamuneIntroductionPageQuery(
    this._path, {
    this.routeQuery,
  });

  final RouteQuery? routeQuery;

  final String? _path;

  @override
  String get path => _path ?? "tutorial$_parameters";

  String get _parameters {
    final $q = <String, String>{};
    return $q.isEmpty
        ? ""
        : "?${$q.entries.map((e) => "${e.key}=${e.value}").join("&")}";
  }

  @override
  String get name => path;

  @override
  bool get hidden => false;

  @override
  TransitionQuery? get transition => TransitionQuery.fade;

  @override
  E? key<E>() => null;

  @override
  W? widget<W extends Widget>() {
    final w = MasamuneIntroductionPage(routeQuery: routeQuery);
    if (w is! W) {
      return null;
    }
    return w as W;
  }

  @override
  List<RedirectQuery> redirect() => const [];

  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query ?? transition,
      builder: (context) => MasamuneIntroductionPage(routeQuery: routeQuery),
    );
  }
}
