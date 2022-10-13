// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators

part of 'test.dart';

// **************************************************************************
// PageGenerator
// **************************************************************************

@immutable
class _$MainPageQuery extends PageQueryBuilder {
  const _$MainPageQuery();

  static final _regExp = RegExp(r"^$");

  _$_MainPageQuery call() => _$_MainPageQuery();
  @override
  PageQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_MainPageQuery();
  }
}

@immutable
class _$_MainPageQuery extends PageQuery {
  const _$_MainPageQuery();

  @override
  String get path => "";
  @override
  List<RedirectQuery> redirect() => const [];
  @override
  PageRouteQuery<T> route<T>([RouteQuery? query]) {
    return PageRouteQuery<T>(
      path: path,
      routeQuery: query,
      builder: (context) {
        return _MainPage();
      },
      transition: query?.transition ?? RouteQueryType.initial,
    );
  }
}

@immutable
class $MainPage {
  const $MainPage();

  $MainPage copyWith() {
    return $MainPage();
  }

  @override
  int get hashCode => super.hashCode;
  @override
  bool operator ==(Object other) => super.hashCode == hashCode;
}

@immutable
class _MainPage extends MainPage {
  const _MainPage() : super._();

  @override
  $MainPage create() {
    return $MainPage();
  }

  @override
  _MainPageState createState() => _MainPageState();
}

@immutable
abstract class _$MainPage extends PageWidgetBuilder<$MainPage> {
  const _$MainPage();

  @override
  $MainPage create() => throw UnimplementedError();
}

class _MainPageState extends PageWidgetBuilderState<$MainPage, _MainPage> {}

@immutable
class _$UserPageQuery extends PageQueryBuilder {
  const _$UserPageQuery();

  static final _regExp = RegExp(r"^page/(?<userId>[^/?&]+)$");

  _$_UserPageQuery call({required String userId}) =>
      _$_UserPageQuery(userId: userId);
  @override
  PageQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_UserPageQuery(userId: match?.namedGroup("userId") ?? "");
  }
}

@immutable
class _$_UserPageQuery extends PageQuery {
  const _$_UserPageQuery({required this.userId});

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
      builder: (context) {
        return _UserPage(userId: userId);
      },
      transition: query?.transition ?? RouteQueryType.initial,
    );
  }
}

@immutable
class $UserPage {
  const $UserPage({required this.userId});

  final String userId;

  $UserPage copyWith({String? userId}) {
    return $UserPage(userId: userId ?? this.userId);
  }

  @override
  int get hashCode => userId.hashCode;
  @override
  bool operator ==(Object other) => super.hashCode == hashCode;
}

@immutable
class _UserPage extends UserPage {
  const _UserPage({required String userId})
      : _userId = userId,
        super._();

  final String _userId;

  @override
  $UserPage create() {
    return $UserPage(userId: _userId);
  }

  @override
  _UserPageState createState() => _UserPageState();
}

@immutable
abstract class _$UserPage extends PageWidgetBuilder<$UserPage> {
  const _$UserPage();

  @override
  $UserPage create() => throw UnimplementedError();
}

class _UserPageState extends PageWidgetBuilderState<$UserPage, _UserPage> {}

@immutable
class _$ContentPageQuery extends PageQueryBuilder {
  const _$ContentPageQuery();

  static final _regExp = RegExp(r"^content/(?<contentId>[^/?&]+)$");

  _$_ContentPageQuery call({required String contentId}) =>
      _$_ContentPageQuery(contentId: contentId);
  @override
  PageQuery? resolve(
    String? path, {
    bool force = false,
  }) {
    final match = _regExp.firstMatch(path?.trimQuery().trimString("/") ?? "");
    if (match == null && !force) {
      return null;
    }
    return _$_ContentPageQuery(contentId: match?.namedGroup("contentId") ?? "");
  }
}

@immutable
class _$_ContentPageQuery extends PageQuery {
  const _$_ContentPageQuery({required this.contentId});

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
      builder: (context) {
        return _ContentPage(contentId: contentId);
      },
      transition: query?.transition ?? RouteQueryType.initial,
    );
  }
}

@immutable
class $ContentPage {
  const $ContentPage({required this.contentId});

  final String contentId;

  $ContentPage copyWith({String? contentId}) {
    return $ContentPage(contentId: contentId ?? this.contentId);
  }

  @override
  int get hashCode => contentId.hashCode;
  @override
  bool operator ==(Object other) => super.hashCode == hashCode;
}

@immutable
class _ContentPage extends ContentPage {
  const _ContentPage({required String contentId})
      : _contentId = contentId,
        super._();

  final String _contentId;

  @override
  $ContentPage create() {
    return $ContentPage(contentId: _contentId);
  }

  @override
  _ContentPageState createState() => _ContentPageState();
}

@immutable
abstract class _$ContentPage extends PageWidgetBuilder<$ContentPage> {
  const _$ContentPage();

  @override
  $ContentPage create() => throw UnimplementedError();
}

class _ContentPageState
    extends PageWidgetBuilderState<$ContentPage, _ContentPage> {}
