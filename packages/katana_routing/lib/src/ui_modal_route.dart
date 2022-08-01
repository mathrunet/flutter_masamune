part of katana_routing;

class UIModalRoute<T> extends PageRoute<T> {
  UIModalRoute({
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
