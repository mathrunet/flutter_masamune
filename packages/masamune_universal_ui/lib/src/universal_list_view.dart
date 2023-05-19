part of masamune_universal_ui;

/// Create [ListView] to provide a consistent UI across web, desktop, and mobile.
///
/// The [UniversalAppBar] and [UniversalSliverAppBar] will automatically select and set whether to use the normal list or the Sliver list.
///
/// Otherwise, it can be used in the same way as a normal [ListView].
///
/// When [onRefresh] is specified, [RefreshIndicator] is automatically set.
///
/// Setting [showScrollbarWhenDesktopOrWeb] to `true` will show scrollbars on desktop and web.
///
/// It is responsive and the maximum width is set by [UniversalScaffold.breakpoint].
///
/// Webとデスクトップ、モバイルで一貫したUIを提供するための[ListView]を作成します。
///
/// [UniversalAppBar]、[UniversalSliverAppBar]によって通常のリストかSliverのリストかを自動で選択して設定します。
///
/// その他は通常の[ListView]と同じように利用可能です。
///
/// [onRefresh]を指定すると[RefreshIndicator]を自動で設定します。
///
/// [showScrollbarWhenDesktopOrWeb]を`true`にするとデスクトップとWebでスクロールバーを表示します。
///
/// レスポンシブ対応しており[UniversalScaffold.breakpoint]によって最大の横幅が設定されます。
class UniversalListView extends StatelessWidget {
  /// Create [ListView] to provide a consistent UI across web, desktop, and mobile.
  ///
  /// The [UniversalAppBar] and [UniversalSliverAppBar] will automatically select and set whether to use the normal list or the Sliver list.
  ///
  /// Otherwise, it can be used in the same way as a normal [ListView].
  ///
  /// When [onRefresh] is specified, [RefreshIndicator] is automatically set.
  ///
  /// Setting [showScrollbarWhenDesktopOrWeb] to `true` will show scrollbars on desktop and web.
  ///
  /// It is responsive and the maximum width is set by [UniversalScaffold.breakpoint].
  ///
  /// Webとデスクトップ、モバイルで一貫したUIを提供するための[ListView]を作成します。
  ///
  /// [UniversalAppBar]、[UniversalSliverAppBar]によって通常のリストかSliverのリストかを自動で選択して設定します。
  ///
  /// その他は通常の[ListView]と同じように利用可能です。
  ///
  /// [onRefresh]を指定すると[RefreshIndicator]を自動で設定します。
  ///
  /// [showScrollbarWhenDesktopOrWeb]を`true`にするとデスクトップとWebでスクロールバーを表示します。
  ///
  /// レスポンシブ対応しており[UniversalScaffold.breakpoint]によって最大の横幅が設定されます。
  const UniversalListView({
    super.key,
    required this.children,
    this.decoration,
    this.showScrollbarWhenDesktopOrWeb = true,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.onRefresh,
    bool? primary,
    ScrollPhysics? physics,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.rowSegments = 12,
    this.maxWidth,
    this.padding,
  })  : assert(
          !(controller != null && primary == true),
          "Primary ScrollViews obtain their ScrollController via inheritance from a PrimaryScrollController widget. "
          "You cannot both set primary to true and pass an explicit controller.",
        ),
        assert(!shrinkWrap || center == null),
        assert(anchor >= 0.0 && anchor <= 1.0),
        assert(semanticChildCount == null || semanticChildCount >= 0),
        primary = primary ??
            controller == null && identical(scrollDirection, Axis.vertical),
        physics = physics ??
            (primary == true ||
                    (primary == null &&
                        controller == null &&
                        identical(scrollDirection, Axis.vertical))
                ? const AlwaysScrollableScrollPhysics()
                : null);

  /// Maximum width.
  ///
  /// 最大の横幅。
  final double? maxWidth;

  /// Method called by [RefreshIndicator].
  ///
  /// Pull-to-Refresh will execute and display an indicator until [Future] is returned.
  ///
  /// [RefreshIndicator]で呼ばれるメソッド。
  ///
  /// Pull-to-Refreshを行うと実行され、[Future]が返されるまでインジケーターを表示します。
  final Future<void> Function()? onRefresh;

  /// Setting this to `true` will display scrollbars on desktop and web.
  ///
  /// これを`true`にするとデスクトップとWebでスクロールバーを表示します。
  final bool showScrollbarWhenDesktopOrWeb;

  /// A list of child elements for display in [ListView].
  ///
  /// [ListView]で表示するための子要素のリスト。
  final List<Widget> children;

  /// {@macro flutter.widgets.scroll_view.padding}
  final EdgeInsetsGeometry? padding;

  /// Sets the container background decoration.
  ///
  /// コンテナの背景の装飾を設定します。
  final Decoration? decoration;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.scroll_view.primary}
  final bool primary;

  /// {@macro flutter.widgets.scroll_view.physics}
  final ScrollPhysics? physics;

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  final ScrollBehavior? scrollBehavior;

  /// {@macro flutter.widgets.scroll_view.shrinkWrap}
  final bool shrinkWrap;

  /// {@macro flutter.widgets.scroll_view.center}
  final Key? center;

  /// {@macro flutter.widgets.scroll_view.anchor}
  final double anchor;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.rendering.RenderViewportBase.semanticChildCount}
  final int? semanticChildCount;

  /// {@macro flutter.widgets.scroll_view.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.material.Material.clipBehavior}
  final Clip clipBehavior;

  /// You can change the placement of [ResponsiveCol].
  ///
  /// [ResponsiveCol]の配置を変更することができます。
  final CrossAxisAlignment crossAxisAlignment;

  /// The number of segments in the horizontal direction.
  ///
  /// 横方向のセグメントの数です。
  final int rowSegments;

  @override
  Widget build(BuildContext context) {
    final rows = _createRows(context, children);

    return _buildRefreshIndicator(
      context,
      _buildScrollbar(
        context,
        _buildConstrainedBox(
          context,
          _buildDecoratedBox(
            context,
            CustomScrollView(
              key: key,
              scrollDirection: scrollDirection,
              reverse: reverse,
              controller: controller,
              primary: primary,
              physics: physics,
              scrollBehavior: scrollBehavior,
              shrinkWrap: shrinkWrap,
              center: center,
              anchor: anchor,
              cacheExtent: cacheExtent,
              semanticChildCount: semanticChildCount,
              dragStartBehavior: dragStartBehavior,
              keyboardDismissBehavior: keyboardDismissBehavior,
              restorationId: restorationId,
              clipBehavior: clipBehavior,
              slivers: [
                _padding(
                  context,
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => rows[i],
                      childCount: rows.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createRows(BuildContext context, List<Widget> children) {
    int accumulatedWidth = 0;
    var cols = <Widget>[];
    final rows = <Widget>[];

    for (final col in children) {
      if (col is Responsive) {
        final colWidth = col.currentConfig(context) ?? 12;
        if (accumulatedWidth + colWidth > rowSegments) {
          if (accumulatedWidth < rowSegments) {
            cols.add(Spacer(
              flex: rowSegments - accumulatedWidth,
            ));
          }
          rows.add(Row(
            crossAxisAlignment: crossAxisAlignment,
            children: cols,
          ));
          cols = <Widget>[];
          accumulatedWidth = 0;
        }
        cols.add(col);
        accumulatedWidth += colWidth;
      } else {
        if (cols.isNotEmpty) {
          rows.add(Row(
            crossAxisAlignment: crossAxisAlignment,
            children: cols,
          ));
          cols = <Widget>[];
          accumulatedWidth = 0;
        }
        rows.add(col);
      }
    }

    if (accumulatedWidth >= 0) {
      if (accumulatedWidth < rowSegments) {
        cols.add(Spacer(
          flex: rowSegments - accumulatedWidth,
        ));
      }
      rows.add(Row(
        crossAxisAlignment: crossAxisAlignment,
        children: cols,
      ));
    }
    return rows;
  }

  Widget _buildRefreshIndicator(BuildContext context, Widget child) {
    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget _buildScrollbar(BuildContext context, Widget child) {
    if (showScrollbarWhenDesktopOrWeb &&
        (UniversalPlatform.isDesktop || UniversalPlatform.isWeb)) {
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

  Widget _buildDecoratedBox(BuildContext context, Widget child) {
    if (decoration != null) {
      return DecoratedBox(
        decoration: decoration!,
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget _buildConstrainedBox(BuildContext context, Widget child) {
    if (maxWidth != null) {
      return Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: child,
        ),
      );
    } else {
      return child;
    }
  }

  Widget _padding(BuildContext context, Widget sliver) {
    final width = MediaQuery.of(context).size.width;
    final breakpoint = UniversalScaffold.of(context)?.breakpoint;
    final maxWidth = (breakpoint?.width(context) ?? width).limitHigh(width);
    final responsivePadding = (width - maxWidth) / 2.0;
    final resolvedPadding =
        _effectivePadding(context, breakpoint)?.resolve(TextDirection.ltr);
    final generatedPadding = EdgeInsets.fromLTRB(
      (resolvedPadding?.left ?? 0.0) + responsivePadding,
      resolvedPadding?.top ?? 0.0,
      (resolvedPadding?.right ?? 0.0) + responsivePadding,
      resolvedPadding?.bottom ?? 0.0,
    );

    return SliverPadding(
      padding: generatedPadding,
      sliver: sliver,
    );
  }

  EdgeInsetsGeometry? _effectivePadding(
    BuildContext context,
    Breakpoint? breakpoint,
  ) {
    final universal =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    return ResponsiveEdgeInsets._responsive(
      context,
      padding ?? universal?.defaultBodyPadding,
      breakpoint: breakpoint,
    );
  }
}
