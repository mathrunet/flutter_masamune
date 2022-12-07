part of katana_media;

abstract class MediaAdapter {
  const MediaAdapter();

  /// You can retrieve the [MediaAdapter] first given by [MediaAdapterScope].
  ///
  /// 最初に[MediaAdapterScope]で与えた[MediaAdapter]を取得することができます。
  static MediaAdapter get primary {
    assert(
      _primary != null,
      "MediaAdapter is not set. Place [MediaAdapterScope] widget closer to the root.",
    );
    return _primary ?? const FilePickerMediaAdapter();
  }

  static MediaAdapter? _primary;

  Future<MediaValue> pickSingle({
    String? dialogTitle,
    MediaType type = MediaType.others,
  });

  Future<List<MediaValue>> pickMultiple({
    String? dialogTitle,
    MediaType type = MediaType.others,
  });

  Future<MediaValue> pickCamera({
    String? dialogTitle,
    MediaType type = MediaType.others,
  });
}

class MediaAdapterScope extends StatefulWidget {
  const MediaAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [MediaAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[MediaAdapter]。
  final MediaAdapter adapter;

  /// By passing [context], the [MediaAdapter] set in [MediaAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [MediaAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[MediaAdapterScope]で設定された[MediaAdapter]を取得することができます。
  ///
  /// 祖先に[MediaAdapterScope]がない場合はエラーになります。
  static MediaAdapter? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_MediaAdapterScope>();
    assert(
      scope != null,
      "MediaAdapterScope is not found. Place [MediaAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _MediaAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _MediaAdapterScopeState();
}

class _MediaAdapterScopeState extends State<MediaAdapterScope> {
  @override
  void initState() {
    super.initState();
    MediaAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _MediaAdapterScope(child: widget.child, adapter: widget.adapter);
  }
}

class _MediaAdapterScope extends InheritedWidget {
  const _MediaAdapterScope({
    required super.child,
    required this.adapter,
  });

  final MediaAdapter adapter;

  @override
  bool updateShouldNotify(covariant _MediaAdapterScope oldWidget) => false;
}
