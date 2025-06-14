part of "/katana_router.dart";

/// Defines how the page transitions.
///
/// ページのトランジション方法を定義します。
enum _TransitionQueryType {
  /// Default transitions.
  ///
  /// デフォルトのトランジション。
  initial(isModal: false, isFullscreen: false),

  /// No transitions.
  ///
  /// トランジションしない。
  none(isModal: false, isFullscreen: false, transitionDuration: Duration.zero),

  /// Full screen transition.
  ///
  /// フルスクリーントランジション。
  fullscreen(isModal: false, isFullscreen: true),

  /// Fade transitions.
  ///
  /// フェードトランジション。
  fade(isModal: false, isFullscreen: false),

  /// Cupertino transition.
  ///
  /// Cupertinoトランジション。
  cupertino(isCupertino: true, isModal: false, isFullscreen: false),

  /// Modal transition from the middle.
  ///
  /// The back page will be visible.
  ///
  /// 真ん中からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  centerModal(isModal: true, isFullscreen: true),

  /// Modal transitions from below.
  ///
  /// The back page will be visible.
  ///
  /// 下からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  bottomModal(isModal: true, isFullscreen: true),

  /// Modal transitions from left to right.
  ///
  /// The back page will be visible.
  ///
  /// 左からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  leftModal(isModal: true, isFullscreen: true),

  /// Modal transitions from right to left.
  ///
  /// The back page will be visible.
  ///
  /// 右からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  rightModal(isModal: true, isFullscreen: true),

  /// Modal transitions from left to right.
  ///
  /// The back page will be visible.
  ///
  /// 左からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  leftSheet(isModal: true, isFullscreen: true, barrierColor: Color(0x00000000)),

  /// Modal transitions from right to left.
  ///
  /// The back page will be visible.
  ///
  /// 右からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  rightSheet(
      isModal: true, isFullscreen: true, barrierColor: Color(0x00000000)),

  /// Modal transitions from below.
  ///
  /// The back page will be visible.
  ///
  /// 下からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  bottomSheet(
      isModal: true, isFullscreen: true, barrierColor: Color(0x00000000)),

  /// Modal transitions from below.
  ///
  /// Turns the background of the back page to black.
  ///
  /// 下からのモーダルトランジション。
  ///
  /// 裏のページが黒色背景に見えるようになります。
  bottomSheetWithBarrier(isModal: true, isFullscreen: true),

  /// Modal transition to fade.
  ///
  /// The back page will be visible.
  ///
  /// フェードするモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  fadeModal(isModal: true, isFullscreen: true);

  /// Defines how the page transitions.
  ///
  /// ページのトランジション方法を定義します。
  const _TransitionQueryType({
    required this.isModal,
    required this.isFullscreen,
    this.transitionDuration = kTransitionDuration,
    this.isCupertino = false,
    this.barrierColor = const Color(0x80000000),
  });

  /// True when using a modal.
  ///
  /// モーダルを利用する場合True。
  final bool isModal;

  /// True if using CupertinoPageRoute.
  ///
  /// CupertinoPageRouteを利用する場合はTrue。
  final bool isCupertino;

  /// True if treated as full screen.
  ///
  /// フルスクリーンとして扱う場合はTrue。
  final bool isFullscreen;

  /// Transition duration.
  ///
  /// トランジションの持続時間。
  final Duration transitionDuration;

  /// Barrier color.
  ///
  /// バリアの色。
  final Color barrierColor;

  /// Builder for creating transitions.
  ///
  /// Pass the parameters passed from PageBuilder to [context], [animation], and [secondaryAnimation] as is.
  ///
  /// Get widget to build with [child] or [builder].
  ///
  /// Pass the parameters passed to Router in [isAndroidBackEnable].
  ///
  /// トランジションを作成するためのビルダー。
  ///
  /// [context]、[animation]、[secondaryAnimation]にPageBuilderから渡されたパラメーターをそのまま渡します。
  ///
  /// [child]や[builder]でビルドするためのウィジェットを取得します。
  ///
  /// [isAndroidBackEnable]でRouterに渡されたパラメーターを渡してください。
  Widget build(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation, {
    Widget? child,
    WidgetBuilder? builder,
    bool isAndroidBackEnable = true,
  }) {
    switch (this) {
      case _TransitionQueryType.centerModal:
        return FadeTransition(
          opacity: _fadeTween.animate(animation),
          child: ScaleTransition(
            scale: _scaleTween.animate(animation),
            child: Material(
              type: MaterialType.transparency,
              child: PopScope(
                canPop: isAndroidBackEnable,
                child: Center(
                  child: builder?.call(context),
                ),
              ),
            ),
          ),
        );
      case _TransitionQueryType.bottomModal:
      case _TransitionQueryType.bottomSheet:
      case _TransitionQueryType.bottomSheetWithBarrier:
        return FadeTransition(
          opacity: _fadeTween.animate(animation),
          child: SlideTransition(
            position: _slideUpTween.animate(animation),
            child: Material(
              type: MaterialType.transparency,
              child: PopScope(
                canPop: isAndroidBackEnable,
                child: Center(
                  child: builder?.call(context),
                ),
              ),
            ),
          ),
        );
      case _TransitionQueryType.leftModal:
      case _TransitionQueryType.leftSheet:
        return FadeTransition(
          opacity: _fadeTween.animate(animation),
          child: SlideTransition(
            position: _slideRightTween.animate(animation),
            child: Material(
              type: MaterialType.transparency,
              child: PopScope(
                canPop: isAndroidBackEnable,
                child: Center(
                  child: builder?.call(context),
                ),
              ),
            ),
          ),
        );
      case _TransitionQueryType.rightModal:
      case _TransitionQueryType.rightSheet:
        return FadeTransition(
          opacity: _fadeTween.animate(animation),
          child: SlideTransition(
            position: _slideLeftTween.animate(animation),
            child: Material(
              type: MaterialType.transparency,
              child: PopScope(
                canPop: isAndroidBackEnable,
                child: Center(
                  child: builder?.call(context),
                ),
              ),
            ),
          ),
        );
      case _TransitionQueryType.fadeModal:
        return FadeTransition(
          opacity: _fadeTween.animate(animation),
          child: Material(
            type: MaterialType.transparency,
            child: PopScope(
              canPop: isAndroidBackEnable,
              child: Center(
                child: builder?.call(context),
              ),
            ),
          ),
        );
      default:
        if (this == _TransitionQueryType.none) {
          return child ?? const SizedBox.shrink();
        }
        if (kIsWeb) {
          if (this == _TransitionQueryType.fullscreen) {
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
        switch (this) {
          case _TransitionQueryType.none:
            return child ?? const SizedBox.shrink();
          case _TransitionQueryType.fullscreen:
            return SlideTransition(
              position: _slideUpTween.animate(animation),
              child: FadeTransition(
                opacity: _fadeTween.animate(animation),
                child: child,
              ),
            );
          case _TransitionQueryType.fade:
            return FadeTransition(
              opacity: _fadeTween.animate(animation),
              child: child,
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
    }
  }

  static final Animatable<Offset> _slideUpTween = Tween<Offset>(
    begin: const Offset(0.0, 0.25),
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
  static final Animatable<double> _scaleTween = Tween<double>(
    begin: 0.25,
    end: 1.0,
  ).chain(CurveTween(curve: Curves.fastOutSlowIn));
}
