part of masamune;

extension WidgetRefUuidExtensions on WidgetRef {
  String useUuid([String key = ""]) {
    return valueBuilder<String, _UuidValue>(
      key: "uuid:$key",
      builder: () {
        return const _UuidValue();
      },
    );
  }
}

class _UuidValue extends ScopedValue<String> {
  const _UuidValue();
  @override
  ScopedValueState<String, ScopedValue<String>> createState() =>
      _UuidValueState();
}

class _UuidValueState extends ScopedValueState<String, _UuidValue> {
  final String id = uuid;
  @override
  String build() => id;
}

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
