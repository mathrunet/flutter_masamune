part of katana_storage;

@immutable
abstract class StorageAdapter {
  const StorageAdapter();

  static StorageAdapter get primary {
    assert(
      _primary != null,
      "StorageAdapter is not set. Place [StorageAdapterScope] widget closer to the root.",
    );
    return _primary ?? const RuntimeStorageAdapter();
  }

  static StorageAdapter? _primary;

  String get publicURL;

  Future<String> fetchDownloadURL();

  Future<void> download(String fromPath, String toPath);

  Future<void> upload(String fromPath, String toPath);

  Future<void> uploadWithBytes(Uint8List bytes, String toPath);

  Future<void> delete(String path);
}

class StorageAdapterScope extends StatefulWidget {
  const StorageAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [StorageAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[StorageAdapter]。
  final StorageAdapter adapter;

  /// By passing [context], the [StorageAdapter] set in [StorageAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [StorageAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[StorageAdapterScope]で設定された[StorageAdapter]を取得することができます。
  ///
  /// 祖先に[StorageAdapterScope]がない場合はエラーになります。
  static StorageAdapter? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_StorageAdapterScope>();
    assert(
      scope != null,
      "StorageAdapterScope is not found. Place [StorageAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _StorageAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _StorageAdapterScopeState();
}

class _StorageAdapterScopeState extends State<StorageAdapterScope> {
  @override
  void initState() {
    super.initState();
    StorageAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _StorageAdapterScope(child: widget.child, adapter: widget.adapter);
  }
}

class _StorageAdapterScope extends InheritedWidget {
  const _StorageAdapterScope({
    required super.child,
    required this.adapter,
  });

  final StorageAdapter adapter;

  @override
  bool updateShouldNotify(covariant _StorageAdapterScope oldWidget) => false;
}
