part of "/masamune_universal_ui.dart";

/// Create [ListView] to provide a consistent UI across web, desktop, and mobile.
///
/// [UniversalListView] is the `UniversalUI` version of [ListView]. It automatically transforms into Sliver widgets when used with [UniversalScaffold].
/// Supports [onRefresh] for pull-to-refresh, [onLoadNext] for infinite scrolling, and [padding]/[decoration] for styling. Responsive and automatically sets maximum width based on [UniversalScaffold.breakpoint].
///
/// ## Basic Usage
///
/// ```dart
/// UniversalListView(
///   padding: const EdgeInsets.all(16),
///   onRefresh: () async {
///     // Handle refresh logic
///   },
///   onLoadNext: () async {
///     // Handle load next logic
///   },
///   children: [
///     // Any widget
///   ],
/// );
/// ```
///
/// ---
///
/// Webとデスクトップ、モバイルで一貫したUIを提供するための[ListView]を作成します。
///
/// [UniversalListView]は[ListView]の`UniversalUI`版です。[UniversalScaffold]と連携しSliverウィジェットへの自動変換を行います。
/// [onRefresh]を設定可能でリストの更新を可能にする。[onLoadNext]を設定可能でリストの追加読み込みを可能にする。[padding]や[decoration]を設定可能でリストの外側に余白やボーダーを設定可能。レスポンシブ対応しており[UniversalScaffold.breakpoint]によって最大の横幅が設定されます。
///
/// ## 基本的な利用方法
///
/// ```dart
/// UniversalListView(
///   padding: const EdgeInsets.all(16),
///   onRefresh: () async {
///     // リフレッシュロジックを処理
///   },
///   onLoadNext: () async {
///     // 追加読み込みロジックを処理
///   },
///   children: [
///     // 任意のウィジェット
///   ],
/// );
/// ```
class UniversalListView extends StatelessWidget {
  /// Create [ListView] to provide a consistent UI across web, desktop, and mobile.
  ///
  /// [UniversalListView] is the `UniversalUI` version of [ListView]. It automatically transforms into Sliver widgets when used with [UniversalScaffold].
  /// Supports [onRefresh] for pull-to-refresh, [onLoadNext] for infinite scrolling, and [padding]/[decoration] for styling. Responsive and automatically sets maximum width based on [UniversalScaffold.breakpoint].
  ///
  /// ## Basic Usage
  ///
  /// ```dart
  /// UniversalListView(
  ///   padding: const EdgeInsets.all(16),
  ///   onRefresh: () async {
  ///     // Handle refresh logic
  ///   },
  ///   onLoadNext: () async {
  ///     // Handle load next logic
  ///   },
  ///   children: [
  ///     // Any widget
  ///   ],
  /// );
  /// ```
  ///
  /// ---
  ///
  /// Webとデスクトップ、モバイルで一貫したUIを提供するための[ListView]を作成します。
  ///
  /// [UniversalListView]は[ListView]の`UniversalUI`版です。[UniversalScaffold]と連携しSliverウィジェットへの自動変換を行います。
  /// [onRefresh]を設定可能でリストの更新を可能にする。[onLoadNext]を設定可能でリストの追加読み込みを可能にする。[padding]や[decoration]を設定可能でリストの外側に余白やボーダーを設定可能。レスポンシブ対応しており[UniversalScaffold.breakpoint]によって最大の横幅が設定されます。
  ///
  /// ## 基本的な利用方法
  ///
  /// ```dart
  /// UniversalListView(
  ///   padding: const EdgeInsets.all(16),
  ///   onRefresh: () async {
  ///     // リフレッシュロジックを処理
  ///   },
  ///   onLoadNext: () async {
  ///     // 追加読み込みロジックを処理
  ///   },
  ///   children: [
  ///     // 任意のウィジェット
  ///   ],
  /// );
  /// ```
  const UniversalListView({
    required this.children,
    super.key,
    this.decoration,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.onRefresh,
    this.onLoadNext,
    this.canLoadNext = true,
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
    this.enableResponsivePadding,
    this.showScrollbarWhenDesktopOrWeb = true,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.displayInvisibleArea = false,
    this.bottomExtent,
    this.topExtent,
  })  : assert(
          !(controller != null && (primary ?? false)),
          "Primary ScrollViews obtain their ScrollController via inheritance from a PrimaryScrollController widget. "
          "You cannot both set primary to true and pass an explicit controller.",
        ),
        assert(!shrinkWrap || center == null,
            "shrinkWrap cannot be true when center is not null"),
        assert(anchor >= 0.0 && anchor <= 1.0,
            "anchor must be between 0.0 and 1.0"),
        assert(semanticChildCount == null || semanticChildCount >= 0,
            "semanticChildCount must be null or greater than 0"),
        primary = primary ??
            controller == null && identical(scrollDirection, Axis.vertical),
        physics = physics ??
            ((primary ?? false) ||
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

  /// 一番最後の要素が表示されたときに呼ばれるメソッド。
  ///
  /// これが[Null]でない場合は最後にローディングインジケーターが表示されこれが実行されます。
  final Future<void> Function()? onLoadNext;

  /// If this is `false`, [onLoadNext] will not be executed.
  ///
  /// Whenever `true` is passed, [onLoadNext] is executed.
  ///
  /// これが`false`になっている場合[onLoadNext]が実行されません。
  ///
  /// `true`が渡されたときは必ず[onLoadNext]が実行されます。
  final bool canLoadNext;

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

  /// Specify whether to enable responsive padding.
  ///
  /// If `true` or `false` is specified, it is forced to be enabled or disabled.
  ///
  /// [Null] will automatically be `false` if the parent has a [UniversalColumn] or [UniversalContainer]. If not, it will be `true`.
  ///
  /// レスポンシブのパディングを有効にするかどうかを指定します。
  ///
  /// `true`や`false`を指定する場合強制的に有効か無効になります。
  ///
  /// [Null]の場合、親に[UniversalColumn]や[UniversalContainer]がある場合は自動的に`false`になります。ない場合は`true`になります。
  final bool? enableResponsivePadding;

  /// Setting this to `true` will display scrollbars on desktop and web.
  ///
  /// これを`true`にするとデスクトップとWebでスクロールバーを表示します。
  final bool showScrollbarWhenDesktopOrWeb;

  /// Scrollbar width.
  ///
  /// スクロールバーの横幅。
  final double? scrollbarThickness;

  /// Scrollbar corner radius.
  ///
  /// スクロールバーの角の半径。
  final Radius? scrollbarRadius;

  /// Return `true` if invisible areas should also be drawn.
  ///
  /// 見えないエリアも描画しておく場合`true`を返す。
  final bool displayInvisibleArea;

  /// Specify the space at the bottom.
  ///
  /// 下部のスペースを指定。
  final double? bottomExtent;

  /// Specify the space at the top.
  ///
  /// 上部のスペースを指定。
  final double? topExtent;

  static const _platformInfo = PlatformInfo();

  @override
  Widget build(BuildContext context) {
    final rows = _createRows(context, children);

    return UniversalWidgetScope(
      child: _buildRefreshIndicator(
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
                      delegate: displayInvisibleArea
                          ? SliverChildListDelegate.fixed(rows)
                          : SliverChildBuilderDelegate(
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
      ),
    );
  }

  List<Widget> _createRows(BuildContext context, List<Widget> children) {
    var accumulatedWidth = 0;
    var cols = <Widget>[];
    final rows = <Widget>[];

    final ScrollController? scrollController =
        primary ? PrimaryScrollController.maybeOf(context) : controller;

    if (topExtent != null) {
      rows.add(SizedBox(height: topExtent!));
    }

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

    if (accumulatedWidth > 0) {
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
    if (onLoadNext != null && canLoadNext && scrollController != null) {
      rows.add(
        _NextIndicator(controller: scrollController, onLoad: onLoadNext),
      );
    }

    if (bottomExtent != null) {
      rows.add(SizedBox(height: bottomExtent!));
    }
    return rows;
  }

  Widget _buildScrollbar(BuildContext context, Widget child) {
    if (showScrollbarWhenDesktopOrWeb &&
        (_platformInfo.isDesktop || _platformInfo.isWeb)) {
      final universalScope =
          MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
      return Scrollbar(
        interactive: true,
        trackVisibility: true,
        thumbVisibility: true,
        controller: controller,
        thickness:
            scrollbarThickness ?? universalScope?.defaultScrollbarThickness,
        radius: scrollbarRadius ?? universalScope?.defaultScrollbarRadius,
        child: child,
      );
    } else {
      return child;
    }
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
    final universalWidgetScope = UniversalWidgetScope.of(context);
    final width = MediaQuery.of(context).size.width;
    final adapter = MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    final breakpoint = UniversalScaffold.of(context)?.breakpoint;
    final maxWidth = (breakpoint?.width(context) ?? width).limitHigh(width);
    final enablePadding = enableResponsivePadding ??
        adapter?.enableResponsivePadding ??
        universalWidgetScope == null;
    final responsivePadding = enablePadding ? (width - maxWidth) / 2.0 : 0.0;
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

class _NextIndicator extends StatefulWidget {
  const _NextIndicator({
    required this.controller,
    this.onLoad,
  });

  final Future<void> Function()? onLoad;
  final ScrollController controller;

  static const _size = 32.0;

  @override
  State<StatefulWidget> createState() => _NextIndicatorState();
}

class _NextIndicatorState extends State<_NextIndicator> {
  bool _loaded = false;
  bool _loading = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _disposed = true;
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.controller.position.atEdge) {
      final isBottom = widget.controller.position.pixels ==
          widget.controller.position.maxScrollExtent;
      if (isBottom) {
        _load();
      }
    }
  }

  Future<void> _load() async {
    if (_loading || _loaded) {
      return;
    }
    _loading = true;
    if (_disposed) {
      return;
    }
    setState(() {});
    await widget.onLoad?.call();
    _loaded = true;
    _loading = false;
    if (_disposed) {
      return;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant _NextIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller && _loaded) {
      _loaded = false;
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
      _onScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded || !_loading) {
      return const Empty();
    }
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: _NextIndicator._size,
            height: _NextIndicator._size,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
