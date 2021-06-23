part of masamune;

class _UuidHookCreator {
  const _UuidHookCreator();

  /// Create a constant uuid.
  String call() {
    return use(const _UuidHook());
  }
}

/// Create a constant uuid.
const useUuid = _UuidHookCreator();

class _UuidHook extends Hook<String> {
  const _UuidHook([
    List<Object?>? keys,
  ]) : super(keys: keys);

  @override
  _UuidHookState createState() {
    return _UuidHookState();
  }
}

class _UuidHookState extends HookState<String, _UuidHook> {
  late final String _uuid;
  @override
  void initHook() {
    _uuid = uuid;
  }

  @override
  String build(BuildContext context) => _uuid;

  @override
  String get debugLabel => 'useUuid';
}
