part of masamune;

class PlatformBuilder extends StatelessWidget {
  const PlatformBuilder({
    this.mobile,
    this.desktop,
    this.defaultWidget = const Empty(),
  }) : assert(
          mobile != null || desktop != null,
          "You need to specify either [mobile] or [desktop].",
        );

  final Widget? mobile;
  final Widget? desktop;
  final Widget defaultWidget;

  @override
  Widget build(BuildContext context) {
    if (Config.isMobile) {
      return mobile ?? desktop ?? defaultWidget;
    } else {
      return desktop ?? mobile ?? defaultWidget;
    }
  }
}
