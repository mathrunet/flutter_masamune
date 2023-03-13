part of masamune_universal_ui;

class UniversalMasamuneAdapter extends MasamuneAdapter {
  const UniversalMasamuneAdapter({
    this.defaultBreakpoint = Breakpoint.sm,
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

  final Breakpoint defaultBreakpoint;
  final EdgeInsetsGeometry defaultBodyPaddingWhenNotFullWidth;
  final EdgeInsetsGeometry defaultSidebarPaddingWhenNotFullWidth;
}
