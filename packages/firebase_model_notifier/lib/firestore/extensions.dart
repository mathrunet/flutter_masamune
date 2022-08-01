part of firebase_model_notifier;

extension FirestoreDynamicDocumentModelExtensions
    on FirestoreDynamicDocumentModel {
  /// Add a field for notification.
  ///
  /// Functions need to be deployed.
  ///
  /// The content of the notification in [title] and [text].
  /// You can set the notification time with [time].
  ///
  /// Execute [save] to apply the changes.
  FirestoreDynamicDocumentModel setNotificationField({
    required String title,
    required String text,
    required DateTime time,
    String timeKey = MetaConst.pushTime,
    String titleKey = MetaConst.pushName,
    String textKey = MetaConst.pushText,
  }) {
    assert(title.isNotEmpty, "The title is empty.");
    assert(text.isNotEmpty, "The text is empty.");
    assert(timeKey.isNotEmpty, "The time key is empty.");
    assert(titleKey.isNotEmpty, "The title key is empty.");
    assert(textKey.isNotEmpty, "The text key is empty.");
    this[timeKey] = Timestamp.fromDate(time);
    this[titleKey] = title;
    this[textKey] = text;
    return this;
  }

  /// The value of [key] can be increased (or decreased by minus) by [value].
  ///
  /// It is possible to increase within a period of time with [intervals].
  ///
  /// When creating monthly rankings, etc., specify [intervals].
  ///
  /// Execute [save] to apply the changes.
  FirestoreDynamicDocumentModel increment(
    String key,
    num value, {
    List<CounterUpdaterInterval> intervals = const [],
  }) {
    this[key] = FieldValue.increment(value);
    if (intervals.isEmpty) {
      return this;
    }
    final now = DateTime.now();
    for (final interval in intervals) {
      switch (interval) {
        case CounterUpdaterInterval.daily:
          this[dailyKey(key, now)] = FieldValue.increment(value);
          for (var i = 0; i < 30; i++) {
            this[dailyKey(
              key,
              DateTime(now.year, now.month, now.day - 60 + i),
            )] = FieldValue.delete();
          }
          break;
        case CounterUpdaterInterval.monthly:
          this[monthlyKey(key, now)] = FieldValue.increment(value);
          for (var i = 0; i < 12; i++) {
            this[monthlyKey(
              key,
              DateTime(now.year, now.month - 24 + i),
            )] = FieldValue.delete();
          }
          break;
        case CounterUpdaterInterval.yearly:
          this[yearlyKey(key, now)] = FieldValue.increment(value);
          for (var i = 0; i < 5; i++) {
            this[yearlyKey(key, DateTime(now.year, now.month - 10 + i))] =
                FieldValue.delete();
          }
          break;
        case CounterUpdaterInterval.weekly:
          this[weeklyKey(key, now)] = FieldValue.increment(value);
          for (var i = 0; i < 4; i++) {
            this[weeklyKey(
              key,
              DateTime(now.year, now.month, now.day - ((8 - i) * 7)),
            )] = FieldValue.delete();
          }
          break;
      }
    }
    return this;
  }

  /// Delete the [key] field.
  ///
  /// Execute [save] to apply the changes.
  FirestoreDynamicDocumentModel deleteField(String key) {
    this[key] = FieldValue.delete();
    return this;
  }

  /// Assign a server-side timestamp to the [key] field.
  ///
  /// Execute [save] to apply the changes.
  FirestoreDynamicDocumentModel timestamp(String key) {
    this[key] = FieldValue.serverTimestamp();
    return this;
  }
}
