part of masamune.ui;

class UIScrollbar extends StatelessWidget {
  const UIScrollbar({
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (Config.isMobile) {
      return child;
    } else {
      return Scrollbar(
        thumbVisibility: true,
        child: child,
      );
    }
  }
}
