part of "main.dart";

// **************************************************************************
// PageGenerator
// **************************************************************************

class _$UserPageQuery {
  const _$UserPageQuery();
  _$_UserPageQuery call({required String userId}) =>
      _$_UserPageQuery(userId: userId);
}

class _$_UserPageQuery extends PageQuery {
  const _$_UserPageQuery({required this.userId});

  final String userId;
  @override
  String get path => "/user/$userId";

  @override
  PageRouteQuery<T> route<T>(RouteQuery? query) {
    return PageRouteQuery<T>(
      builder: (context) {
        return _UserPage(userId: userId);
      },
      transition: query?.transition ?? RouteQueryType.initial,
      settings: RouteSettings(
        name: path,
        arguments: {
          "userId": userId,
        },
      ),
    );
  }
}

@immutable
class $UserPage {
  const $UserPage({
    required this.userId,
  });

  final String userId;

  $UserPage copyWith({
    String? userId,
  }) {
    return $UserPage(
      userId: userId ?? this.userId,
    );
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  bool operator ==(Object other) => super.hashCode == hashCode;
}

class _UserPage extends UserPage with CreatorHandlerMixin {
  const _UserPage({
    required String userId,
  })  : _userId = userId,
        super._();

  final String _userId;

  @override
  $UserPage create() {
    return $UserPage(
      userId: convertHandler(_userId),
    );
  }

  @override
  State<_UserPage> createState() => _UserPageState();
}

abstract class _$UserPage extends PageWidgetBuilder<$UserPage> {
  const _$UserPage();

  @override
  $UserPage create() => throw UnimplementedError();
}

class _UserPageState extends PageWidgetBuilderState<$UserPage, _UserPage> {}

class _$ContentPageQuery {
  const _$ContentPageQuery();
  _$_ContentPageQuery call({required String contentId}) =>
      _$_ContentPageQuery(contentId: contentId);
}

class _$_ContentPageQuery extends PageQuery {
  const _$_ContentPageQuery({required this.contentId});

  final String contentId;
  @override
  String get path => "/content/$contentId";

  @override
  PageRouteQuery<T> route<T>(RouteQuery? query) {
    return PageRouteQuery<T>(
      builder: (context) {
        return _ContentPage(contentId: contentId);
      },
      transition: query?.transition ?? RouteQueryType.initial,
      settings: RouteSettings(
        name: path,
        arguments: {
          "contentId": contentId,
        },
      ),
    );
  }
}

@immutable
class $ContentPage {
  const $ContentPage({
    required this.contentId,
  });

  final String contentId;

  $ContentPage copyWith({
    String? contentId,
  }) {
    return $ContentPage(
      contentId: contentId ?? this.contentId,
    );
  }

  @override
  int get hashCode => contentId.hashCode;

  @override
  bool operator ==(Object other) => super.hashCode == hashCode;
}

class _ContentPage extends ContentPage with CreatorHandlerMixin {
  const _ContentPage({
    required String contentId,
  })  : _contentId = contentId,
        super._();

  final String _contentId;

  @override
  $ContentPage create() {
    return $ContentPage(
      contentId: convertHandler(_contentId),
    );
  }

  @override
  State<_ContentPage> createState() => _ContentPageState();
}

abstract class _$ContentPage extends PageWidgetBuilder<$ContentPage> {
  const _$ContentPage();

  @override
  $ContentPage create() => throw UnimplementedError();
}

class _ContentPageState
    extends PageWidgetBuilderState<$ContentPage, _ContentPage> {}

mixin CreatorHandlerMixin {
  dynamic convertHandler(Object? o) {
    if (o is Creator) {
      return o.create();
    }
    return o;
  }
}

abstract class Creator<T> {
  T create();
}
