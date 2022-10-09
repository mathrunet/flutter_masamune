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
abstract class PageRouteQuery<T> extends PageRoute<T> {
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
  factory PageRouteQuery({
    required WidgetBuilder builder,
    RouteQueryType transition = RouteQueryType.initial,
    RouteSettings? settings,
  }) {
    if (transition == RouteQueryType.modal) {
      return _ModalPageRoute(
        builder: builder,
        settings: settings,
      );
    } else {
      return _DefaultPageRoute(
        builder: builder,
        transition: transition,
        settings: settings,
      );
    }
  }
}

class _ModalPageRoute<T> extends PageRoute<T> implements PageRouteQuery<T> {
  _ModalPageRoute({
    required this.builder,
    this.isAndroidBackEnable = true,
    required RouteSettings? settings,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor = const Color(0x80000000),
    this.barrierLabel,
    this.maintainState = true,
  }) : super(settings: settings, fullscreenDialog: true);

  final WidgetBuilder builder;
  final bool isAndroidBackEnable;
  @override
  final Duration transitionDuration;
  @override
  final bool opaque;
  @override
  final bool barrierDismissible;
  @override
  final Color? barrierColor;
  @override
  final String? barrierLabel;
  @override
  final bool maintainState;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
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
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: _fadeTween.animate(animation),
      child: ScaleTransition(
        scale: _scaleTween.animate(animation),
        child: child,
      ),
    );
  }

  static final Animatable<double> _scaleTween = Tween<double>(
    begin: 0.25,
    end: 1.0,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
  static final Animatable<double> _fadeTween = Tween<double>(
    begin: 0,
    end: 1,
  ).chain(CurveTween(curve: Curves.easeIn));
}

class _DefaultPageRoute<T> extends PageRouteBuilder<T>
    implements PageRouteQuery<T> {
  _DefaultPageRoute({
    required WidgetBuilder builder,
    RouteQueryType transition = RouteQueryType.initial,
    RouteSettings? settings,
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
          transitionDuration: kTransitionDuration,
          reverseTransitionDuration: kTransitionDuration,
          fullscreenDialog: transition == RouteQueryType.fullscreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            _TransitionType? rawTransitionType;
            if (transition == RouteQueryType.none) {
              return child;
            }
            if (kIsWeb) {
              if (transition == RouteQueryType.fullscreen) {
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
                case RouteQueryType.fullscreen:
                  return SlideTransition(
                    position: _slideUpTween.animate(animation),
                    child: FadeTransition(
                      opacity: _fadeTween.animate(animation),
                      child: child,
                    ),
                  );
                case RouteQueryType.fade:
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
}

enum _TransitionType {
  none,
  fade,
  slideToLeft,
  slideToRight,
  slideToUp,
  slideToDown
}
