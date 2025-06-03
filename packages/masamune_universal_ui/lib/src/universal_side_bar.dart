part of "/masamune_universal_ui.dart";

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
class UniversalSideBar extends StatelessWidget implements PreferredSizeWidget {
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

  @override
  Widget build(BuildContext context) {
    final universal =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    return Container(
      padding: ResponsiveEdgeInsets._responsive(
        context,
        padding ?? universal?.defaultSidebarPadding,
        breakpoint: breakpoint,
      ),
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
