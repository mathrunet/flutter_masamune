part of masamune_local_messaging;

class LocalMessagingCore {
  LocalMessagingCore._();

  static LocalMessagingModel get _messaging {
    return readProvider(localeMessagingProvider);
  }

  static Future<LocalMessagingModel> initialize(
    BuildContext context, {
    List<void Function(MessagingValue message)> callback = const [],
    String androidDefaultIcon = "@mipmap/ic_launcher",
  }) async {
    return _messaging.initialize(
      context,
      callback: callback,
      androidDefaultIcon: androidDefaultIcon,
    );
  }

  static Future<void> send({
    required String topic,
    required String title,
    required String text,
    String? path,
    DynamicMap? data,
    String androidChannelId = "defaultChannel",
    String androidChannelName = "Default Channel",
  }) async {
    return _messaging.send(
      topic: topic,
      title: title,
      text: text,
      path: path,
      data: data,
      androidChannelId: androidChannelId,
      androidChannelName: androidChannelName,
    );
  }

  static Future<void> schedule({
    required String topic,
    required String title,
    required String text,
    required DateTime dateTime,
    MessagingScheduleRepeatType repeatType = MessagingScheduleRepeatType.none,
    String? path,
    DynamicMap? data,
    String androidChannelId = "defaultChannel",
    String androidChannelName = "Default Channel",
  }) async {
    return _messaging.schedule(
      topic: topic,
      title: title,
      text: text,
      dateTime: dateTime,
      path: path,
      data: data,
      androidChannelId: androidChannelId,
      androidChannelName: androidChannelName,
    );
  }

  static LocalMessagingModel listen(
    void Function(MessagingValue message) callback,
  ) =>
      _messaging.listen(callback);

  static LocalMessagingModel unlisten(
    void Function(MessagingValue message) callback,
  ) =>
      _messaging.unlisten(callback);

  static LocalMessagingModel unlistenAll() => _messaging.unlistenAll();

  static Future<void> cancelSchedule(
    String topic,
  ) async {
    return _messaging.cancelSchedule(
      topic,
    );
  }

  static Future<void> cancelAllSchedule() async {
    return _messaging.cancelAllSchedule();
  }

  static MessagingValue? get currentValue {
    return _messaging.value;
  }
}
