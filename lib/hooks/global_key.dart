part of masamune;

extension WidgetRefGlobalKeyExtensions on WidgetRef {
  GlobalKey<T> useGlobalKey<T extends State<StatefulWidget>>() {
    return valueBuilder<GlobalKey<T>, _GlobalKeyValue<T>>(
      key: "globalKey:${T.toString()}",
      builder: () {
        return _GlobalKeyValue<T>();
      },
    );
  }
}

class _GlobalKeyValue<T extends State> extends ScopedValue<GlobalKey<T>> {
  const _GlobalKeyValue();
  @override
  ScopedValueState<GlobalKey<T>, ScopedValue<GlobalKey<T>>> createState() =>
      _GlobalKeyValueState<T>();
}

class _GlobalKeyValueState<T extends State>
    extends ScopedValueState<GlobalKey<T>, _GlobalKeyValue<T>> {
  final GlobalKey<T> key = GlobalKey<T>();
  @override
  GlobalKey<T> build() => key;
}

@immutable
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
