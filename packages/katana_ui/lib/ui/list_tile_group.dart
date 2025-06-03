part of "/katana_ui.dart";

/// A widget that groups [ListTile] and [LineTile] for display.
///
/// Specify each tile in [children].
///
/// [ListTile]や[LineTile]をグループ化して表示するウィジェット。
///
/// [children]にそれぞれのタイルを指定します。
class LineTileGroup extends StatelessWidget {
  /// A widget that groups [ListTile] and [LineTile] for display.
  ///
  /// Specify each tile in [children].
  ///
  /// [ListTile]や[LineTile]をグループ化して表示するウィジェット。
  ///
  /// [children]にそれぞれのタイルを指定します。
  const LineTileGroup({
    super.key,
    required this.children,
    this.shape,
    this.tileColor,
    this.divider,
    this.borderRadius,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  /// Shape of the tile.
  ///
  /// タイルの形。
  final ShapeBorder? shape;

  /// Radius of rounded tile corners.
  ///
  /// タイルの角丸の半径。
  final BorderRadiusGeometry? borderRadius;

  /// List of [ListTile] to be displayed.
  ///
  /// 表示する[ListTile]のリスト。
  final List<Widget> children;

  /// Color of the tile.
  ///
  /// タイルの色。
  final Color? tileColor;

  /// Divider to be displayed between tiles.
  ///
  /// タイル間に表示される区切り線。
  final Widget? divider;

  /// Margin of the tile.
  ///
  /// タイルのマージン。
  final EdgeInsetsGeometry margin;

  /// Content Padding.
  ///
  /// コンテンツのパディング。
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return _LineTileGroupScope(
      tileColor: tileColor,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          color: tileColor ?? Theme.of(context).colorScheme.surface,
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: divider != null
              ? children.insertEvery(divider!, 1).toList()
              : children,
        ),
      ),
    );
  }
}

/// A widget that groups [ListTile] and [LineTile] for display.
///
/// Specify each tile in [children].
///
/// [ListTile]や[LineTile]をグループ化して表示するウィジェット。
///
/// [children]にそれぞれのタイルを指定します。
typedef ListTileGroup = LineTileGroup;

class _LineTileGroupScope extends InheritedWidget {
  const _LineTileGroupScope({
    required super.child,
    this.tileColor,
  });

  final Color? tileColor;

  static _LineTileGroupScope? of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<_LineTileGroupScope>()
        ?.widget as _LineTileGroupScope?;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
