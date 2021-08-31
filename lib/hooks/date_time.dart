part of masamune;

class _DateTimeHookCreator {
  const _DateTimeHookCreator();

  /// Create a constant date time.
  DateTime call([DateTime? initialDateTime]) {
    return use(_DateTimeHook(initialDateTime));
  }
}

class _NowHookCreator {
  const _NowHookCreator();

  /// Create a constant date time.
  DateTime call() {
    return use(_DateTimeHook());
  }
}

/// Create a constant date time.
const useDateTime = _DateTimeHookCreator();

/// Create a constant date time.
const useNow = _NowHookCreator();

class _DateTimeHook extends Hook<DateTime> {
  _DateTimeHook([this.initialDateTime])
      : super(keys: [
          if (initialDateTime != null) initialDateTime,
        ]);
  final DateTime? initialDateTime;

  @override
  _DateTimeHookState createState() {
    return _DateTimeHookState(initialDateTime);
  }
}

class _DateTimeHookState extends HookState<DateTime, _DateTimeHook> {
  _DateTimeHookState([this.initialDateTime]);
  late final DateTime _dateTime;
  final DateTime? initialDateTime;
  @override
  void initHook() {
    _dateTime = initialDateTime ?? DateTime.now();
  }

  @override
  DateTime build(BuildContext context) => _dateTime;

  @override
  String get debugLabel => 'useDateTime';
}
