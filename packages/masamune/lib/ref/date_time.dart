part of masamune;

@deprecated
extension WidgetRefDateTimeExtensions on WidgetRef {
  @Deprecated(
    "It will not be available from the next version. Use [DateTimeProvider] instead.",
  )
  DateTime useNow() {
    return valueBuilder<DateTime, _DateTimeValue>(
      key: "dateTimeNow",
      builder: () {
        return const _DateTimeValue();
      },
    );
  }

  @Deprecated(
    "It will not be available from the next version. Use [DateTimeProvider] instead.",
  )
  DateTime useDateTime(DateTime dateTime, {String hookId = ""}) {
    return valueBuilder<DateTime, _DateTimeValue>(
      key: "dateTime:$hookId",
      builder: () {
        return _DateTimeValue(dateTime);
      },
    );
  }
}

@deprecated
class _DateTimeValue extends ScopedValue<DateTime> {
  const _DateTimeValue([this.dateTime]);
  final DateTime? dateTime;
  @override
  ScopedValueState<DateTime, ScopedValue<DateTime>> createState() =>
      _DateTimeValueState();
}

@deprecated
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
