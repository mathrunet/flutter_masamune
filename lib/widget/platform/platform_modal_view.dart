part of masamune;

class PlatformModalView extends StatelessWidget {
  const PlatformModalView({
    required this.child,
    this.width,
    this.widthRatio,
    this.height,
    this.heightRatio,
    this.close,
  });
  final Widget child;
  final double? widthRatio;
  final double? heightRatio;
  final double? width;
  final double? height;
  final Widget? close;
  @override
  Widget build(BuildContext context) {
    if (Config.isMobile) {
      return child;
    } else {
      final size = context.mediaQuery.size;
      final w = width ??
          (widthRatio != null ? (size.width * (widthRatio ?? 1.0)) : null);
      final h = height ??
          (heightRatio != null ? (size.height * (heightRatio ?? 1.0)) : null);
      if (close != null) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: close,
            ),
            SizedBox(
              width: w,
              height: h,
              child: child,
            )
          ],
        );
      } else {
        return SizedBox(
          width: w,
          height: h,
          child: child,
        );
      }
    }
  }
}
