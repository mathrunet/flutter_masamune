part of "/masamune_universal_ui.dart";

/// Create [GridView] to provide a consistent UI across web, desktop, and mobile.
///
/// [UniversalGridView] is the `UniversalUI` version of [GridView]. It automatically transforms into Sliver widgets when used with [UniversalScaffold].
/// Supports [onRefresh] for pull-to-refresh, [onLoadNext] for infinite scrolling, and [padding]/[decoration] for styling. Responsive and automatically sets maximum width based on [UniversalScaffold.breakpoint].
///
/// ## Basic Usage
///
/// ```dart
/// UniversalGridView(
///   padding: const EdgeInsets.all(16),
///   crossAxisCount: 2,
///   mainAxisSpacing: 16,
///   crossAxisSpacing: 16,
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
/// Webとデスクトップ、モバイルで一貫したUIを提供するための[GridView]を作成します。
///
/// [UniversalGridView]は[GridView]の`UniversalUI`版です。[UniversalScaffold]と連携しSliverウィジェットへの自動変換を行います。
/// [onRefresh]を設定可能でグリッドの更新を可能にする。[onLoadNext]を設定可能でグリッドの追加読み込みを可能にする。[padding]や[decoration]を設定可能でグリッドの外側に余白やボーダーを設定可能。レスポンシブ対応しており[UniversalScaffold.breakpoint]によって最大の横幅が設定されます。
///
/// ## 基本的な利用方法
///
/// ```dart
/// UniversalGridView(
///   padding: const EdgeInsets.all(16),
///   crossAxisCount: 2,
///   mainAxisSpacing: 16,
///   crossAxisSpacing: 16,
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
class UniversalGridView extends StatelessWidget {
  /// Create [GridView] to provide a consistent UI across web, desktop, and mobile.
  ///
  /// [UniversalGridView] is the `UniversalUI` version of [GridView]. It automatically transforms into Sliver widgets when used with [UniversalScaffold].
  /// Supports [onRefresh] for pull-to-refresh, [onLoadNext] for infinite scrolling, and [padding]/[decoration] for styling. Responsive and automatically sets maximum width based on [UniversalScaffold.breakpoint].
  ///
  /// ## Basic Usage
  ///
  /// ```dart
  /// UniversalGridView(
  ///   padding: const EdgeInsets.all(16),
  ///   crossAxisCount: 2,
  ///   mainAxisSpacing: 16,
  ///   crossAxisSpacing: 16,
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
  /// Webとデスクトップ、モバイルで一貫したUIを提供するための[GridView]を作成します。
  ///
  /// [UniversalGridView]は[GridView]の`UniversalUI`版です。[UniversalScaffold]と連携しSliverウィジェットへの自動変換を行います。
  /// [onRefresh]を設定可能でグリッドの更新を可能にする。[onLoadNext]を設定可能でグリッドの追加読み込みを可能にする。[padding]や[decoration]を設定可能でグリッドの外側に余白やボーダーを設定可能。レスポンシブ対応しており[UniversalScaffold.breakpoint]によって最大の横幅が設定されます。
  ///
  /// ## 基本的な利用方法
  ///
  /// ```dart
  /// UniversalGridView(
  ///   padding: const EdgeInsets.all(16),
  ///   crossAxisCount: 2,
  ///   mainAxisSpacing: 16,
  ///   crossAxisSpacing: 16,
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
  const UniversalGridView({
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
    this.maxWidth,
    this.padding,
    this.enableResponsivePadding,
    this.showScrollbarWhenDesktopOrWeb = true,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.displayInvisibleArea = false,
    this.bottomExtent,
    this.topExtent,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
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

  /// A list of child elements for display in [GridView].
  ///
  /// [GridView]で表示するための子要素のリスト。
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

  /// The number of children in the cross axis.
  ///
  /// クロス軸の子要素の数。
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  ///
  /// メイン軸に沿った各子要素間の論理的なピクセル数。
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  ///
  /// クロス軸に沿った各子要素間の論理的なピクセル数。
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  ///
  /// 各子要素のメイン軸の範囲に対するクロス軸の比率。
  final double childAspectRatio;

  static const _platformInfo = PlatformInfo();

  @override
  Widget build(BuildContext context) {
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
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: crossAxisSpacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      delegate: displayInvisibleArea
                          ? SliverChildListDelegate.fixed(children)
                          : SliverChildBuilderDelegate(
                              (context, i) => children[i],
                              childCount: children.length,
                            ),
                    ),
                  ),
                  if (onLoadNext != null && canLoadNext)
                    SliverToBoxAdapter(
                      child: _NextIndicator(
                        controller:
                            controller ?? PrimaryScrollController.of(context),
                        onLoad: onLoadNext,
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
