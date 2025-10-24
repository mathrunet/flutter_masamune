part of "/katana_ui.dart";

/// A container widget that groups multiple ListTile and LineTile widgets together.
///
/// This widget creates a visually grouped list of tiles with a shared background,
/// optional dividers between items, and customizable styling. Perfect for settings
/// screens, menu sections, and any UI requiring grouped list items.
///
/// Features:
/// - Groups multiple tiles with shared styling
/// - Optional dividers between tiles
/// - Customizable background color and border radius
/// - Adjustable margin and padding
/// - Theme-based default styling
/// - Auto-hides when children list is empty
///
/// Example:
/// ```dart
/// LineTileGroup(
///   divider: Divider(height: 1),
///   borderRadius: BorderRadius.circular(16),
///   children: [
///     ListTile(title: Text("Item 1")),
///     ListTile(title: Text("Item 2")),
///     ListTile(title: Text("Item 3")),
///   ],
/// )
/// ```
///
/// [ListTile]や[LineTile]をグループ化して表示するウィジェット。
///
/// このウィジェットは、共有の背景、オプションのアイテム間の区切り線、カスタマイズ可能な
/// スタイリングを持つ、視覚的にグループ化されたタイルのリストを作成します。
/// 設定画面、メニューセクション、グループ化されたリストアイテムを必要とする
/// あらゆるUIに最適です。
///
/// 特徴:
/// - 共有スタイリングで複数のタイルをグループ化
/// - タイル間のオプションの区切り線
/// - カスタマイズ可能な背景色と角丸
/// - 調整可能なマージンとパディング
/// - テーマベースのデフォルトスタイリング
/// - childrenリストが空の場合は自動的に非表示
///
/// 例:
/// ```dart
/// LineTileGroup(
///   divider: Divider(height: 1),
///   borderRadius: BorderRadius.circular(16),
///   children: [
///     ListTile(title: Text("アイテム1")),
///     ListTile(title: Text("アイテム2")),
///     ListTile(title: Text("アイテム3")),
///   ],
/// )
/// ```
class LineTileGroup extends StatelessWidget {
  /// A container widget that groups multiple ListTile and LineTile widgets together.
  ///
  /// This widget creates a visually grouped list of tiles with a shared background,
  /// optional dividers between items, and customizable styling. Perfect for settings
  /// screens, menu sections, and any UI requiring grouped list items.
  ///
  /// Features:
  /// - Groups multiple tiles with shared styling
  /// - Optional dividers between tiles
  /// - Customizable background color and border radius
  /// - Adjustable margin and padding
  /// - Theme-based default styling
  /// - Auto-hides when children list is empty
  ///
  /// Example:
  /// ```dart
  /// LineTileGroup(
  ///   divider: Divider(height: 1),
  ///   borderRadius: BorderRadius.circular(16),
  ///   children: [
  ///     ListTile(title: Text("Item 1")),
  ///     ListTile(title: Text("Item 2")),
  ///     ListTile(title: Text("Item 3")),
  ///   ],
  /// )
  /// ```
  ///
  /// [ListTile]や[LineTile]をグループ化して表示するウィジェット。
  ///
  /// このウィジェットは、共有の背景、オプションのアイテム間の区切り線、カスタマイズ可能な
  /// スタイリングを持つ、視覚的にグループ化されたタイルのリストを作成します。
  /// 設定画面、メニューセクション、グループ化されたリストアイテムを必要とする
  /// あらゆるUIに最適です。
  ///
  /// 特徴:
  /// - 共有スタイリングで複数のタイルをグループ化
  /// - タイル間のオプションの区切り線
  /// - カスタマイズ可能な背景色と角丸
  /// - 調整可能なマージンとパディング
  /// - テーマベースのデフォルトスタイリング
  /// - childrenリストが空の場合は自動的に非表示
  ///
  /// 例:
  /// ```dart
  /// LineTileGroup(
  ///   divider: Divider(height: 1),
  ///   borderRadius: BorderRadius.circular(16),
  ///   children: [
  ///     ListTile(title: Text("アイテム1")),
  ///     ListTile(title: Text("アイテム2")),
  ///     ListTile(title: Text("アイテム3")),
  ///   ],
  /// )
  /// ```
  const LineTileGroup({
    required this.children,
    super.key,
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
