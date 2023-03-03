part of masamune;

/// Create a sidebar for Universal UI.
///
/// Set to [UniversalScaffold.sidebar] in [UniversalScaffold].
///
/// When a [breakpoint] is set, the sidebar padding is switched to match the width of that [ResponsiveBreakpoint].
///
/// Universal UI用のサイドバーを作成します。
///
/// [UniversalScaffold]の[UniversalScaffold.sidebar]に設定してください。
///
/// [breakpoint]を設定すると、その[ResponsiveBreakpoint]の横幅に合わせてサイドバーのパディングが切り替わります。
class UniversalSideBar extends StatelessWidget with PreferredSizeWidget {
  /// Create a sidebar for Universal UI.
  ///
  /// Set to [UniversalScaffold.sidebar] in [UniversalScaffold].
  ///
  /// When a [breakpoint] is set, the sidebar padding is switched to match the width of that [ResponsiveBreakpoint].
  ///
  /// Universal UI用のサイドバーを作成します。
  ///
  /// [UniversalScaffold]の[UniversalScaffold.sidebar]に設定してください。
  ///
  /// [breakpoint]を設定すると、その[ResponsiveBreakpoint]の横幅に合わせてサイドバーのパディングが切り替わります。
  const UniversalSideBar({
    super.key,
    this.breakpoint,
    this.decoration,
    this.padding,
    this.child,
    this.paddingWhenNotFullWidth,
  }) : preferredSize = const Size.fromWidth(kSideBarWidth);

  /// Decoration] in the sidebar.
  ///
  /// サイドバーの[Decoration]。
  final Decoration? decoration;

  /// The sidebar padding switches to match the width of this [ResponsiveBreakpoint].
  ///
  /// この[ResponsiveBreakpoint]の横幅に合わせてサイドバーのパディングが切り替わります。
  final ResponsiveBreakpoint? breakpoint;

  /// Widget for the contents of the sidebar.
  ///
  /// サイドバーの中身のウィジェット。
  final Widget? child;

  /// Normal padding.
  ///
  /// 通常時のパディング。
  final EdgeInsetsGeometry? padding;

  /// [padding] when the width does not exceed [UniversalScaffold.breakpoint] and the width is fixed.If [Null], [padding] is used.
  ///
  /// 横幅が[UniversalScaffold.breakpoint]を超えない場合、横幅が固定されているときの[padding]。[Null]の場合は[padding]が利用されます。
  final EdgeInsetsGeometry? paddingWhenNotFullWidth;

  @override
  Widget build(BuildContext context) {
    final universal =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    final mainWidth =
        (breakpoint ?? universal?.defaultBreakpoint)?.width(context);
    return Container(
      padding: padding ??
          (mainWidth == double.infinity
              ? null
              : (paddingWhenNotFullWidth ??
                  universal?.defaultSidebarPaddingWhenNotFullWidth)),
      decoration: decoration,
      child: child,
    );
  }

  @override
  final Size preferredSize;
}
