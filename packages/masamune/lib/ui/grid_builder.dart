part of masamune;

/// Draw a grid list with elements generated from [builder] given [source].
///
/// With [GridBuilder.count], it is possible to configure a grid by specifying the number of horizontal pieces in [crossAxisCount].
///
/// [GridBuilder.extent] allows you to configure the grid by specifying the maximum horizontal width with [maxCrossAxisExtent].
///
/// If [listenWhenListenable] is `true`, [ListenableListener] will be wrapped around each element if [source] inherits [Listenable].
/// Therefore, each element of [source] is monitored individually, and if any element is updated, only that element is updated in the drawing.
///
/// [source]を与えて[builder]から生成された要素でグリッドリストを描画します。
///
/// [GridBuilder.count]だと[crossAxisCount]で横の個数を指定してグリッドを構成することが可能です。
///
/// [GridBuilder.extent]だと[maxCrossAxisExtent]で横の最大幅を指定してグリッドを構成することができます。
///
/// [listenWhenListenable]が`true`になっている場合、[source]に[Listenable]を継承している場合[ListenableListener]が各要素にラップされます。
/// そのため、[source]の各要素をそれぞれ監視し、いずれかの要素が更新された場合その要素のみ描画が更新されます。
class GridBuilder<T> extends StatelessWidget {
  /// Draw a grid list with elements generated from [builder] given [source].
  ///
  /// It is possible to configure the grid by specifying the number of horizontal pieces in [crossAxisCount].
  ///
  /// If [listenWhenListenable] is `true`, [ListenableListener] will be wrapped around each element if [source] inherits [Listenable].
  /// Therefore, each element of [source] is monitored individually, and if any element is updated, only that element is updated in the drawing.
  ///
  /// [source]を与えて[builder]から生成された要素でグリッドリストを描画します。
  ///
  /// [crossAxisCount]で横の個数を指定してグリッドを構成することが可能です。
  ///
  /// [listenWhenListenable]が`true`になっている場合、[source]に[Listenable]を継承している場合[ListenableListener]が各要素にラップされます。
  /// そのため、[source]の各要素をそれぞれ監視し、いずれかの要素が更新された場合その要素のみ描画が更新されます。
  const GridBuilder.count({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    required this.source,
    required this.crossAxisCount,
    required this.builder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.listenWhenListenable = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  })  : maxCrossAxisExtent = 0.0,
        assert(
          crossAxisCount > 0,
          "[crossAxisCount] must be greater than or equal to 0.",
        );

  /// Draw a grid list with elements generated from [builder] given [source].
  ///
  /// [maxCrossAxisExtent] allows you to configure the grid by specifying the maximum horizontal width.
  ///
  /// If [listenWhenListenable] is `true`, [ListenableListener] will be wrapped around each element if [source] inherits [Listenable].
  /// Therefore, each element of [source] is monitored individually, and if any element is updated, only that element is updated in the drawing.
  ///
  /// [source]を与えて[builder]から生成された要素でグリッドリストを描画します。
  ///
  /// [maxCrossAxisExtent]で横の最大幅を指定してグリッドを構成することができます。
  ///
  /// [listenWhenListenable]が`true`になっている場合、[source]に[Listenable]を継承している場合[ListenableListener]が各要素にラップされます。
  /// そのため、[source]の各要素をそれぞれ監視し、いずれかの要素が更新された場合その要素のみ描画が更新されます。
  const GridBuilder.extent({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    required this.source,
    required this.maxCrossAxisExtent,
    required this.builder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.listenWhenListenable = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  })  : crossAxisCount = 0,
        assert(
          maxCrossAxisExtent > 0,
          "[maxCrossAxisExtent] must be greater than or equal to 0.",
        );

  /// Scroll direction.
  ///
  /// スクロールの方向。
  final Axis scrollDirection;

  /// If this is `true`, the scroll direction is reversed.
  ///
  /// これが`true`の場合、スクロールの方向が逆になります。
  final bool reverse;

  /// If you want to control scrolling from the outside, pass [ScrollController].
  ///
  /// スクロールを外部からコントロールしたい場合、[ScrollController]を渡します。
  final ScrollController? controller;

  /// If this is `true`, it is recognized as the primary scrolling view.
  ///
  /// これが`true`の場合、プライマリーのスクロールビューとして認識されます。
  final bool? primary;

  /// Pass [ScrollPhysics] to set the scrolling method.
  ///
  /// スクロールの方法を設定するために[ScrollPhysics]を渡します。
  final ScrollPhysics? physics;

  /// If this is `true`, the area for scrolling is reduced to only where the content resides.
  ///
  /// これが`true`の場合、スクロール用のエリアをコンテンツが存在するところのみに縮小します。
  final bool shrinkWrap;

  /// Grid view padding.
  ///
  /// グリッドビューのパディング。
  final EdgeInsetsGeometry? padding;

  /// List of data to be displayed on the grid.
  ///
  /// グリッドに表示するデータの一覧。
  final List<T> source;

  /// If [listenWhenListenable] is `true`, [ListenableListener] will be wrapped around each element if [source] inherits [Listenable].
  /// Therefore, each element of [source] is monitored individually, and if any element is updated, only that element is updated in the drawing.
  ///
  /// [listenWhenListenable]が`true`になっている場合、[source]に[Listenable]を継承している場合[ListenableListener]が各要素にラップされます。
  /// そのため、[source]の各要素をそれぞれ監視し、いずれかの要素が更新された場合その要素のみ描画が更新されます。
  final bool listenWhenListenable;

  /// Builder for display on a grid.
  ///
  /// [context] is passed as [BuildContext], [item] as each element, and [index] as each element number.
  ///
  /// グリッドに表示するためのビルダー。
  ///
  /// [context]に[BuildContext]、[item]に各要素、[index]に各要素番号が渡されます。
  ///
  final Widget Function(BuildContext context, T item, int index) builder;

  /// If this is set to `true`, it will prevent a rebuild if [AutomaticKeepAliveClientMixin] is mixdrunk in the Widget in the List and is shown or hidden in the List.
  ///
  /// これが`true`になっているとList内のWidgetに[AutomaticKeepAliveClientMixin]がミックス飲されているとリストへの表示・非表示された場合のリビルドを防ぐことができるようになります。
  final bool addAutomaticKeepAlives;

  /// Set to `true` to provide a redraw area for the list (the part that is displayed on the screen).
  ///
  /// リストの再描画領域（画面に表示される部分）を設ける場合は`true`に設定します。
  final bool addRepaintBoundaries;

  /// Automatically add semantics indexes.
  ///
  /// Set to `false` only if the index is already provided by the [IndexedSemantics] widget.
  ///
  /// 自動でセマンティクスインデックスを追加します。
  ///
  /// インデックスがすでに[IndexedSemantics]ウィジェットによって提供されている場合のみ、`false`に設定します。
  final bool addSemanticIndexes;

  /// Specify the area to hold the cache.
  ///
  /// キャッシュを保持する領域を指定します。
  final double? cacheExtent;

  /// Explicitly communicate the number of child widgets.
  ///
  /// 子ウィジェットの数を明示的に伝えます。
  final int? semanticChildCount;

  /// Provides the ability to initiate a drag.
  ///
  /// ドラッグを開始するための機能を提供します。
  final DragStartBehavior dragStartBehavior;

  /// Define here if you want to implement a mechanism to close the keyboard triggered by scrolling.
  ///
  /// スクロールをトリガーにキーボードを閉じる仕組みを実装する場合ここを定義します。
  ///
  /// ```dart
  /// keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  /// ```
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Restore ID to save and restore the scroll offset of the listing.
  ///
  /// If a restore ID is specified, the listing retains the current scroll offset and restores it during state restoration.
  ///
  /// リストのスクロールオフセットを保存および復元するための復元ID。
  ///
  /// 復元IDを指定すると、リストは現在のスクロールオフセットを保持し、状態の復元中にそれを復元します。
  final String? restorationId;

  /// Specify here to adjust the clip function of the listing.
  ///
  /// リストのクリップ機能を調整する場合ここを指定します。
  final Clip clipBehavior;

  /// Number of horizontal elements in the grid.
  ///
  /// グリッドの横方向の要素数。
  final int crossAxisCount;

  /// Maximum width of the grid's horizontal elements.
  ///
  /// グリッドの横方向要素の最大横幅。
  final double maxCrossAxisExtent;

  /// Space width between vertical elements of the grid.
  ///
  /// グリッドの縦方向の要素間のスペース幅。
  final double mainAxisSpacing;

  /// Space width between elements in the horizontal direction of the grid.
  ///
  /// グリッドの横方向の要素間のスペース幅。
  final double crossAxisSpacing;

  /// Aspect ratio of the child element.
  ///
  /// 子要素のアスペクト比。
  final double childAspectRatio;

  /// Specifies the width of the main element.
  ///
  /// メイン要素の幅を指定します。
  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      gridDelegate: crossAxisCount == 0
          ? SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
              mainAxisExtent: mainAxisExtent,
            )
          : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
              mainAxisExtent: mainAxisExtent,
            ),
      itemBuilder: _builder,
      itemCount: source.length,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }

  Widget _builder(BuildContext context, int i) {
    return _listenableBuilder(context: context, item: source[i], index: i);
  }

  Widget _listenableBuilder({
    required BuildContext context,
    required T item,
    required int index,
  }) {
    if (!listenWhenListenable || item is! Listenable) {
      return builder.call(context, item, index);
    }
    return ListenableListener<Listenable>(
      listenable: item,
      builder: (context, listenable) {
        return builder.call(context, item, index);
      },
    );
  }
}
