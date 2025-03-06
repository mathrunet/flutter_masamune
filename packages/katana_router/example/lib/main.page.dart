// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, unused_local_variable

part of 'main.dart';

// **************************************************************************
// PageGenerator
// **************************************************************************

@immutable
class _$MainPageQuery extends RouteQueryBuilder {
  const _$MainPageQuery();

  static final _regExp = RegExp(r"^$");

  @useResult
  RouteQuery call({required String title, String? q}) =>
      _$_MainPageQuery(null, title: title, q: q);

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
      return _$_MainPageQuery(
        path,
        title: query["title"] ?? query["title"] ?? query["title"] ?? "",
        q: query["q"] ?? query["q"] ?? query["q"] ?? null,
      );
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_MainPageQuery(path, title: "", q: null);
    }
  }
}

@immutable
class _$_MainPageQuery extends RouteQuery {
  const _$_MainPageQuery(this._path, {required this.title, this.q});

  final String title;

  final String? q;

  final String? _path;

  @override
  String get path => _path ?? _parameters;

  String get _parameters {
    final $q = <String, String>{};
    if (q?.toString().isNotEmpty ?? false) {
      $q["q"] = q!.toString();
    }
    return $q.isEmpty
        ? ""
        : "?${$q.entries.map((e) => "${e.key}=${e.value}").join("&")}";
  }

  @override
  String get name => "main";

  @override
  bool get hidden => false;

  @override
  TransitionQuery? get transition => null;

  @override
  E? key<E>() => null;

  @override
  W? widget<W extends Widget>() {
    final w = MainPage(title: title, q: q);
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
      builder: (context) => MainPage(title: title, q: q),
    );
  }
}

@immutable
class _$UserPageQuery extends RouteQueryBuilder {
  const _$UserPageQuery();

  static final _regExp = RegExp(r"^page/(?<user_id>[^/?&]+)$");

  @useResult
  RouteQuery call({required String userId}) =>
      _$_UserPageQuery(null, userId: userId);

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
      return _$_UserPageQuery(
        path,
        userId: match.namedGroup("user_id") ??
            query["userId"] ??
            query["user_id"] ??
            query["userId"] ??
            "",
      );
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_UserPageQuery(path, userId: match.namedGroup("user_id") ?? "");
    }
  }
}

@immutable
class _$_UserPageQuery extends RouteQuery {
  const _$_UserPageQuery(this._path, {required this.userId});

  final String userId;

  final String? _path;

  @override
  String get path => _path ?? "page/$userId$_parameters";

  String get _parameters {
    final $q = <String, String>{};
    return $q.isEmpty
        ? ""
        : "?${$q.entries.map((e) => "${e.key}=${e.value}").join("&")}";
  }

  @override
  String get name => "user";

  @override
  bool get hidden => false;

  @override
  TransitionQuery? get transition => null;

  @override
  E? key<E>() => null;

  @override
  W? widget<W extends Widget>() {
    final w = UserPage(userId: userId);
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
      builder: (context) => UserPage(userId: userId),
    );
  }
}

@immutable
class _$ContentPageQuery extends RouteQueryBuilder {
  const _$ContentPageQuery();

  static final _regExp = RegExp(r"^content/(?<content_id>[^/?&]+)$");

  @useResult
  RouteQuery call({required String contentId}) =>
      _$_ContentPageQuery(null, contentId: contentId);

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
      return _$_ContentPageQuery(
        path,
        contentId: match.namedGroup("content_id") ??
            query["contentId"] ??
            query["content_id"] ??
            query["contentId"] ??
            "",
      );
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_ContentPageQuery(
        path,
        contentId: match.namedGroup("content_id") ?? "",
      );
    }
  }
}

@immutable
class _$_ContentPageQuery extends RouteQuery {
  const _$_ContentPageQuery(this._path, {required this.contentId});

  final String contentId;

  final String? _path;

  @override
  String get path => _path ?? "content/$contentId$_parameters";

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
  TransitionQuery? get transition => null;

  @override
  E? key<E>() => null;

  @override
  W? widget<W extends Widget>() {
    final w = ContentPage(contentId: contentId);
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
      builder: (context) => ContentPage(contentId: contentId),
    );
  }
}

@immutable
class _$NestedContainerPageQuery extends RouteQueryBuilder {
  const _$NestedContainerPageQuery();

  static final _regExp = RegExp(r"^nested$");

  @useResult
  RouteQuery call() => _$_NestedContainerPageQuery(null);

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
      return _$_NestedContainerPageQuery(path);
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_NestedContainerPageQuery(path);
    }
  }
}

@immutable
class _$_NestedContainerPageQuery extends RouteQuery {
  const _$_NestedContainerPageQuery(this._path);

  final String? _path;

  @override
  String get path => _path ?? "nested$_parameters";

  String get _parameters {
    final $q = <String, String>{};
    return $q.isEmpty
        ? ""
        : "?${$q.entries.map((e) => "${e.key}=${e.value}").join("&")}";
  }

  @override
  String get name => "nested";

  @override
  bool get hidden => false;

  @override
  TransitionQuery? get transition => null;

  @override
  E? key<E>() => null;

  @override
  W? widget<W extends Widget>() {
    final w = NestedContainerPage();
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
      builder: (context) => NestedContainerPage(),
    );
  }
}

// **************************************************************************
// HiddenPageGenerator
// **************************************************************************

@immutable
class _$InnerPage1Query extends RouteQueryBuilder {
  const _$InnerPage1Query();

  @useResult
  RouteQuery call() => _$_InnerPage1Query(null);

  @override
  RouteQuery? resolve(String? path) {
    return null;
  }
}

@immutable
class _$_InnerPage1Query extends RouteQuery {
  const _$_InnerPage1Query(this._path);

  final String? _path;

  @override
  String get path =>
      _path ?? "201662f73f10593624c1b6c898df8767fc90b085$_parameters";

  String get _parameters {
    final $q = <String, String>{};
    return $q.isEmpty
        ? ""
        : "?${$q.entries.map((e) => "${e.key}=${e.value}").join("&")}";
  }

  @override
  String get name => path;

  @override
  bool get hidden => true;

  @override
  TransitionQuery? get transition => null;

  @override
  E? key<E>() => InnerPageType.type1 as E?;

  @override
  W? widget<W extends Widget>() {
    final w = InnerPage1();
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
      builder: (context) => InnerPage1(),
    );
  }
}

@immutable
class _$InnerPage2Query extends RouteQueryBuilder {
  const _$InnerPage2Query();

  @useResult
  RouteQuery call() => _$_InnerPage2Query(null);

  @override
  RouteQuery? resolve(String? path) {
    return null;
  }
}

@immutable
class _$_InnerPage2Query extends RouteQuery {
  const _$_InnerPage2Query(this._path);

  final String? _path;

  @override
  String get path =>
      _path ?? "26318fd13828503b957bad63061e1fc2d0bb4bfd$_parameters";

  String get _parameters {
    final $q = <String, String>{};
    return $q.isEmpty
        ? ""
        : "?${$q.entries.map((e) => "${e.key}=${e.value}").join("&")}";
  }

  @override
  String get name => path;

  @override
  bool get hidden => true;

  @override
  TransitionQuery? get transition => null;

  @override
  E? key<E>() => InnerPageType.type2 as E?;

  @override
  W? widget<W extends Widget>() {
    final w = InnerPage2();
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
      builder: (context) => InnerPage2(),
    );
  }
}
