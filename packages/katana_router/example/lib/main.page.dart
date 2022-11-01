// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, unused_local_variable

part of 'main.dart';

// **************************************************************************
// PageGenerator
// **************************************************************************

@immutable
class _$MainPage extends RouteQueryBuilder {
  const _$MainPage();

  static final _regExp = RegExp(r"^$");

  _$_MainPage call({
    required String title,
    String? q,
  }) =>
      _$_MainPage(null, title: title, q: q);
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
      return _$_MainPage(path,
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
      return _$_MainPage(path,
          title: match.groupNames.contains("title")
              ? match.namedGroup("title") ?? ""
              : "",
          q: null);
    }
  }
}

@immutable
class _$_MainPage extends RouteQuery {
  const _$_MainPage(
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
class _$UserPage extends RouteQueryBuilder {
  const _$UserPage();

  static final _regExp = RegExp(r"^page/(?<user_id>[^/?&]+)$");

  _$_UserPage call({required String userId}) =>
      _$_UserPage(null, userId: userId);
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
      return _$_UserPage(path,
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
      return _$_UserPage(path,
          userId: match.groupNames.contains("userId")
              ? match.namedGroup("userId") ?? ""
              : "");
    }
  }
}

@immutable
class _$_UserPage extends RouteQuery {
  const _$_UserPage(
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
class _$ContentPage extends RouteQueryBuilder {
  const _$ContentPage();

  static final _regExp = RegExp(r"^content/(?<content_id>[^/?&]+)$");

  _$_ContentPage call({required String contentId}) =>
      _$_ContentPage(null, contentId: contentId);
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
      return _$_ContentPage(path,
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
      return _$_ContentPage(path,
          contentId: match.groupNames.contains("contentId")
              ? match.namedGroup("contentId") ?? ""
              : "");
    }
  }
}

@immutable
class _$_ContentPage extends RouteQuery {
  const _$_ContentPage(
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
class _$NestedContainerPage extends RouteQueryBuilder {
  const _$NestedContainerPage();

  static final _regExp = RegExp(r"^nested$");

  _$_NestedContainerPage call() => _$_NestedContainerPage(
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
      return _$_NestedContainerPage(
        path,
      );
    } else {
      path = path.trimQuery().trimString("/");
      final match = _regExp.firstMatch(path.trimQuery().trimString("/"));
      if (match == null) {
        return null;
      }
      return _$_NestedContainerPage(
        path,
      );
    }
  }
}

@immutable
class _$_NestedContainerPage extends RouteQuery {
  const _$_NestedContainerPage(this._path);

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
class _$InnerPage1 extends RouteQueryBuilder {
  const _$InnerPage1();

  _$_InnerPage1 call() => _$_InnerPage1(
        null,
      );
  @override
  RouteQuery? resolve(String? path) {
    return null;
  }
}

@immutable
class _$_InnerPage1 extends RouteQuery {
  const _$_InnerPage1(this._path);

  final String? _path;

  @override
  String get path => _path ?? "ca5cbaca4a04450c818e2827e694b681";
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
class _$InnerPage2 extends RouteQueryBuilder {
  const _$InnerPage2();

  _$_InnerPage2 call() => _$_InnerPage2(
        null,
      );
  @override
  RouteQuery? resolve(String? path) {
    return null;
  }
}

@immutable
class _$_InnerPage2 extends RouteQuery {
  const _$_InnerPage2(this._path);

  final String? _path;

  @override
  String get path => _path ?? "26eff80aa228425aa8a5cd24f10a8f50";
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
