part of firebase_model_notifier;

DynamicMap _buildCounterUpdate({
  required String? key,
  required num? value,
  bool enabled = true,
  List<CounterUpdaterInterval> counterIntervals = const [],
}) {
  if (!enabled || key == null || value == null) {
    return {};
  }
  final now = DateTime.now();
  final map = {key: FieldValue.increment(value)};
  for (final interval in counterIntervals) {
    switch (interval) {
      case CounterUpdaterInterval.daily:
        map[dailyKey(key, now)] = FieldValue.increment(value);
        for (var i = 0; i < 30; i++) {
          map[dailyKey(
            key,
            DateTime(now.year, now.month, now.day - 60 + i),
          )] = FieldValue.delete();
        }
        break;
      case CounterUpdaterInterval.monthly:
        map[monthlyKey(key, now)] = FieldValue.increment(value);
        for (var i = 0; i < 12; i++) {
          map[monthlyKey(key, DateTime(now.year, now.month - 24 + i))] =
              FieldValue.delete();
        }
        break;
      case CounterUpdaterInterval.yearly:
        map[yearlyKey(key, now)] = FieldValue.increment(value);
        for (var i = 0; i < 5; i++) {
          map[yearlyKey(key, DateTime(now.year, now.month - 10 + i))] =
              FieldValue.delete();
        }
        break;
      case CounterUpdaterInterval.weekly:
        map[weeklyKey(key, now)] = FieldValue.increment(value);
        for (var i = 0; i < 4; i++) {
          map[weeklyKey(
            key,
            DateTime(now.year, now.month, now.day - ((8 - i) * 7)),
          )] = FieldValue.delete();
        }
        break;
    }
  }
  return map;
}
