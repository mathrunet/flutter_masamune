part of '/masamune.dart';

/// Callbacks used by [ListBuilder].
///
/// [context] is passed as [BuildContext], [item] as each element, and [index] as the array number of the element.
///
/// [ListBuilder]で利用するコールバック。
///
/// [context]に[BuildContext]、[item]に各要素、[index]が要素の配列番号が渡されます。
typedef ListBuilderCallback<T> = List<Widget>? Function(
  BuildContext context,
  T item,
  int index,
);

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
class ListBuilder<T> extends StatelessWidget {
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
  const ListBuilder({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.top,
    this.insert,
    this.insertPosition = 0,
    this.bottom,
    this.itemExtent,
    required this.builder,
    required this.source,
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
  })  : _topLength = top.length,
        _length = top.length + source.length + bottom.length + insert.length,
        _topSourcelength = top.length + source.length + insert.length;

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

  /// List view padding.
  ///
  /// リストビューのパディング。
  final EdgeInsetsGeometry? padding;

  /// The height (width) of each element. If [Null], the bare height (width) of each element is set.
  ///
  /// 各要素の高さ（幅）。[Null]の場合は要素ごとの素の高さ（幅）が設定されます。
  final double? itemExtent;

  /// If an element of [insert] exists, insert [insert] at the [insertPosition]th position of [source].
  ///
  /// [insert]の要素が存在する場合、[source]の[insertPosition]番目に[insert]を挿入します。
  final int insertPosition;

  /// If [listenWhenListenable] is `true`, [ListenableListener] will be wrapped around each element if [source] inherits [Listenable].
  /// Therefore, each element of [source] is monitored individually, and if any element is updated, only that element is updated in the drawing.
  ///
  /// [listenWhenListenable]が`true`になっている場合、[source]に[Listenable]を継承している場合[ListenableListener]が各要素にラップされます。
  /// そのため、[source]の各要素をそれぞれ監視し、いずれかの要素が更新された場合その要素のみ描画が更新されます。
  final bool listenWhenListenable;

  /// When [insert] is set, [insert] is inserted at the position of [insertPosition] in [source].
  ///
  /// [insert]を設定すると[source]の[insertPosition]の位置に[insert]が挿入されます。
  final List<Widget>? insert;

  /// If [top] is set, the [top] elements are lined up before the [source] elements are lined up.
  ///
  /// [top]を設定すると[source]の要素を並べる前に[top]の要素を並べます。
  final List<Widget>? top;

  /// If [bottom] is set, the elements of [bottom] are lined up after the elements of [source] are lined up.
  ///
  /// [bottom]を設定すると[source]の要素を並べた後に[bottom]の要素を並べます。
  final List<Widget>? bottom;

  /// List of data to be displayed in the list.
  ///
  /// リストに表示するデータの一覧。
  final List<T> source;

  /// Builder to display on the list.
  ///
  /// [context] is passed as [BuildContext], [item] as each element, and [index] as the array number of the element.
  ///
  /// リストに表示するためのビルダー。
  ///
  /// [context]に[BuildContext]、[item]に各要素、[index]が要素の配列番号が渡されます。
  final ListBuilderCallback<T> builder;

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

  final int _topLength;
  final int _length;
  final int _topSourcelength;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      itemBuilder: _builder,
      itemCount: _length,
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
    if (i < _topLength) {
      return top![i];
    } else if (i < _topSourcelength) {
      if (source.isEmpty) {
        return insert![i - _topLength];
      } else if (source.length <= insertPosition) {
        final pos = i - _topLength;
        if (pos < source.length) {
          return _listenableBuilder(context, pos);
        } else {
          return insert![i - source.length - _topLength];
        }
      } else {
        final pos = i - _topLength;
        if (pos >= insertPosition && pos < insertPosition + insert.length) {
          return insert![pos - insertPosition];
        } else if (pos < insertPosition) {
          return _listenableBuilder(context, pos);
        } else {
          return _listenableBuilder(context, pos - insert.length);
        }
      }
    } else {
      return bottom![i - _topSourcelength];
    }
  }

  Widget _sourceBuilder(BuildContext context, T item, int pos) {
    final children = builder.call(context, item, pos);
    if (children.isEmpty) {
      return const SizedBox.shrink();
    } else if (children.length <= 1) {
      return children!.firstOrNull ?? const SizedBox.shrink();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children!,
      );
    }
  }

  Widget _listenableBuilder(BuildContext context, int pos) {
    final item = source[pos];
    if (!listenWhenListenable || item is! Listenable) {
      return _sourceBuilder(context, item, pos);
    }
    return ListenableListener<Listenable>(
      listenable: item,
      builder: (context, listenable) {
        return _sourceBuilder(context, item, pos);
      },
    );
  }
}
