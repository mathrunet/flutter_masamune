part of masamune;

class _GlobalKeyHookCreator {
  const _GlobalKeyHookCreator();

  /// Create a new global key.
  GlobalKey<T> call<T extends State<StatefulWidget>>() {
    return use(_GlobalKeyHook<T>());
  }
}

/// Create a new global key.
const useGlobalKey = _GlobalKeyHookCreator();

class _GlobalKeyHook<T extends State<StatefulWidget>>
    extends Hook<GlobalKey<T>> {
  const _GlobalKeyHook([
    List<Object?>? keys,
  ]) : super(keys: keys);

  @override
  _GlobalKeyHookState<T> createState() {
    return _GlobalKeyHookState<T>();
  }
}

class _GlobalKeyHookState<T extends State<StatefulWidget>>
    extends HookState<GlobalKey<T>, _GlobalKeyHook<T>> {
  late final GlobalKey<T> _key;
  @override
  void initHook() {
    _key = GlobalKey<T>();
  }

  @override
  GlobalKey<T> build(BuildContext context) => _key;

  @override
  String get debugLabel => 'useGlobalKey';
}
