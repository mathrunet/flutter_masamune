part of katana_model;

/// Provides an extension method for [Iterable] that includes [Listenable] as an element.
///
/// [Listenable]を要素に含んだ[Iterable]の拡張メソッドを提供します。
extension ListenableIterableExtensions<T extends Listenable> on Iterable<T> {
  /// Convert each [Listenable] element to a [Widget] via [callback].
  ///
  /// Wrapping the conversion with a [ListenableListener] will update the [Widget] when notified of changes to the given [Listenable].
  ///
  /// When the contents of a [DocumentBase] contained in a [CollectionBase] are changed, [CollectionBase] will not receive a change notification (unless the number of elements in the [CollectionBase] is changed).
  ///
  /// By using this method to expand the contents, even if the contents of [DocumentBase] are changed, it is possible to receive a change notification and reflect the changes only in the relevant contents.
  ///
  /// 各[Listenable]要素を[callback]を介して[Widget]に変換します。
  ///
  /// 変換する際に[ListenableListener]でラップすることで、与えられた[Listenable]の変更が通知された際に[Widget]を更新します。
  ///
  /// [CollectionBase]に含まれる[DocumentBase]の内容が変更される際、（[CollectionBase]の要素数が変更される場合を除いて）[CollectionBase]には変更通知は届きません。
  ///
  /// このメソッドで中身を展開することで[DocumentBase]の内容が変更された場合でも変更通知を受け取り該当する中身のみ変更内容を反映することが可能になります。
  List<Widget> mapListenable(Widget? Function(T item) callback) {
    return map((item) {
      return ListenableListener<T>(
        listenable: item,
        builder: (context, listenable) =>
            callback.call(listenable) ?? const SizedBox.shrink(),
      );
    }).toList();
  }
}

/// A widget that monitors changes in [Listenable] and updates the contents of [builder] when there is a change.
///
/// [Listenable]の変更を監視し変更があった場合、[builder]の内容を更新するウィジェット。
class ListenableListener<T extends Listenable> extends StatefulWidget {
  /// A widget that monitors changes in [Listenable] and updates the contents of [builder] when there is a change.
  ///
  /// [Listenable]の変更を監視し変更があった場合、[builder]の内容を更新するウィジェット。
  const ListenableListener({
    super.key,
    required this.listenable,
    required this.builder,
  });

  /// [Listenable] for monitoring.
  ///
  /// 監視するための[Listenable]。
  final T listenable;

  /// Builder to build [Widget] to update when changes are made.
  ///
  /// The [Listenable] object being monitored is passed to [listenable].
  ///
  /// 変更があった場合に更新する[Widget]をビルドするためのビルダー。
  ///
  /// [listenable]に監視している[Listenable]オブジェクトが渡されます。
  final Widget Function(BuildContext context, T listenable) builder;

  @override
  @protected
  State<StatefulWidget> createState() => _ListenableListenerState<T>();
}

class _ListenableListenerState<T extends Listenable>
    extends State<ListenableListener<T>> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_handledOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    widget.listenable.removeListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(ListenableListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_handledOnUpdate);
      widget.listenable.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.listenable);
  }
}
