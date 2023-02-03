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
  _$_MainPageQuery call({
    required String title,
    String? q,
  }) =>
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
      return _$_MainPageQuery(path,
          title: match.groupNames.contains("title")
              ? match.namedGroup("title") ??
                  (query.containsKey("title") ? query["title"] ?? "" : "")
              : (query.containsKey("title") ? query["title"] ?? "" : ""),
          q: (query.containsKey("q") ? query["q"] ?? null : null));
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_MainPageQuery(path,
          title: match.groupNames.contains("title")
              ? match.namedGroup("title") ?? ""
              : "",
          q: null);
    }
  }
}

@immutable
class _$_MainPageQuery extends RouteQuery {
  const _$_MainPageQuery(
    this._path, {
    required this.title,
    this.q,
  });

  final String title;

  final String? q;

  final String? _path;

  @override
  String get path => _path ?? "";
  @override
  String get name => "main";
  @override
  E? key<E>() => null;
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query,
      builder: (context) => MainPage(title: title, q: q),
    );
  }
}

@immutable
class _$UserPageQuery extends RouteQueryBuilder {
  const _$UserPageQuery();

  static final _regExp = RegExp(r"^page/(?<user_id>[^/?&]+)$");

  @useResult
  _$_UserPageQuery call({required String userId}) =>
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
      return _$_UserPageQuery(path,
          userId: match.groupNames.contains("userId")
              ? match.namedGroup("userId") ??
                  (query.containsKey("userId") ? query["userId"] ?? "" : "")
              : (query.containsKey("userId") ? query["userId"] ?? "" : ""));
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_UserPageQuery(path,
          userId: match.groupNames.contains("userId")
              ? match.namedGroup("userId") ?? ""
              : "");
    }
  }
}

@immutable
class _$_UserPageQuery extends RouteQuery {
  const _$_UserPageQuery(
    this._path, {
    required this.userId,
  });

  final String userId;

  final String? _path;

  @override
  String get path => _path ?? "page/$userId";
  @override
  String get name => "user";
  @override
  E? key<E>() => null;
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query,
      builder: (context) => UserPage(userId: userId),
    );
  }
}

@immutable
class _$ContentPageQuery extends RouteQueryBuilder {
  const _$ContentPageQuery();

  static final _regExp = RegExp(r"^content/(?<content_id>[^/?&]+)$");

  @useResult
  _$_ContentPageQuery call({required String contentId}) =>
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
      return _$_ContentPageQuery(path,
          contentId: match.groupNames.contains("contentId")
              ? match.namedGroup("contentId") ??
                  (query.containsKey("contentId")
                      ? query["contentId"] ?? ""
                      : "")
              : (query.containsKey("contentId")
                  ? query["contentId"] ?? ""
                  : ""));
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_ContentPageQuery(path,
          contentId: match.groupNames.contains("contentId")
              ? match.namedGroup("contentId") ?? ""
              : "");
    }
  }
}

@immutable
class _$_ContentPageQuery extends RouteQuery {
  const _$_ContentPageQuery(
    this._path, {
    required this.contentId,
  });

  final String contentId;

  final String? _path;

  @override
  String get path => _path ?? "content/$contentId";
  @override
  String get name => path;
  @override
  E? key<E>() => null;
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query,
      builder: (context) => ContentPage(contentId: contentId),
    );
  }
}

@immutable
class _$NestedContainerPageQuery extends RouteQueryBuilder {
  const _$NestedContainerPageQuery();

  static final _regExp = RegExp(r"^nested$");

  @useResult
  _$_NestedContainerPageQuery call() => _$_NestedContainerPageQuery(
        null,
      );
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
      return _$_NestedContainerPageQuery(
        path,
      );
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_NestedContainerPageQuery(
        path,
      );
    }
  }
}

@immutable
class _$_NestedContainerPageQuery extends RouteQuery {
  const _$_NestedContainerPageQuery(this._path);

  final String? _path;

  @override
  String get path => _path ?? "nested";
  @override
  String get name => "nested";
  @override
  E? key<E>() => null;
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query,
      builder: (context) => NestedContainerPage(),
    );
  }
}

// **************************************************************************
// NestedPageGenerator
// **************************************************************************

@immutable
class _$InnerPage1Query extends RouteQueryBuilder {
  const _$InnerPage1Query();

  @useResult
  _$_InnerPage1Query call() => _$_InnerPage1Query(
        null,
      );
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
  String get path => _path ?? "201662f73f10593624c1b6c898df8767fc90b085";
  @override
  String get name => path;
  @override
  E? key<E>() => InnerPageType.type1 as E?;
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query,
      builder: (context) => InnerPage1(),
    );
  }
}

@immutable
class _$InnerPage2Query extends RouteQueryBuilder {
  const _$InnerPage2Query();

  @useResult
  _$_InnerPage2Query call() => _$_InnerPage2Query(
        null,
      );
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
  String get path => _path ?? "26318fd13828503b957bad63061e1fc2d0bb4bfd";
  @override
  String get name => path;
  @override
  E? key<E>() => InnerPageType.type2 as E?;
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query,
      builder: (context) => InnerPage2(),
    );
  }
}
