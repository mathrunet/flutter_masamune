part of masamune;

class UniversalMasamuneAdapter extends MasamuneAdapter {
  const UniversalMasamuneAdapter({
    this.defaultBreakpoint = ResponsiveBreakpoint.sm,
    this.defaultBodyPaddingWhenNotFullWidth =
        const EdgeInsets.symmetric(vertical: kToolbarHeight),
    this.defaultSidebarPaddingWhenNotFullWidth =
        const EdgeInsets.symmetric(vertical: kToolbarHeight),
  });

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<UniversalMasamuneAdapter>(
        adapter: this, onInit: onInitScope, child: app);
  }

  final ResponsiveBreakpoint defaultBreakpoint;
  final EdgeInsetsGeometry defaultBodyPaddingWhenNotFullWidth;
  final EdgeInsetsGeometry defaultSidebarPaddingWhenNotFullWidth;
}
