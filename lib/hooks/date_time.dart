part of masamune;

extension WidgetRefDateTimeExtensions on WidgetRef {
  DateTime useNow() {
    return valueBuilder<DateTime, _DateTimeValue>(
      key: "dateTimeNow",
      builder: () {
        return const _DateTimeValue();
      },
    );
  }

  DateTime useDateTime(String key, DateTime dateTime) {
    return valueBuilder<DateTime, _DateTimeValue>(
      key: "dateTime:$key",
      builder: () {
        return _DateTimeValue(dateTime);
      },
    );
  }
}

class _DateTimeValue extends ScopedValue<DateTime> {
  const _DateTimeValue([this.dateTime]);
  final DateTime? dateTime;
  @override
  ScopedValueState<DateTime, ScopedValue<DateTime>> createState() =>
      _DateTimeValueState();
}

class _DateTimeValueState extends ScopedValueState<DateTime, _DateTimeValue> {
  late final DateTime dateTime;

  @override
  void initValue() {
    super.initValue();
    dateTime = value.dateTime ?? DateTime.now();
  }

  @override
  DateTime build() => dateTime;
}

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
