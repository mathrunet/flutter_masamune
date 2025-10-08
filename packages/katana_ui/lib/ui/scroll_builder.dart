part of "/katana_ui.dart";

/// A builder widget that adds RefreshIndicator and Scrollbar to scrollable widgets.
///
/// This widget simplifies adding pull-to-refresh and scrollbar functionality
/// to ListView or SingleChildScrollView. Perfect for list views with refresh
/// capability and desktop/web scrollbar support.
///
/// Features:
/// - Easy pull-to-refresh integration
/// - Platform-specific scrollbar (desktop/web)
/// - Automatic ScrollController management
/// - Custom ScrollController support
/// - Interactive scrollbar with visibility controls
/// - Simple builder pattern
///
/// Example:
/// ```dart
/// ScrollBuilder(
///   onRefresh: () async {
///     await refreshData();
///   },
///   showScrollbarWhenDesktopOrWeb: true,
///   builder: (context, controller) {
///     return ListView.builder(
///       controller: controller,
///       itemCount: items.length,
///       itemBuilder: (context, index) {
///         return ListTile(
///           title: Text(items[index].title),
///         );
///       },
///     );
///   },
/// )
/// ```
///
/// スクロール可能なウィジェットにRefreshIndicatorとScrollbarを追加するビルダーウィジェット。
///
/// このウィジェットはListViewやSingleChildScrollViewに
/// プルトゥリフレッシュとスクロールバー機能を追加することを簡素化します。
/// リフレッシュ機能とデスクトップ/Webスクロールバーサポートを備えたリストビューに最適です。
///
/// 特徴:
/// - 簡単なプルトゥリフレッシュ統合
/// - プラットフォーム固有のスクロールバー（デスクトップ/Web）
/// - 自動ScrollController管理
/// - カスタムScrollControllerサポート
/// - 表示制御付きインタラクティブスクロールバー
/// - シンプルなビルダーパターン
///
/// 例:
/// ```dart
/// ScrollBuilder(
///   onRefresh: () async {
///     await refreshData();
///   },
///   showScrollbarWhenDesktopOrWeb: true,
///   builder: (context, controller) {
///     return ListView.builder(
///       controller: controller,
///       itemCount: items.length,
///       itemBuilder: (context, index) {
///         return ListTile(
///           title: Text(items[index].title),
///         );
///       },
///     );
///   },
/// )
/// ```
class ScrollBuilder extends StatefulWidget {
  /// A builder widget that adds RefreshIndicator and Scrollbar to scrollable widgets.
  ///
  /// This widget simplifies adding pull-to-refresh and scrollbar functionality
  /// to ListView or SingleChildScrollView. Perfect for list views with refresh
  /// capability and desktop/web scrollbar support.
  ///
  /// Features:
  /// - Easy pull-to-refresh integration
  /// - Platform-specific scrollbar (desktop/web)
  /// - Automatic ScrollController management
  /// - Custom ScrollController support
  /// - Interactive scrollbar with visibility controls
  /// - Simple builder pattern
  ///
  /// Example:
  /// ```dart
  /// ScrollBuilder(
  ///   onRefresh: () async {
  ///     await refreshData();
  ///   },
  ///   showScrollbarWhenDesktopOrWeb: true,
  ///   builder: (context, controller) {
  ///     return ListView.builder(
  ///       controller: controller,
  ///       itemCount: items.length,
  ///       itemBuilder: (context, index) {
  ///         return ListTile(
  ///           title: Text(items[index].title),
  ///         );
  ///       },
  ///     );
  ///   },
  /// )
  /// ```
  ///
  /// スクロール可能なウィジェットにRefreshIndicatorとScrollbarを追加するビルダーウィジェット。
  ///
  /// このウィジェットはListViewやSingleChildScrollViewに
  /// プルトゥリフレッシュとスクロールバー機能を追加することを簡素化します。
  /// リフレッシュ機能とデスクトップ/Webスクロールバーサポートを備えたリストビューに最適です。
  ///
  /// 特徴:
  /// - 簡単なプルトゥリフレッシュ統合
  /// - プラットフォーム固有のスクロールバー（デスクトップ/Web）
  /// - 自動ScrollController管理
  /// - カスタムScrollControllerサポート
  /// - 表示制御付きインタラクティブスクロールバー
  /// - シンプルなビルダーパターン
  ///
  /// 例:
  /// ```dart
  /// ScrollBuilder(
  ///   onRefresh: () async {
  ///     await refreshData();
  ///   },
  ///   showScrollbarWhenDesktopOrWeb: true,
  ///   builder: (context, controller) {
  ///     return ListView.builder(
  ///       controller: controller,
  ///       itemCount: items.length,
  ///       itemBuilder: (context, index) {
  ///         return ListTile(
  ///           title: Text(items[index].title),
  ///         );
  ///       },
  ///     );
  ///   },
  /// )
  /// ```
  const ScrollBuilder({
    required this.builder,
    super.key,
    this.onRefresh,
    this.controller,
    this.showScrollbarWhenDesktopOrWeb = true,
  });

  /// If [onRefresh] is not [null], a [RefreshIndicator] will be placed and Pull to Refresh will be enabled.
  ///
  /// [onRefresh]が[null]でない場合、[RefreshIndicator]を配置し、Pull to Refreshを有効にします。
  final Future<void> Function()? onRefresh;

  /// If [showScrollbarWhenDesktopOrWeb] is `true`, a mouse scrollable scrollbar will be displayed only on PC or Web.
  ///
  /// [showScrollbarWhenDesktopOrWeb]を`true`にすると、PCやWebでのみマウスでドラッグ可能なスクロールバーを表示します。
  final bool showScrollbarWhenDesktopOrWeb;

  /// An internal [ScrollController] is created and passed to [builder]. If you want to specify your own [ScrollController], pass it to [controller].
  ///
  /// 内部で[ScrollController]が作られ、それが[builder]に渡されます。自身で[ScrollController]を指定したい場合は[controller]に渡してください。
  final ScrollController? controller;

  /// Please pass a [ListView] or [SingleChildScrollView] to [builder].
  ///
  /// [builder]で[ListView]や[SingleChildScrollView]を渡してください。
  final Widget Function(BuildContext context, ScrollController controller)
      builder;

  @override
  State<StatefulWidget> createState() => _ScrollBuilderState();
}

class _ScrollBuilderState extends State<ScrollBuilder> {
  late ScrollController _scrollController;

  ScrollController get _effectiveScrollController =>
      widget.controller ?? _scrollController;

  static const _platformInfo = PlatformInfo();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _scrollController = ScrollController();
    }
  }

  Widget _buildRefreshIndicator(BuildContext context, Widget child) {
    if (widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget _buildScrollbar(BuildContext context, Widget child) {
    if (widget.showScrollbarWhenDesktopOrWeb &&
        (_platformInfo.isDesktop || _platformInfo.isWeb)) {
      return Scrollbar(
        interactive: true,
        trackVisibility: true,
        thumbVisibility: true,
        child: child,
      );
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(context, _effectiveScrollController);
    return _buildRefreshIndicator(
      context,
      _buildScrollbar(context, child),
    );
  }
}
