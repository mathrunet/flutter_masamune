part of katana_module;

/// Class for storing information for push messaging.
abstract class MessagingAdapter<T extends MessagingValue>
    extends AdapterModule {
  const MessagingAdapter();

  /// Initialization.
  Future<void> initialize(
    BuildContext context, {
    List<void Function(T messaging)> callback = const [],
    List<String> subscribe = const [],
  });

  /// Listen for new messages.
  void listen(void Function(T messaging) callback);

  /// Releases a message that is already listening.
  void unlisten(void Function(T messaging) callback);

  /// Remove all listening.
  void unlistenAll();

  /// Send a message to a specific topic.
  Future<void> send({
    required String title,
    required String text,
    required String topic,
    String? path,
    DynamicMap? data,
  });

  /// Schedule a message to a specific topic.
  Future<void> schedule({
    required String title,
    required String text,
    required String topic,
    required DateTime dateTime,
    String? path,
    DynamicMap? data,
    MessagingScheduleRepeatType repeatType = MessagingScheduleRepeatType.none,
  });

  /// Cancel a scheduled message.
  Future<void> cancelSchedule(
    String topic,
  );

  /// Cancel all scheduled message.
  Future<void> cancelAllSchedule();

  /// Subscribe to a new topic.
  void subscribe(String topic);

  /// The topic you want to unsubscribe.
  void unsubscribe(String topic);

  /// Current value.
  MessagingValue? get currentValue;
}

/// A repetitive type of messaging schedule.
enum MessagingScheduleRepeatType {
  /// Not to be repeated.
  none,

  /// Weekly.
  weekly,

  /// Monthly.
  monthly,
}
