// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering

part of 'test.dart';

// **************************************************************************
// PageGenerator
// **************************************************************************

@immutable
class _$MainPage extends RouteQueryBuilder {
  const _$MainPage();

  static final _regExp = RegExp(r"^$");

  _$_MainPage call({
    Key? key,
    required String title,
  }) =>
      _$_MainPage(key: key, title: title);
  @override
  RouteQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_MainPage(
        key: null,
        title: match?.groupNames.contains("title") ?? false
            ? match?.namedGroup("title") ?? ""
            : "");
  }
}

@immutable
class _$_MainPage extends RouteQuery {
  const _$_MainPage({
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
  AppPageRoute<T> route<T>([TransitionQuery? query]) {
    return AppPageRoute<T>(
      path: path,
      transitionQuery: query,
      builder: (context) => MainPage(key: key, title: title),
    );
  }
}

@immutable
class _$UserPage extends RouteQueryBuilder {
  const _$UserPage();

  static final _regExp = RegExp(r"^page/(?<user_id>[^/?&]+)$");

  _$_UserPage call({
    Key? key,
    required String userId,
  }) =>
      _$_UserPage(key: key, userId: userId);
  @override
  RouteQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_UserPage(
        key: null,
        userId: match?.groupNames.contains("userId") ?? false
            ? match?.namedGroup("userId") ?? ""
            : "");
  }
}

@immutable
class _$_UserPage extends RouteQuery {
  const _$_UserPage({
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
  AppPageRoute<T> route<T>([TransitionQuery? query]) {
    return AppPageRoute<T>(
      path: path,
      transitionQuery: query,
      builder: (context) => UserPage(key: key, userId: userId),
    );
  }
}

@immutable
class _$ContentPage extends RouteQueryBuilder {
  const _$ContentPage();

  static final _regExp = RegExp(r"^content/(?<content_id>[^/?&]+)$");

  _$_ContentPage call({
    Key? key,
    required String contentId,
  }) =>
      _$_ContentPage(key: key, contentId: contentId);
  @override
  RouteQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_ContentPage(
        key: null,
        contentId: match?.groupNames.contains("contentId") ?? false
            ? match?.namedGroup("contentId") ?? ""
            : "");
  }
}

@immutable
class _$_ContentPage extends RouteQuery {
  const _$_ContentPage({
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
  AppPageRoute<T> route<T>([TransitionQuery? query]) {
    return AppPageRoute<T>(
      path: path,
      transitionQuery: query,
      builder: (context) => ContentPage(key: key, contentId: contentId),
    );
  }
}
