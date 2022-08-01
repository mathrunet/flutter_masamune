part of model_notifier;

/// The period of time for counting up and tallying the values.
enum CounterUpdaterInterval {
  /// Daily.
  daily,

  /// Weekly.
  weekly,

  /// Monthly.
  monthly,

  /// Yearly.
  yearly,
}
