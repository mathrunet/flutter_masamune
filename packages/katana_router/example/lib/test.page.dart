// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering

part of 'test.dart';

// **************************************************************************
// PageGenerator
// **************************************************************************

@immutable
class _$MainPage extends RouteQueryBuilder {
  const _$MainPage();

  static final _regExp = RegExp(r"^$");

  _$_MainPage call({required String title}) => _$_MainPage(title: title);
  @override
  RouteQuery? resolve(String? path) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null) {
      return null;
    }
    return _$_MainPage(
        title: match.groupNames.contains("title")
            ? match.namedGroup("title") ?? ""
            : "");
  }
}

@immutable
class _$_MainPage extends RouteQuery {
  const _$_MainPage({required this.title});

  final String title;

  @override
  String get path => "";
  @override
  E? key<E>() => null;
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) {
    return AppPageRoute<E>(
      path: path,
      transitionQuery: query,
      builder: (context) => MainPage(title: title),
    );
  }
}

@immutable
class _$UserPage extends RouteQueryBuilder {
  const _$UserPage();

  static final _regExp = RegExp(r"^page/(?<user_id>[^/?&]+)$");

  _$_UserPage call({required String userId}) => _$_UserPage(userId: userId);
  @override
  RouteQuery? resolve(String? path) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null) {
      return null;
    }
    return _$_UserPage(
        userId: match.groupNames.contains("userId")
            ? match.namedGroup("userId") ?? ""
            : "");
  }
}

@immutable
class _$_UserPage extends RouteQuery {
  const _$_UserPage({required this.userId});

  final String userId;

  @override
  String get path => "page/$userId";
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
      _$_ContentPage(contentId: contentId);
  @override
  RouteQuery? resolve(String? path) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null) {
      return null;
    }
    return _$_ContentPage(
        contentId: match.groupNames.contains("contentId")
            ? match.namedGroup("contentId") ?? ""
            : "");
  }
}

@immutable
class _$_ContentPage extends RouteQuery {
  const _$_ContentPage({required this.contentId});

  final String contentId;

  @override
  String get path => "content/$contentId";
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

  _$_NestedContainerPage call() => _$_NestedContainerPage();
  @override
  RouteQuery? resolve(String? path) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null) {
      return null;
    }
    return _$_NestedContainerPage();
  }
}

@immutable
class _$_NestedContainerPage extends RouteQuery {
  const _$_NestedContainerPage();

  @override
  String get path => "nested";
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

  _$_InnerPage1 call() => _$_InnerPage1();
  @override
  RouteQuery? resolve(String? path) {
    return null;
  }
}

@immutable
class _$_InnerPage1 extends RouteQuery {
  const _$_InnerPage1();

  @override
  String get path => "f1dc93be452044309aff3087c79014c0";
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

  _$_InnerPage2 call() => _$_InnerPage2();
  @override
  RouteQuery? resolve(String? path) {
    return null;
  }
}

@immutable
class _$_InnerPage2 extends RouteQuery {
  const _$_InnerPage2();

  @override
  String get path => "018ba130d8b846be825c962c2f4c8cf0";
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
