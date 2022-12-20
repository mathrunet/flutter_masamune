part of katana_picker;

abstract class PickerAdapter {
  const PickerAdapter();

  /// You can retrieve the [PickerAdapter] first given by [PickerAdapterScope].
  ///
  /// 最初に[PickerAdapterScope]で与えた[PickerAdapter]を取得することができます。
  static PickerAdapter get primary {
    assert(
      _primary != null,
      "MediaAdapter is not set. Place [MediaAdapterScope] widget closer to the root.",
    );
    return _primary ?? const FilePickerAdapter();
  }

  static PickerAdapter? _primary;

  Future<PickerValue> pickSingle({
    String? dialogTitle,
    PickerMediaType type = PickerMediaType.others,
  });

  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerMediaType type = PickerMediaType.others,
  });

  Future<PickerValue> pickCamera({
    String? dialogTitle,
    PickerMediaType type = PickerMediaType.others,
  });
}

class PickerAdapterScope extends StatefulWidget {
  const PickerAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [PickerAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[PickerAdapter]。
  final PickerAdapter adapter;

  /// By passing [context], the [PickerAdapter] set in [PickerAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [PickerAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[PickerAdapterScope]で設定された[PickerAdapter]を取得することができます。
  ///
  /// 祖先に[PickerAdapterScope]がない場合はエラーになります。
  static PickerAdapter? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_PickerAdapterScope>();
    assert(
      scope != null,
      "PickerAdapterScope is not found. Place [PickerAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _PickerAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _PickerAdapterScopeState();
}

class _PickerAdapterScopeState extends State<PickerAdapterScope> {
  @override
  void initState() {
    super.initState();
    PickerAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _PickerAdapterScope(child: widget.child, adapter: widget.adapter);
  }
}

class _PickerAdapterScope extends InheritedWidget {
  const _PickerAdapterScope({
    required super.child,
    required this.adapter,
  });

  final PickerAdapter adapter;

  @override
  bool updateShouldNotify(covariant _PickerAdapterScope oldWidget) => false;
}
