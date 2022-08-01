part of masamune_firebase_messaging;

Future<void> _onBackgroundMessage(RemoteMessage message) =>
    FirebaseMessagingCore._onBackgroundMessage(message);

class FirebaseMessagingCore {
  FirebaseMessagingCore._();

  static FirebaseMessagingModel get _messaging {
    return readProvider(firebaseMessagingProvider);
  }

  static Future<FirebaseMessagingModel> initialize(
    BuildContext context, {
    required String serverKey,
    String androidNotificationChannelId = "masamune_firebase_messaging_channel",
    String androidNotificationChannelTitle = "Important Notification",
    String androidNotificationChannelDescription =
        "This notification channel is used for important notifications.",
    List<void Function(MessagingValue message)> callback = const [],
    List<String> subscribe = const [],
  }) =>
      _messaging.initialize(
        context,
        androidNotificationChannelId: androidNotificationChannelId,
        androidNotificationChannelTitle: androidNotificationChannelTitle,
        androidNotificationChannelDescription:
            androidNotificationChannelDescription,
        serverKey: serverKey,
        callback: callback,
        subscribe: subscribe,
      );

  static FirebaseMessagingModel listen(
    void Function(MessagingValue message) callback,
  ) =>
      _messaging.listen(callback);

  static FirebaseMessagingModel unlisten(
    void Function(MessagingValue message) callback,
  ) =>
      _messaging.unlisten(callback);

  static FirebaseMessagingModel unlistenAll() => _messaging.unlistenAll();

  /// Send a message to a specific topic.
  ///
  /// [title]: Notification Title.
  /// [text]: Notification Text.
  /// [topic]: Destination topic.
  /// [data]: Data to be included in the notification.
  static Future<FirebaseMessagingModel> send({
    required String title,
    required String text,
    required String topic,
    String? path,
    DynamicMap? data,
  }) =>
      _messaging.send(
        title: title,
        text: text,
        topic: topic,
        path: path,
        data: data,
      );

  /// Subscribe to a new topic.
  ///
  /// [topic]: The topic you want to subscribe to.
  static FirebaseMessagingModel subscribe(String topic) =>
      _messaging.subscribe(topic);

  /// The topic you want to unsubscribe.
  ///
  /// [topic]: The topic you want to unsubscribe to.
  static FirebaseMessagingModel unsubscribe(String topic) =>
      _messaging.unsubscribe(topic);

  static Future<void> _onBackgroundMessage(RemoteMessage message) =>
      _messaging._onBackgroundMessageHandler(message);

  static MessagingValue? get currentValue {
    return _messaging.value;
  }
}
