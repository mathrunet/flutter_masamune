part of masamune;

const double kPlatformThreshold = 768;

class PlatformBuilder extends StatelessWidget {
  const PlatformBuilder({
    this.mobile,
    this.desktop,
    this.thresholdWidth = kPlatformThreshold,
    this.defaultWidget = const Empty(),
  }) : assert(
          mobile != null || desktop != null,
          "You need to specify either [mobile] or [desktop].",
        );

  final double thresholdWidth;
  final Widget? mobile;
  final Widget? desktop;
  final Widget defaultWidget;

  @override
  Widget build(BuildContext context) {
    if (isMobile(context, thresholdWidth: kPlatformThreshold)) {
      return mobile ?? desktop ?? defaultWidget;
    } else {
      return desktop ?? mobile ?? defaultWidget;
    }
  }
}

class PlatformScrollbar extends StatelessWidget {
  const PlatformScrollbar({
    required this.child,
    this.thresholdWidth = kPlatformThreshold,
  });

  final Widget child;
  final double thresholdWidth;
  @override
  Widget build(BuildContext context) {
    if (isMobile(context, thresholdWidth: kPlatformThreshold)) {
      return child;
    } else {
      return Scrollbar(
        isAlwaysShown: true,
        child: child,
      );
    }
  }
}

class PlatformModalView extends StatelessWidget {
  const PlatformModalView({
    required this.child,
    this.thresholdWidth = kPlatformThreshold,
    this.width,
    this.widthRatio,
    this.height,
    this.heightRatio,
    this.close,
  });
  final Widget child;
  final double thresholdWidth;
  final double? widthRatio;
  final double? heightRatio;
  final double? width;
  final double? height;
  final Widget? close;
  @override
  Widget build(BuildContext context) {
    if (isMobile(context, thresholdWidth: kPlatformThreshold)) {
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

bool isMobile(
  BuildContext context, {
  double thresholdWidth = kPlatformThreshold,
}) {
  if (Config.isAndroid || Config.isIOS) {
    return true;
  }
  final width = context.mediaQuery.size.width;
  if (width < thresholdWidth) {
    return true;
  }
  return false;
}
