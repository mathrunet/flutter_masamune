part of masamune;

class PlatformScrollbar extends StatelessWidget {
  const PlatformScrollbar({
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (Config.isMobile) {
      return child;
    } else {
      return Scrollbar(
        isAlwaysShown: true,
        child: child,
      );
    }
  }
}
