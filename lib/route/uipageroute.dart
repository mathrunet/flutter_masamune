part of masamune;

/// Page route to perform ui animation.
class UIPageRoute extends PageRouteBuilder {
  /// Route path.
  final String path;

  /// Page route to perform ui animation.
  ///
  /// [path]: Route path.
  /// [builder]: Widget builder.
  /// [settings]: Route settings.
  /// [transition]: Transition type.
  UIPageRoute(
      {this.path,
      WidgetBuilder builder,
      PageTransition transition = PageTransition.initial,
      RouteSettings settings,
      TransitionType transitionType})
      : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
          fullscreenDialog: transition == PageTransition.fullscreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (transition == PageTransition.none) {
              return child;
            }
            if (Config.isWeb) {
              if (transition == PageTransition.fullscreen) {
                return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child);
              } else {
                return FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: child);
              }
            }
            if (transitionType == null) {
              switch (transition) {
                case PageTransition.fullscreen:
                  return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child);
                case PageTransition.fade:
                  transitionType = TransitionType.fade;
                  break;
                default:
                  transitionType = TransitionType.slideToLeft;
                  break;
              }
            }
            switch (transitionType) {
              case TransitionType.none:
                return FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: child);
              case TransitionType.fade:
                return FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: child);
              case TransitionType.slideToRight:
                return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1, 0),
                    ).animate(animation),
                    child: child);
              case TransitionType.slideToUp:
                return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child);
              case TransitionType.slideToDown:
                return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0, 1),
                    ).animate(animation),
                    child: child);
              default:
                return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child);
            }
          },
        );
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
