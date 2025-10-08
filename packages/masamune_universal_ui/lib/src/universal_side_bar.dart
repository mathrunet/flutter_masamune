part of "/masamune_universal_ui.dart";

/// Default width of the sidebar.
///
/// サイドバーのデフォルトの横幅。
const kSideBarWidth = 240.0;

/// Create a sidebar for Universal UI.
///
/// [UniversalSideBar] is a sidebar widget used with [UniversalScaffold]. It supports responsive padding and implements [PreferredSizeWidget].
/// Uses ListView.builder for efficient rendering of child widgets.
///
/// ## Basic Usage
///
/// ```dart
/// UniversalSideBar(
///   children: [
///     const ListTile(
///       leading: Icon(Icons.home),
///       title: Text("Home"),
///     ),
///     const ListTile(
///       leading: Icon(Icons.settings),
///       title: Text("Settings"),
///     ),
///     const ListTile(
///       leading: Icon(Icons.info),
///       title: Text("Info"),
///     ),
///   ],
/// );
/// ```
///
/// ---
///
/// Universal UI用のサイドバーを作成します。
///
/// [UniversalSideBar]は[UniversalScaffold]で使用するサイドバーウィジェットです。レスポンシブパディングに対応し、[PreferredSizeWidget]を実装しています。
/// ListView.builderで子ウィジェットを効率的に表示します。
///
/// ## 基本的な利用方法
///
/// ```dart
/// UniversalSideBar(
///   children: [
///     const ListTile(
///       leading: Icon(Icons.home),
///       title: Text("ホーム"),
///     ),
///     const ListTile(
///       leading: Icon(Icons.settings),
///       title: Text("設定"),
///     ),
///     const ListTile(
///       leading: Icon(Icons.info),
///       title: Text("情報"),
///     ),
///   ],
/// );
/// ```
class UniversalSideBar extends StatelessWidget implements PreferredSizeWidget {
  /// Create a sidebar for Universal UI.
  ///
  /// [UniversalSideBar] is a sidebar widget used with [UniversalScaffold]. It supports responsive padding and implements [PreferredSizeWidget].
  /// Uses ListView.builder for efficient rendering of child widgets.
  ///
  /// ## Basic Usage
  ///
  /// ```dart
  /// UniversalSideBar(
  ///   children: [
  ///     const ListTile(
  ///       leading: Icon(Icons.home),
  ///       title: Text("Home"),
  ///     ),
  ///     const ListTile(
  ///       leading: Icon(Icons.settings),
  ///       title: Text("Settings"),
  ///     ),
  ///     const ListTile(
  ///       leading: Icon(Icons.info),
  ///       title: Text("Info"),
  ///     ),
  ///   ],
  /// );
  /// ```
  ///
  /// ---
  ///
  /// Universal UI用のサイドバーを作成します。
  ///
  /// [UniversalSideBar]は[UniversalScaffold]で使用するサイドバーウィジェットです。レスポンシブパディングに対応し、[PreferredSizeWidget]を実装しています。
  /// ListView.builderで子ウィジェットを効率的に表示します。
  ///
  /// ## 基本的な利用方法
  ///
  /// ```dart
  /// UniversalSideBar(
  ///   children: [
  ///     const ListTile(
  ///       leading: Icon(Icons.home),
  ///       title: Text("ホーム"),
  ///     ),
  ///     const ListTile(
  ///       leading: Icon(Icons.settings),
  ///       title: Text("設定"),
  ///     ),
  ///     const ListTile(
  ///       leading: Icon(Icons.info),
  ///       title: Text("情報"),
  ///     ),
  ///   ],
  /// );
  /// ```
  UniversalSideBar({
    required this.children,
    super.key,
    this.breakpoint,
    this.decoration,
    this.padding,
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
