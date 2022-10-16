part of katana_router;

/// Duration of page transitions.
/// ページトランジションのデュレーション。
const kTransitionDuration = Duration(milliseconds: 300);

/// Default [PageRoute].
/// デフォルトの[PageRoute]。
///
/// You can start the next page by returning a widget for the new page with `builder`.
/// `builder`で新しいページのウィジェットを返すことで次のページを起動することができます。
///
/// You can define page transitions by specifying `transition`.
/// `transition`を指定することでページのトランジションを定義できます。
///
/// You can specify [RouteSettings] to move to the next page in `settings`.
/// `settings`に次のページに移るための[RouteSettings]を指定できます。
abstract class AppPageRoute<T> extends Page<T> {
  /// Default [PageRoute].
  /// デフォルトの[PageRoute]。
  ///
  /// You can start the next page by returning a widget for the new page with `builder`.
  /// `builder`で新しいページのウィジェットを返すことで次のページを起動することができます。
  ///
  /// You can define page transitions by specifying `transition`.
  /// `transition`を指定することでページのトランジションを定義できます。
  ///
  /// You can specify [RouteSettings] to move to the next page in `settings`.
  /// `settings`に次のページに移るための[RouteSettings]を指定できます。
  factory AppPageRoute({
    LocalKey? key,
    required WidgetBuilder builder,
    required String? path,
    TransitionQuery? routeQuery,
    TransitionQueryType transition = TransitionQueryType.initial,
  }) {
    if (transition == TransitionQueryType.modal) {
      return _ModalPageRoute(
        key: key ?? ValueKey(path),
        builder: builder,
        path: path,
        routeQuery: routeQuery,
      );
    } else {
      return _DefaultPageRoute(
        key: key ?? ValueKey(path),
        builder: builder,
        transition: transition,
        path: path,
        routeQuery: routeQuery,
      );
    }
  }
}

@immutable
class _ModalPageRoute<T> extends Page<T> implements AppPageRoute<T> {
  const _ModalPageRoute({
    super.key,
    required this.builder,
    required String? path,
    TransitionQuery? routeQuery,
    this.isAndroidBackEnable = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor = const Color(0x80000000),
    this.barrierLabel,
    this.maintainState = true,
  }) : super(name: path, arguments: routeQuery);

  final WidgetBuilder builder;
  final bool isAndroidBackEnable;
  final Duration transitionDuration;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool maintainState;

  static final Animatable<double> _scaleTween = Tween<double>(
    begin: 0.25,
    end: 1.0,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
  static final Animatable<double> _fadeTween = Tween<double>(
    begin: 0,
    end: 1,
  ).chain(CurveTween(curve: Curves.easeIn));

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: transitionDuration,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: _fadeTween.animate(animation),
          child: ScaleTransition(
            scale: _scaleTween.animate(animation),
            child: Material(
              type: MaterialType.transparency,
              child: SafeArea(
                child: WillPopScope(
                  onWillPop: () async {
                    return isAndroidBackEnable;
                  },
                  child: Center(
                    child: builder(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

@immutable
class _DefaultPageRoute<T> extends Page<T> implements AppPageRoute<T> {
  const _DefaultPageRoute({
    super.key,
    required this.builder,
    required String? path,
    TransitionQuery? routeQuery,
    this.transition = TransitionQueryType.initial,
  }) : super(name: path, arguments: routeQuery);

  final WidgetBuilder builder;
  final TransitionQueryType transition;

  static final Animatable<Offset> _slideUpTween = Tween<Offset>(
    begin: const Offset(0.0, 0.25),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
  static final Animatable<Offset> _slideDownTween = Tween<Offset>(
    begin: const Offset(0.0, -0.25),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
  static final Animatable<Offset> _slideLeftTween = Tween<Offset>(
    begin: const Offset(0.25, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
  static final Animatable<Offset> _slideRightTween = Tween<Offset>(
    begin: const Offset(-0.25, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
  static final Animatable<double> _fadeTween = Tween<double>(
    begin: 0,
    end: 1,
  ).chain(CurveTween(curve: Curves.easeIn));

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      transitionDuration: kTransitionDuration,
      reverseTransitionDuration: kTransitionDuration,
      fullscreenDialog: transition == TransitionQueryType.fullscreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        _TransitionType? rawTransitionType;
        if (transition == TransitionQueryType.none) {
          return child;
        }
        if (kIsWeb) {
          if (transition == TransitionQueryType.fullscreen) {
            return SlideTransition(
              position: _slideUpTween.animate(animation),
              child: FadeTransition(
                opacity: _fadeTween.animate(animation),
                child: child,
              ),
            );
          } else {
            return FadeTransition(
              opacity: _fadeTween.animate(animation),
              child: child,
            );
          }
        }
        if (rawTransitionType == null) {
          switch (transition) {
            case TransitionQueryType.fullscreen:
              return SlideTransition(
                position: _slideUpTween.animate(animation),
                child: FadeTransition(
                  opacity: _fadeTween.animate(animation),
                  child: child,
                ),
              );
            case TransitionQueryType.fade:
              rawTransitionType = _TransitionType.fade;
              break;
            default:
              rawTransitionType = _TransitionType.slideToLeft;
              break;
          }
        }
        switch (rawTransitionType) {
          case _TransitionType.none:
            return FadeTransition(
              opacity: _fadeTween.animate(animation),
              child: child,
            );
          case _TransitionType.fade:
            return FadeTransition(
              opacity: _fadeTween.animate(animation),
              child: child,
            );
          case _TransitionType.slideToRight:
            return SlideTransition(
              position: _slideRightTween.animate(animation),
              child: FadeTransition(
                opacity: _fadeTween.animate(animation),
                child: child,
              ),
            );
          case _TransitionType.slideToUp:
            return SlideTransition(
              position: _slideUpTween.animate(animation),
              child: FadeTransition(
                opacity: _fadeTween.animate(animation),
                child: child,
              ),
            );
          case _TransitionType.slideToDown:
            return SlideTransition(
              position: _slideDownTween.animate(animation),
              child: FadeTransition(
                opacity: _fadeTween.animate(animation),
                child: child,
              ),
            );
          default:
            return SlideTransition(
              position: _slideLeftTween.animate(animation),
              child: FadeTransition(
                opacity: _fadeTween.animate(animation),
                child: child,
              ),
            );
        }
      },
    );
  }
}

enum _TransitionType {
  none,
  fade,
  slideToLeft,
  slideToRight,
  slideToUp,
  slideToDown
}
