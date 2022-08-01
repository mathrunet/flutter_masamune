part of masamune_local_messaging;

final localeMessagingProvider = ChangeNotifierProvider(
  (_) => LocalMessagingModel(),
);

class LocalMessagingModel extends ValueModel<MessagingValue?> {
  LocalMessagingModel() : super(null);

  @protected
  final FlutterLocalNotificationsPlugin messaging =
      FlutterLocalNotificationsPlugin();

  BuildContext get context => _navigator.context;
  late final NavigatorState _navigator;
  final List<void Function(MessagingValue message)> _callback = [];

  /// True if the billing system has been initialized.
  bool get initialized => _initialized;
  bool _initialized = false;

  Future<LocalMessagingModel> initialize(
    BuildContext context, {
    List<void Function(MessagingValue message)> callback = const [],
    String androidDefaultIcon = "@mipmap/ic_launcher",
  }) async {
    if (Config.isWeb) {
      throw Exception("This platform is not supported.");
    }
    if (initialized) {
      return this;
    }
    if (callback.isNotEmpty) {
      _callback.addAll(callback);
    }
    _navigator = Navigator.of(context, rootNavigator: true);
    await messaging.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings(androidDefaultIcon),
        iOS: const IOSInitializationSettings(),
      ),
      onSelectNotification: _handledOnRecieved,
    );
    _initialized = true;
    return this;
  }

  void _handledOnRecieved(String? message) {
    if (message.isEmpty) {
      return;
    }
    final json = jsonDecodeAsMap(message!);
    value = MessagingValue(
      title: json.get(Const.name, ""),
      text: json.get(Const.text, ""),
      topic: json.get(Const.uid, ""),
      path: json.get("path", ""),
      data: json,
    );
    for (final callback in _callback) {
      callback.call(value!);
    }
  }

  Future<void> send({
    required String topic,
    required String title,
    required String text,
    String? path,
    DynamicMap? data,
    String androidChannelId = "defaultChannel",
    String androidChannelName = "Default Channel",
  }) async {
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return;
    }
    final payload = jsonEncode({
      if (data.isNotEmpty) ...data!,
      if (path.isNotEmpty) "path": path,
    });
    await messaging.show(
      topic.hashCode,
      title,
      text,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannelId,
          androidChannelName.localize(),
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }

  Future<void> schedule({
    required String topic,
    required String title,
    required String text,
    required DateTime dateTime,
    String? path,
    DynamicMap? data,
    MessagingScheduleRepeatType repeatType = MessagingScheduleRepeatType.none,
    String androidChannelId = "defaultChannel",
    String androidChannelName = "Default Channel",
  }) async {
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return;
    }
    final payload = jsonEncode({
      if (data.isNotEmpty) ...data!,
      if (path.isNotEmpty) "path": path,
    });
    await messaging.zonedSchedule(
      topic.hashCode,
      title,
      text,
      tz.TZDateTime.from(dateTime, tz.UTC),
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannelId,
          androidChannelName.localize(),
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: payload,
      matchDateTimeComponents: _convertRepeatType(repeatType),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  LocalMessagingModel listen(
    void Function(MessagingValue message) callback,
  ) {
    if (Config.isWeb) {
      throw Exception("This platform is not supported.");
    }
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return this;
    }
    if (!_callback.contains(callback)) {
      _callback.add(callback);
    }
    return this;
  }

  LocalMessagingModel unlisten(
    void Function(MessagingValue message) callback,
  ) {
    if (Config.isWeb) {
      throw Exception("This platform is not supported.");
    }
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return this;
    }
    _callback.remove(callback);
    return this;
  }

  LocalMessagingModel unlistenAll() {
    if (Config.isWeb) {
      throw Exception("This platform is not supported.");
    }
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return this;
    }
    _callback.clear();
    return this;
  }

  DateTimeComponents _convertRepeatType(
    MessagingScheduleRepeatType repeatType,
  ) {
    switch (repeatType) {
      case MessagingScheduleRepeatType.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case MessagingScheduleRepeatType.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      default:
        return DateTimeComponents.dateAndTime;
    }
  }

  Future<void> cancelSchedule(
    String topic,
  ) async {
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return;
    }
    await messaging.cancel(
      topic.hashCode,
    );
  }

  Future<void> cancelAllSchedule() async {
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return;
    }
    await messaging.cancelAll();
  }
}
