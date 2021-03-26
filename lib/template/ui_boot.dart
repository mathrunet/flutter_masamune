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
abstract class UIBoot extends PageHookWidget {
  /// Abstract class for creating boot pages.
  ///
  /// [key]: Widget key.
  const UIBoot({Key? key}) : super(key: key);

  /// Indicator color.
  ///
  /// If null, the color will be gradation.
  Color? get indicatorColor => null;

  /// Feature image.
  ///
  /// If you register it, this is the only one displayed.
  ImageProvider? get featureImage => null;

  /// Feature widget.
  ///
  /// If you register it, this is the only one displayed.
  Widget? get featureWidget => null;

  /// Background color.
  Color? get backgroundColor => null;

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context) {
    return applySafeArea ? SafeArea(child: _body(context)) : _body(context);
  }

  Widget _body(BuildContext context) {
    final image = featureImage;
    if (image != null) {
      return ColoredBox(
        color: backgroundColor ?? context.theme.backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: image,
              fit: BoxFit.contain,
            ),
          ],
        ),
      );
    }
    final widget = featureWidget;
    if (widget != null) {
      return Container(
        color: backgroundColor ?? context.theme.backgroundColor,
        alignment: Alignment.center,
        child: widget,
      );
    }
    // return Container(
    //   color: backgroundColor ?? context.theme.backgroundColor,
    //   child: UIAnimatedBuilder(
    //     animator: UIAnimatorScenario([
    //       UIAnimatorUnit(
    //         animatable: Tween<double>(begin: 150, end: 100),
    //         from: const Duration(milliseconds: 0),
    //         to: const Duration(milliseconds: 2500),
    //         curve: Curves.easeInOutQuint,
    //         tag: "size",
    //       ),
    //       UIAnimatorUnit(
    //         animatable: Tween<double>(begin: 100, end: 150),
    //         from: const Duration(milliseconds: 2500),
    //         to: const Duration(milliseconds: 5000),
    //         curve: Curves.easeInOutQuint,
    //         tag: "size",
    //       ),
    //       UIAnimatorUnit(
    //         animatable: ColorTween(
    //           begin: indicatorColor ?? Colors.red,
    //           end: indicatorColor ?? Colors.purple,
    //         ),
    //         from: const Duration(seconds: 0),
    //         to: const Duration(seconds: 1),
    //         tag: "color",
    //       ),
    //       UIAnimatorUnit(
    //         animatable: ColorTween(
    //           begin: indicatorColor ?? Colors.purple,
    //           end: indicatorColor ?? Colors.blue,
    //         ),
    //         from: const Duration(seconds: 2),
    //         to: const Duration(seconds: 3),
    //         tag: "color",
    //       ),
    //       UIAnimatorUnit(
    //         animatable: ColorTween(
    //           begin: indicatorColor ?? Colors.blue,
    //           end: indicatorColor ?? Colors.purple,
    //         ),
    //         from: const Duration(seconds: 4),
    //         to: const Duration(seconds: 5),
    //         tag: "color",
    //       ),
    //       UIAnimatorUnit(
    //         animatable: ColorTween(
    //           begin: indicatorColor ?? Colors.purple,
    //           end: indicatorColor ?? Colors.red,
    //         ),
    //         from: const Duration(seconds: 8),
    //         to: const Duration(seconds: 10),
    //         tag: "color",
    //       )
    //     ])
    //       ..playRepeat(),
    //     builder: (context, child, animator) {
    //       return LoadingBouncingGrid.circle(
    //         size: animator.attr("size", defaultValue: 0),
    //         backgroundColor: animator.attr(
    //           "color",
    //           defaultValue: indicatorColor ?? Colors.red,
    //         ),
    //       );
    //     },
    //   ),
    // );
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
