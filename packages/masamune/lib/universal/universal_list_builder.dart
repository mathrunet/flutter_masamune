part of masamune;

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
/// If [source] is given, each of its elements is displayed side by side in [builder].
///
/// If [top] is set, the [top] elements are lined up before the [source] elements are lined up.
///
/// If [bottom] is set, the elements of [bottom] are lined up after the elements of [source] are lined up.
///
/// When [insert] is set, [insert] is inserted at the position of [insertPosition] in [source].
///
/// If [listenWhenListenable] is `true`, [ListenableListener] will be wrapped around each element if [source] inherits [Listenable].
/// Therefore, each element of [source] is monitored individually, and if any element is updated, only that element is updated in the drawing.
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
///
/// [source]を与えるとその各要素を[builder]で並べて表示します。
///
/// [top]を設定すると[source]の要素を並べる前に[top]の要素を並べます。
///
/// [bottom]を設定すると[source]の要素を並べた後に[bottom]の要素を並べます。
///
/// [insert]を設定すると[source]の[insertPosition]の位置に[insert]が挿入されます。
///
/// [listenWhenListenable]が`true`になっている場合、[source]に[Listenable]を継承している場合[ListenableListener]が各要素にラップされます。
/// そのため、[source]の各要素をそれぞれ監視し、いずれかの要素が更新された場合その要素のみ描画が更新されます。
class UniversalListBuilder<T> extends ListBuilder<T> {
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
  /// If [source] is given, each of its elements is displayed side by side in [builder].
  ///
  /// If [top] is set, the [top] elements are lined up before the [source] elements are lined up.
  ///
  /// If [bottom] is set, the elements of [bottom] are lined up after the elements of [source] are lined up.
  ///
  /// When [insert] is set, [insert] is inserted at the position of [insertPosition] in [source].
  ///
  /// If [listenWhenListenable] is `true`, [ListenableListener] will be wrapped around each element if [source] inherits [Listenable].
  /// Therefore, each element of [source] is monitored individually, and if any element is updated, only that element is updated in the drawing.
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
  ///
  /// [source]を与えるとその各要素を[builder]で並べて表示します。
  ///
  /// [top]を設定すると[source]の要素を並べる前に[top]の要素を並べます。
  ///
  /// [bottom]を設定すると[source]の要素を並べた後に[bottom]の要素を並べます。
  ///
  /// [insert]を設定すると[source]の[insertPosition]の位置に[insert]が挿入されます。
  ///
  /// [listenWhenListenable]が`true`になっている場合、[source]に[Listenable]を継承している場合[ListenableListener]が各要素にラップされます。
  /// そのため、[source]の各要素をそれぞれ監視し、いずれかの要素が更新された場合その要素のみ描画が更新されます。
  const UniversalListBuilder({
    super.key,
    required super.source,
    required super.builder,
    super.top,
    super.insert,
    super.insertPosition = 0,
    super.bottom,
    super.scrollDirection = Axis.vertical,
    super.reverse = false,
    super.controller,
    super.listenWhenListenable = true,
    super.primary,
    super.physics,
    this.scrollBehavior,
    super.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    super.cacheExtent,
    super.semanticChildCount,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.restorationId,
    super.clipBehavior = Clip.hardEdge,
    super.padding,
    this.paddingWhenNotFullWidth,
    this.onRefresh,
    this.showScrollbarWhenDesktopOrWeb = true,
  });

  /// [padding] when the width does not exceed [UniversalScaffold.breakpoint] and the width is fixed.If [Null], [padding] is used.
  ///
  /// 横幅が[UniversalScaffold.breakpoint]を超えない場合、横幅が固定されているときの[padding]。[Null]の場合は[padding]が利用されます。
  final EdgeInsetsGeometry? paddingWhenNotFullWidth;

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

  /// The first child in the [GrowthDirection.forward] growth direction.
  ///
  /// Children after [center] will be placed in the [AxisDirection] determined
  /// by [scrollDirection] and [reverse] relative to the [center]. Children
  /// before [center] will be placed in the opposite of the axis direction
  /// relative to the [center]. This makes the [center] the inflection point of
  /// the growth direction.
  ///
  /// The [center] must be the key of one of the slivers built by [buildSlivers].
  ///
  /// Of the built-in subclasses of [ScrollView], only [CustomScrollView]
  /// supports [center]; for that class, the given key must be the key of one of
  /// the slivers in the [CustomScrollView.slivers] list.
  ///
  /// See also:
  ///
  ///  * [anchor], which controls where the [center] as aligned in the viewport.
  final Key? center;

  /// {@template flutter.widgets.scroll_view.anchor}
  /// The relative position of the zero scroll offset.
  ///
  /// For example, if [anchor] is 0.5 and the [AxisDirection] determined by
  /// [scrollDirection] and [reverse] is [AxisDirection.down] or
  /// [AxisDirection.up], then the zero scroll offset is vertically centered
  /// within the viewport. If the [anchor] is 1.0, and the axis direction is
  /// [AxisDirection.right], then the zero scroll offset is on the left edge of
  /// the viewport.
  /// {@endtemplate}
  final double anchor;

  /// {@template flutter.widgets.shadow.scrollBehavior}
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  /// {@endtemplate}
  final ScrollBehavior? scrollBehavior;

  @override
  Widget build(BuildContext context) {
    return _buildRefreshIndicator(
      context,
      _buildScrollbar(
        context,
        CustomScrollView(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: this.controller,
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
                  _builder,
                  childCount: _length,
                ),
              ),
            )
          ],
        ),
      ),
    );
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

  Widget _padding(BuildContext context, Widget sliver) {
    final width = MediaQuery.of(context).size.width;
    final breakpoint = ResponsiveScaffold.of(context)?.breakpoint;
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
    ResponsiveBreakpoint? breakpoint,
  ) {
    if (breakpoint?.width(context) == double.infinity) {
      return padding;
    } else {
      return paddingWhenNotFullWidth ?? padding;
    }
  }
}
