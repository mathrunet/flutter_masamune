part of "/katana_ui.dart";

/// A pill-shaped segmented tab bar that works like Flutter's [TabBar].
///
/// The selected tab is highlighted by a rounded indicator inside a rounded
/// track. Because it is built on [TabBar], it shares a [TabController] with a
/// [TabBarView], so the content can be switched by tapping a tab or by
/// swiping horizontally, and the indicator follows the swipe.
///
/// If [controller] is omitted, the nearest [DefaultTabController] is used.
///
/// Features:
/// - Pill-shaped indicator with a gradient
/// - Tap and swipe switching together with [TabBarView]
/// - Theme-based default colors
/// - Usable as [AppBar.bottom] via [PreferredSizeWidget]
///
/// Example:
/// ```dart
/// DefaultTabController(
///   length: 3,
///   child: Column(
///     children: [
///       const SegmentedTabBar(
///         tabs: [
///           Tab(text: "Stock"),
///           Tab(text: "Trading"),
///           Tab(text: "Favorite"),
///         ],
///       ),
///       Expanded(
///         child: TabBarView(
///           children: [
///             StockView(),
///             TradingView(),
///             FavoriteView(),
///           ],
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// Flutterの[TabBar]と同じように使えるピル型のセグメントタブバー。
///
/// 角丸のトラックの中で、選択中のタブを角丸のインジケーターで強調します。
/// [TabBar]をベースにしているため[TabBarView]と[TabController]を共有でき、
/// タブのタップだけでなく横スワイプでも内容を切り替えられ、
/// インジケーターもスワイプに追従します。
///
/// [controller]を省略した場合は最も近い[DefaultTabController]を利用します。
///
/// 特徴:
/// - グラデーション付きのピル型インジケーター
/// - [TabBarView]と組み合わせたタップ・スワイプでの切り替え
/// - テーマベースのデフォルト配色
/// - [PreferredSizeWidget]として[AppBar.bottom]にも配置可能
///
/// 例:
/// ```dart
/// DefaultTabController(
///   length: 3,
///   child: Column(
///     children: [
///       const SegmentedTabBar(
///         tabs: [
///           Tab(text: "所持銘柄"),
///           Tab(text: "取引中"),
///           Tab(text: "お気に入り"),
///         ],
///       ),
///       Expanded(
///         child: TabBarView(
///           children: [
///             StockView(),
///             TradingView(),
///             FavoriteView(),
///           ],
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
class SegmentedTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// A pill-shaped segmented tab bar that works like Flutter's [TabBar].
  ///
  /// The selected tab is highlighted by a rounded indicator inside a rounded
  /// track. Because it is built on [TabBar], it shares a [TabController] with
  /// a [TabBarView], so the content can be switched by tapping a tab or by
  /// swiping horizontally, and the indicator follows the swipe.
  ///
  /// If [controller] is omitted, the nearest [DefaultTabController] is used.
  ///
  /// Flutterの[TabBar]と同じように使えるピル型のセグメントタブバー。
  ///
  /// 角丸のトラックの中で、選択中のタブを角丸のインジケーターで強調します。
  /// [TabBar]をベースにしているため[TabBarView]と[TabController]を共有でき、
  /// タブのタップだけでなく横スワイプでも内容を切り替えられ、
  /// インジケーターもスワイプに追従します。
  ///
  /// [controller]を省略した場合は最も近い[DefaultTabController]を利用します。
  const SegmentedTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.onTap,
    this.height = 48.0,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(4.0),
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.borderRadius = 12.0,
    this.indicatorBorderRadius = 8.0,
    this.elevation = true,
  });

  /// The tabs to display. Usually a list of [Tab] widgets.
  ///
  /// 表示するタブ。通常は[Tab]のリストを渡します。
  final List<Widget> tabs;

  /// The controller shared with the [TabBarView].
  ///
  /// If `null`, the nearest [DefaultTabController] is used.
  ///
  /// [TabBarView]と共有するコントローラー。
  ///
  /// `null`の場合は最も近い[DefaultTabController]を利用します。
  final TabController? controller;

  /// Called when a tab is tapped.
  ///
  /// タブがタップされたときに呼ばれます。
  final ValueChanged<int>? onTap;

  /// The height of the track.
  ///
  /// トラックの高さ。
  final double height;

  /// The margin around the track.
  ///
  /// トラックの外側の余白。
  final EdgeInsets margin;

  /// The padding between the track and the indicator.
  ///
  /// トラックとインジケーターの間の余白。
  final EdgeInsets padding;

  /// The color of the track.
  ///
  /// Defaults to [ColorScheme.surface].
  ///
  /// トラックの色。
  ///
  /// デフォルトは[ColorScheme.surface]。
  final Color? backgroundColor;

  /// The color of the indicator.
  ///
  /// A gradient from this color to the same color with 80% opacity is drawn.
  /// Defaults to [ColorScheme.primary].
  ///
  /// インジケーターの色。
  ///
  /// この色から不透明度80%の同色へのグラデーションで描画されます。
  /// デフォルトは[ColorScheme.primary]。
  final Color? indicatorColor;

  /// The color of the selected tab label.
  ///
  /// Defaults to [ColorScheme.onPrimary].
  ///
  /// 選択中のタブのラベル色。
  ///
  /// デフォルトは[ColorScheme.onPrimary]。
  final Color? labelColor;

  /// The color of the unselected tab labels.
  ///
  /// Defaults to [ColorScheme.onSurface].
  ///
  /// 非選択のタブのラベル色。
  ///
  /// デフォルトは[ColorScheme.onSurface]。
  final Color? unselectedLabelColor;

  /// The text style of the selected tab label.
  ///
  /// 選択中のタブのラベルのテキストスタイル。
  final TextStyle? labelStyle;

  /// The text style of the unselected tab labels.
  ///
  /// 非選択のタブのラベルのテキストスタイル。
  final TextStyle? unselectedLabelStyle;

  /// The corner radius of the track.
  ///
  /// トラックの角丸の半径。
  final double borderRadius;

  /// The corner radius of the indicator.
  ///
  /// インジケーターの角丸の半径。
  final double indicatorBorderRadius;

  /// Whether to draw shadows under the track and the indicator.
  ///
  /// トラックとインジケーターに影を付けるかどうか。
  final bool elevation;

  @override
  Size get preferredSize => Size.fromHeight(height + margin.vertical);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = this.indicatorColor ?? colorScheme.primary;

    return Container(
      height: height,
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation
            ? [
                BoxShadow(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: false,
        padding: padding,
        dividerColor: Colors.transparent,
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        tabAlignment: TabAlignment.fill,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [indicatorColor, indicatorColor.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(indicatorBorderRadius),
          boxShadow: elevation
              ? [
                  BoxShadow(
                    color: indicatorColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        labelColor: labelColor ?? colorScheme.onPrimary,
        unselectedLabelColor: unselectedLabelColor ?? colorScheme.onSurface,
        labelStyle: labelStyle ?? const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: unselectedLabelStyle ??
            const TextStyle(fontWeight: FontWeight.w500),
        tabs: tabs,
      ),
    );
  }
}
