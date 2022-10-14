// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators

part of 'test.dart';

// **************************************************************************
// PageGenerator
// **************************************************************************

@immutable
class _$MainPageQuery extends PageQueryBuilder {
  const _$MainPageQuery();

  static final _regExp = RegExp(r"^$");

  _$_MainPageQuery call({
    Key? key,
    required String title,
  }) =>
      _$_MainPageQuery(key: key, title: title);
  @override
  PageQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_MainPageQuery(
        key: null,
        title: match?.groupNames.contains("title") ?? false
            ? match?.namedGroup("title") ?? ""
            : "");
  }
}

@immutable
class _$_MainPageQuery extends PageQuery {
  const _$_MainPageQuery({
    this.key,
    required this.title,
  });

  final Key? key;

  final String title;

  @override
  String get path => "";
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  PageRouteQuery<T> route<T>([RouteQuery? query]) {
    return PageRouteQuery<T>(
      path: path,
      routeQuery: query,
      builder: (context) => MainPage(key: key, title: title),
      transition: query?.transition ?? RouteQueryType.initial,
    );
  }
}

@immutable
class _$UserPageQuery extends PageQueryBuilder {
  const _$UserPageQuery();

  static final _regExp = RegExp(r"^page/(?<user_id>[^/?&]+)$");

  _$_UserPageQuery call({
    Key? key,
    required String userId,
  }) =>
      _$_UserPageQuery(key: key, userId: userId);
  @override
  PageQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_UserPageQuery(
        key: null,
        userId: match?.groupNames.contains("userId") ?? false
            ? match?.namedGroup("userId") ?? ""
            : "");
  }
}

@immutable
class _$_UserPageQuery extends PageQuery {
  const _$_UserPageQuery({
    this.key,
    required this.userId,
  });

  final Key? key;

  final String userId;

  @override
  String get path => "page/$userId";
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  PageRouteQuery<T> route<T>([RouteQuery? query]) {
    return PageRouteQuery<T>(
      path: path,
      routeQuery: query,
      builder: (context) => UserPage(key: key, userId: userId),
      transition: query?.transition ?? RouteQueryType.initial,
    );
  }
}

@immutable
class _$ContentPageQuery extends PageQueryBuilder {
  const _$ContentPageQuery();

  static final _regExp = RegExp(r"^content/(?<content_id>[^/?&]+)$");

  _$_ContentPageQuery call({
    Key? key,
    required String contentId,
  }) =>
      _$_ContentPageQuery(key: key, contentId: contentId);
  @override
  PageQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_ContentPageQuery(
        key: null,
        contentId: match?.groupNames.contains("contentId") ?? false
            ? match?.namedGroup("contentId") ?? ""
            : "");
  }
}

@immutable
class _$_ContentPageQuery extends PageQuery {
  const _$_ContentPageQuery({
    this.key,
    required this.contentId,
  });

  final Key? key;

  final String contentId;

  @override
  String get path => "content/$contentId";
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  PageRouteQuery<T> route<T>([RouteQuery? query]) {
    return PageRouteQuery<T>(
      path: path,
      routeQuery: query,
      builder: (context) => ContentPage(key: key, contentId: contentId),
      transition: query?.transition ?? RouteQueryType.initial,
    );
  }
}
