part of "/katana_ui.dart";

/// This widget can be placed on top of a [ListView] or [SingleChildScrollView] to easily add a [RefreshIndicator] or [Scrollbar].
///
/// If [showScrollbarWhenDesktopOrWeb] is `true`, a mouse scrollable scrollbar will be displayed only on PC or Web.
///
/// If [onRefresh] is not [null], a [RefreshIndicator] will be placed and Pull to Refresh will be enabled.
///
/// Please pass a [ListView] or [SingleChildScrollView] to [builder].
///
/// An internal [ScrollController] is created and passed to [builder]. If you want to specify your own [ScrollController], pass it to [controller].
///
/// [ListView]や[SingleChildScrollView]の上に配置することで、[RefreshIndicator]や[Scrollbar]を簡単に追加できるようにするためのウィジェットです。
///
/// [showScrollbarWhenDesktopOrWeb]を`true`にすると、PCやWebでのみマウスでドラッグ可能なスクロールバーを表示します。
///
/// [onRefresh]が[null]でない場合、[RefreshIndicator]を配置し、Pull to Refreshを有効にします。
///
/// [builder]で[ListView]や[SingleChildScrollView]を渡してください。
///
/// 内部で[ScrollController]が作られ、それが[builder]に渡されます。自身で[ScrollController]を指定したい場合は[controller]に渡してください。
class ScrollBuilder extends StatefulWidget {
  /// This widget can be placed on top of a [ListView] or [SingleChildScrollView] to easily add a [RefreshIndicator] or [Scrollbar].
  ///
  /// If [showScrollbarWhenDesktopOrWeb] is `true`, a mouse scrollable scrollbar will be displayed only on PC or Web.
  ///
  /// If [onRefresh] is not [null], a [RefreshIndicator] will be placed and Pull to Refresh will be enabled.
  ///
  /// Please pass a [ListView] or [SingleChildScrollView] to [builder].
  ///
  /// An internal [ScrollController] is created and passed to [builder]. If you want to specify your own [ScrollController], pass it to [controller].
  ///
  /// [ListView]や[SingleChildScrollView]の上に配置することで、[RefreshIndicator]や[Scrollbar]を簡単に追加できるようにするためのウィジェットです。
  ///
  /// [showScrollbarWhenDesktopOrWeb]を`true`にすると、PCやWebでのみマウスでドラッグ可能なスクロールバーを表示します。
  ///
  /// [onRefresh]が[null]でない場合、[RefreshIndicator]を配置し、Pull to Refreshを有効にします。
  ///
  /// [builder]で[ListView]や[SingleChildScrollView]を渡してください。
  ///
  /// 内部で[ScrollController]が作られ、それが[builder]に渡されます。自身で[ScrollController]を指定したい場合は[controller]に渡してください。
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
