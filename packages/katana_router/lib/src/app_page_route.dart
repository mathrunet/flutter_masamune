part of katana_router;

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
    LocalKey? key,
    required WidgetBuilder builder,
    required String? path,
    TransitionQuery? transitionQuery,
  }) {
    if (transitionQuery?.transition.modal ?? false) {
      return _ModalPageRoute(
        key: key ?? ValueKey(uuid),
        builder: builder,
        path: path,
        transitionQuery: transitionQuery,
      );
    } else {
      return _DefaultPageRoute(
        key: key ?? ValueKey(uuid),
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
    super.key,
    required this.builder,
    required String? path,
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

  static final Animatable<Offset> _slideUpTween = Tween<Offset>(
    begin: const Offset(0.0, 0.25),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
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
        switch (transitionQuery?.transition) {
          case _TransitionQueryType.bottomModal:
            return FadeTransition(
              opacity: _fadeTween.animate(animation),
              child: SlideTransition(
                position: _slideUpTween.animate(animation),
                child: Material(
                  type: MaterialType.transparency,
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
            );
          default:
            return FadeTransition(
              opacity: _fadeTween.animate(animation),
              child: ScaleTransition(
                scale: _scaleTween.animate(animation),
                child: Material(
                  type: MaterialType.transparency,
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
            );
        }
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
    this.transitionQuery,
  }) : super(name: path, arguments: transitionQuery);

  final WidgetBuilder builder;
  final TransitionQuery? transitionQuery;

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
      fullscreenDialog:
          transitionQuery?.transition == _TransitionQueryType.fullscreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        _TransitionType? rawTransitionType;
        if (transitionQuery?.transition == _TransitionQueryType.none) {
          return child;
        }
        if (kIsWeb) {
          if (transitionQuery?.transition == _TransitionQueryType.fullscreen) {
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
          switch (transitionQuery?.transition) {
            case _TransitionQueryType.fullscreen:
              return SlideTransition(
                position: _slideUpTween.animate(animation),
                child: FadeTransition(
                  opacity: _fadeTween.animate(animation),
                  child: child,
                ),
              );
            case _TransitionQueryType.fade:
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
