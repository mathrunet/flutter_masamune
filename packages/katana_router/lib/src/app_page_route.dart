part of "/katana_router.dart";

/// Duration of page transitions.
///
/// ページトランジションのデュレーション。
const kTransitionDuration = Duration(milliseconds: 300);

/// Default [PageRoute].
///
/// You can start the next page by returning a widget for the new page with `builder`.
///
/// You can define page transitions by specifying `transition`.
///
/// You can specify [RouteSettings] to move to the next page in `settings`.
///
/// デフォルトの[PageRoute]。
///
/// `builder`で新しいページのウィジェットを返すことで次のページを起動することができます。
///
/// `transition`を指定することでページのトランジションを定義できます。
///
/// `settings`に次のページに移るための[RouteSettings]を指定できます。
abstract class AppPageRoute<T> extends Page<T> {
  /// Default [PageRoute].
  ///
  /// You can start the next page by returning a widget for the new page with `builder`.
  ///
  /// You can define page transitions by specifying `transition`.
  ///
  /// You can specify [RouteSettings] to move to the next page in `settings`.
  ///
  /// デフォルトの[PageRoute]。
  ///
  /// `builder`で新しいページのウィジェットを返すことで次のページを起動することができます。
  ///
  /// `transition`を指定することでページのトランジションを定義できます。
  ///
  /// `settings`に次のページに移るための[RouteSettings]を指定できます。
  factory AppPageRoute({
    required WidgetBuilder builder,
    required String? path,
    AppRouter? router,
    LocalKey? key,
    TransitionQuery? transitionQuery,
  }) {
    if (transitionQuery?.transition.isModal ?? false) {
      return _ModalPageRoute(
        key: key ?? ValueKey(uuid()),
        builder: builder,
        path: path,
        transitionQuery: transitionQuery,
        barrierColor:
            transitionQuery?.transition.barrierColor ?? const Color(0x80000000),
      );
    } else if (transitionQuery?.transition.isCupertino ?? false) {
      return _CupertinoPageRoute(
        key: key ?? ValueKey(uuid()),
        builder: builder,
        path: path,
        transitionQuery: transitionQuery,
      );
    } else {
      return _DefaultPageRoute(
        key: key ?? ValueKey(uuid()),
        builder: builder,
        path: path,
        transitionQuery: transitionQuery,
      );
    }
  }
}

@immutable
class _ModalPageRoute<T> extends Page<T> implements AppPageRoute<T> {
  const _ModalPageRoute({
    required this.builder,
    required String? path,
    super.key,
    this.transitionQuery,
    this.isAndroidBackEnable = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor = const Color(0x80000000),
    this.barrierLabel,
    this.maintainState = true,
  }) : super(name: path, arguments: transitionQuery);

  final WidgetBuilder builder;
  final bool isAndroidBackEnable;
  final Duration transitionDuration;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool maintainState;
  final TransitionQuery? transitionQuery;

  @override
  Route<T> createRoute(BuildContext context) {
    final router = AppRouteScope.maybeOf(context)?.router;
    return _PageRouteBuilder(
      settings: this,
      router: router,
      transitionDuration:
          transitionQuery?.transition.transitionDuration ?? kTransitionDuration,
      reverseTransitionDuration:
          transitionQuery?.transition.transitionDuration ?? kTransitionDuration,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: transitionQuery?.transition.isFullscreen ?? true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return (transitionQuery?.transition ?? _TransitionQueryType.initial)
            .build(
          context,
          animation,
          secondaryAnimation,
          builder: builder,
          isAndroidBackEnable: isAndroidBackEnable,
        );
      },
    );
  }
}

@immutable
class _DefaultPageRoute<T> extends Page<T> implements AppPageRoute<T> {
  const _DefaultPageRoute({
    required this.builder,
    required String? path,
    super.key,
    this.transitionQuery,
  }) : super(name: path, arguments: transitionQuery);

  final WidgetBuilder builder;
  final TransitionQuery? transitionQuery;

  @override
  Route<T> createRoute(BuildContext context) {
    final router = AppRouteScope.maybeOf(context)?.router;
    return _PageRouteBuilder(
      settings: this,
      router: router,
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      transitionDuration:
          transitionQuery?.transition.transitionDuration ?? kTransitionDuration,
      reverseTransitionDuration:
          transitionQuery?.transition.transitionDuration ?? kTransitionDuration,
      fullscreenDialog: transitionQuery?.transition.isFullscreen ?? false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return (transitionQuery?.transition ?? _TransitionQueryType.initial)
            .build(
          context,
          animation,
          secondaryAnimation,
          child: child,
        );
      },
    );
  }
}

@immutable
class _CupertinoPageRoute<T> extends Page<T> implements AppPageRoute<T> {
  const _CupertinoPageRoute({
    required this.builder,
    required String? path,
    this.router,
    super.key,
    this.transitionQuery,
  }) : super(name: path, arguments: transitionQuery);

  final AppRouter? router;
  final WidgetBuilder builder;
  final TransitionQuery? transitionQuery;

  @override
  Route<T> createRoute(BuildContext context) {
    final router = AppRouteScope.maybeOf(context)?.router;
    return _CupertinoPageRouteBuilder(
      settings: this,
      builder: builder,
      router: router,
    );
  }
}

class _PageRouteBuilder<T> extends PageRouteBuilder<T> {
  _PageRouteBuilder({
    required super.pageBuilder,
    super.settings,
    super.requestFocus,
    super.transitionsBuilder = _defaultTransitionsBuilder,
    super.transitionDuration = const Duration(milliseconds: 300),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    super.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    this.router,
  });

  final AppRouter? router;

  static Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }

  @override
  @mustCallSuper
  void onPopInvokedWithResult(bool didPop, T? result) {
    super.onPopInvokedWithResult(didPop, result);
    if (didPop && settings is Page<T>) {
      router?._removeWith(settings as Page<T>);
    }
  }
}

class _CupertinoPageRouteBuilder<T> extends CupertinoPageRoute<T> {
  _CupertinoPageRouteBuilder({
    required super.builder,
    super.title,
    super.settings,
    super.requestFocus,
    super.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
    this.router,
  });

  final AppRouter? router;

  @override
  @mustCallSuper
  void onPopInvokedWithResult(bool didPop, T? result) {
    super.onPopInvokedWithResult(didPop, result);
    if (didPop && settings is Page<T>) {
      router?._removeWith(settings as Page<T>);
    }
  }
}
