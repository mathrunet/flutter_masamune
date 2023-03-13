part of masamune_universal_ui;

/// Default width of the sidebar.
///
/// サイドバーのデフォルトの横幅。
const kSideBarWidth = 240.0;

/// Create a sidebar for Universal UI.
///
/// Set to [UniversalScaffold.sidebar] in [UniversalScaffold].
///
/// When a [breakpoint] is set, the sidebar padding is switched to match the width of that [Breakpoint].
///
/// Universal UI用のサイドバーを作成します。
///
/// [UniversalScaffold]の[UniversalScaffold.sidebar]に設定してください。
///
/// [breakpoint]を設定すると、その[Breakpoint]の横幅に合わせてサイドバーのパディングが切り替わります。
class UniversalSideBar extends StatelessWidget with PreferredSizeWidget {
  /// Create a sidebar for Universal UI.
  ///
  /// Set to [UniversalScaffold.sidebar] in [UniversalScaffold].
  ///
  /// When a [breakpoint] is set, the sidebar padding is switched to match the width of that [Breakpoint].
  ///
  /// Universal UI用のサイドバーを作成します。
  ///
  /// [UniversalScaffold]の[UniversalScaffold.sidebar]に設定してください。
  ///
  /// [breakpoint]を設定すると、その[Breakpoint]の横幅に合わせてサイドバーのパディングが切り替わります。
  UniversalSideBar({
    super.key,
    this.breakpoint,
    this.decoration,
    this.padding,
    required this.children,
    this.paddingWhenNotFullWidth,
    this.width = kSideBarWidth,
  }) : preferredSize = Size.fromWidth(width);

  /// Width of sidebar.
  ///
  /// サイドバーの横幅。
  final double width;

  /// Decoration] in the sidebar.
  ///
  /// サイドバーの[Decoration]。
  final Decoration? decoration;

  /// The sidebar padding switches to match the width of this [Breakpoint].
  ///
  /// この[Breakpoint]の横幅に合わせてサイドバーのパディングが切り替わります。
  final Breakpoint? breakpoint;

  /// Widget for the contents of the sidebar.
  ///
  /// サイドバーの中身のウィジェット。
  final List<Widget> children;

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
      child: ListView.builder(
        primary: false,
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
        },
      ),
    );
  }

  @override
  final Size preferredSize;
}
