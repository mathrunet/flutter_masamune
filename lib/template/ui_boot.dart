part of masamune;

/// Abstract class for creating boot pages.
///
/// It is inherited and used by the class that displays the page.
///
/// Scaffold is built in by default, and the provided method is overridden and used.
///
/// Normally, please override body.
///
/// Please inherit and use.
abstract class UIBoot extends PageScopedWidget {
  /// Abstract class for creating boot pages.
  ///
  /// [key]: Widget key.
  const UIBoot({Key? key}) : super(key: key);

  /// The process executed at initialization.
  @protected
  void onInit(BuildContext context, WidgetRef ref, BuildContext root) {}

  /// Indicator color.
  ///
  /// If null, the color will be gradation.
  @protected
  Color? get indicatorColor => null;

  /// Feature image.
  ///
  /// If you register it, this is the only one displayed.
  @protected
  ImageProvider? get featureImage => null;

  /// Feature widget.
  ///
  /// If you register it, this is the only one displayed.
  @protected
  Widget? get featureWidget => null;

  /// Background color.
  @protected
  Color? get backgroundColor => null;

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.effect(onInitOrUpdate: () {
      onInit(context, ref, context.navigator.context);
    });
    return applySafeArea
        ? SafeArea(
            child: _body(context, ref),
          )
        : _body(context, ref);
  }

  Widget _body(BuildContext context, WidgetRef ref) {
    final config = context.app?.bootConfig;
    final image = config != null &&
            config.designType == BootDesignType.logo &&
            config.logoPath.isNotEmpty
        ? NetworkOrAsset.image(config.logoPath, ImageSize.medium)
        : featureImage;
    if (image != null) {
      return ColoredBox(
        color: config?.backgroundColor ??
            backgroundColor ??
            context.theme.backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (config?.logoSize != null)
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: config!.logoSize!.width,
                  height: config.logoSize!.height,
                  child: ClipRRect(
                    borderRadius: config.logoBorderRadius ?? BorderRadius.zero,
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: config?.logoBorderRadius ?? BorderRadius.zero,
                child: Image(
                  image: image,
                  fit: BoxFit.contain,
                ),
              )
          ],
        ),
      );
    }
    final widget =
        config != null && config.designType == BootDesignType.indicator
            ? CircularProgressIndicator(
                backgroundColor: config.backgroundColor,
                color: config.color,
              )
            : featureWidget;
    if (widget != null) {
      return Container(
        color: config?.backgroundColor ??
            backgroundColor ??
            context.theme.backgroundColor,
        alignment: Alignment.center,
        child: widget,
      );
    }
    return ColoredBox(
      color: config?.backgroundColor ??
          backgroundColor ??
          context.theme.backgroundColor,
      child: AnimationScope(
        animation: ref.useAutoRepeatAnimationScenario(
          r"_$boot",
          [
            AnimationUnit(
              tween: DoubleTween(begin: 150, end: 100),
              from: const Duration(milliseconds: 0),
              to: const Duration(milliseconds: 2500),
              curve: Curves.easeInOutQuint,
              tag: "size",
            ),
            AnimationUnit(
              tween: DoubleTween(begin: 100, end: 150),
              from: const Duration(milliseconds: 2500),
              to: const Duration(milliseconds: 5000),
              curve: Curves.easeInOutQuint,
              tag: "size",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.red,
                end: config?.color ?? indicatorColor ?? Colors.purple,
              ),
              from: const Duration(seconds: 0),
              to: const Duration(seconds: 1),
              tag: "color",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.purple,
                end: config?.color ?? indicatorColor ?? Colors.blue,
              ),
              from: const Duration(seconds: 2),
              to: const Duration(seconds: 3),
              tag: "color",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.blue,
                end: config?.color ?? indicatorColor ?? Colors.purple,
              ),
              from: const Duration(seconds: 4),
              to: const Duration(seconds: 5),
              tag: "color",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.purple,
                end: config?.color ?? indicatorColor ?? Colors.red,
              ),
              from: const Duration(seconds: 8),
              to: const Duration(seconds: 10),
              tag: "color",
            )
          ],
        ),
        builder: (context, child, animator) {
          return LoadingBouncingGrid.circle(
            size: animator.get("size", 0),
            backgroundColor: animator.get(
              "color",
              config?.color ?? indicatorColor ?? Colors.red,
            ),
          );
        },
      ),
    );
  }
}
