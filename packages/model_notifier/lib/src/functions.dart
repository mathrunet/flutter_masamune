part of model_notifier;

/// Gets the key for the date associated with [key].
///
/// If [time] is specified, the key at that time is obtained.
String dailyKey(String key, [DateTime? time]) {
  time ??= DateTime.now();
  return "$key:${time.format("yyyyMMdd")}";
}

/// Gets the key for the week associated with [key].
///
/// If [time] is specified, the key at that time is obtained.
String weeklyKey(String key, [DateTime? time]) {
  time ??= DateTime.now();
  return "$key:${time.format("yyyyww")}";
}

/// Gets the key of the month associated with [key].
///
/// If [time] is specified, the key at that time is obtained.
String monthlyKey(String key, [DateTime? time]) {
  time ??= DateTime.now();
  return "$key:${time.format("yyyyMM")}";
}

/// Gets the key for the year associated with [key].
///
/// If [time] is specified, the key at that time is obtained.
String yearlyKey(String key, [DateTime? time]) {
  time ??= DateTime.now();
  return "$key:${time.format("yyyy")}";
}

DynamicMap _buildCounterUpdate({
  required DynamicMap map,
  required String? key,
  required num? value,
  bool enabled = true,
  List<CounterUpdaterInterval> counterIntervals = const [],
}) {
  if (!enabled || key == null || value == null) {
    return map;
  }
  final now = DateTime.now();
  map[key] = map.get(key, 0) + value;
  for (final interval in counterIntervals) {
    switch (interval) {
      case CounterUpdaterInterval.daily:
        final k = dailyKey(key, now);
        map[k] = map.get(k, 0) + value;
        for (var i = 0; i < 30; i++) {
          map[dailyKey(
            key,
            DateTime(now.year, now.month, now.day - 60 + i),
          )] = null;
        }
        break;
      case CounterUpdaterInterval.monthly:
        final k = monthlyKey(key, now);
        map[k] = map.get(k, 0) + value;
        for (var i = 0; i < 12; i++) {
          map[monthlyKey(key, DateTime(now.year, now.month - 24 + i))] = null;
        }
        break;
      case CounterUpdaterInterval.yearly:
        final k = yearlyKey(key, now);
        map[k] = map.get(k, 0) + value;
        for (var i = 0; i < 5; i++) {
          map[yearlyKey(key, DateTime(now.year, now.month - 10 + i))] = null;
        }
        break;
      case CounterUpdaterInterval.weekly:
        final k = weeklyKey(key, now);
        map[k] = map.get(k, 0) + value;
        for (var i = 0; i < 4; i++) {
          map[weeklyKey(
            key,
            DateTime(now.year, now.month, now.day - ((8 - i) * 7)),
          )] = null;
        }
        break;
    }
  }
  return map;
}
