part of katana_routing;

/// Transition duration.
const kTransitionDuration = Duration(milliseconds: 300);

/// Page route to perform ui animation.
class UIPageRoute<T> extends PageRouteBuilder<T> {
  /// Page route to perform ui animation.
  UIPageRoute({
    required WidgetBuilder builder,
    PageTransition transition = PageTransition.initial,
    RouteSettings? settings,
    TransitionType? rawTransitionType,
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
          transitionDuration: kTransitionDuration,
          reverseTransitionDuration: kTransitionDuration,
          fullscreenDialog: transition == PageTransition.fullscreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (transition == PageTransition.none) {
              return child;
            }
            if (kIsWeb) {
              if (transition == PageTransition.fullscreen) {
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
                case PageTransition.fullscreen:
                  return SlideTransition(
                    position: _slideUpTween.animate(animation),
                    child: FadeTransition(
                      opacity: _fadeTween.animate(animation),
                      child: child,
                    ),
                  );
                case PageTransition.fade:
                  rawTransitionType = TransitionType.fade;
                  break;
                default:
                  rawTransitionType = TransitionType.slideToLeft;
                  break;
              }
            }
            switch (rawTransitionType) {
              case TransitionType.none:
                return FadeTransition(
                  opacity: _fadeTween.animate(animation),
                  child: child,
                );
              case TransitionType.fade:
                return FadeTransition(
                  opacity: _fadeTween.animate(animation),
                  child: child,
                );
              case TransitionType.slideToRight:
                return SlideTransition(
                  position: _slideRightTween.animate(animation),
                  child: FadeTransition(
                    opacity: _fadeTween.animate(animation),
                    child: child,
                  ),
                );
              case TransitionType.slideToUp:
                return SlideTransition(
                  position: _slideUpTween.animate(animation),
                  child: FadeTransition(
                    opacity: _fadeTween.animate(animation),
                    child: child,
                  ),
                );
              case TransitionType.slideToDown:
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

/// Defines the transition type.
enum TransitionType {
  /// None.
  none,

  /// Fade.
  fade,

  /// Left.
  slideToLeft,

  /// Right.
  slideToRight,

  /// Up.
  slideToUp,

  /// Down.
  slideToDown
}
