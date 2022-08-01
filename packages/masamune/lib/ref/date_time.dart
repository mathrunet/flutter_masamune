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
