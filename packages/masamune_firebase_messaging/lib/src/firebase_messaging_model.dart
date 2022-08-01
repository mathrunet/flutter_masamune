part of masamune_firebase_messaging;

final firebaseMessagingProvider = ChangeNotifierProvider(
  (_) => FirebaseMessagingModel(),
);

Future<void> _onInitialBackgroundMessage(RemoteMessage message) async {}

class FirebaseMessagingModel extends ValueModel<MessagingValue?> {
  FirebaseMessagingModel() : super(null);

  @protected
  FirebaseMessaging get messaging {
    return FirebaseMessaging.instance;
  }

  late final String serverKey;

  final List<void Function(MessagingValue message)> _callback = [];

  BuildContext get context => _navigator.context;
  late final NavigatorState _navigator;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  late final String _androidNotificationChannelId;

  Future<FirebaseMessagingModel> initialize(
    BuildContext context, {
    required String serverKey,
    String androidNotificationChannelId = "masamune_firebase_messaging_channel",
    String androidNotificationChannelTitle = "Important Notification",
    String androidNotificationChannelDescription =
        "This notification channel is used for important notifications.",
    List<void Function(MessagingValue message)> callback = const [],
    List<String> subscribe = const [],
  }) async {
    if (Config.isWeb) {
      throw Exception("This platform is not supported.");
    }
    _navigator = Navigator.of(context, rootNavigator: true);
    this.serverKey = serverKey;
    if (callback.isNotEmpty) {
      _callback.addAll(callback);
    }
    await _initialize(
      androidNotificationChannelId: androidNotificationChannelId,
      androidNotificationChannelTitle: androidNotificationChannelTitle,
      androidNotificationChannelDescription:
          androidNotificationChannelDescription,
    );
    subscribe.forEach((topic) {
      _subscribe(topic);
    });
    return this;
  }

  FirebaseMessagingModel listen(
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

  FirebaseMessagingModel unlisten(
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

  FirebaseMessagingModel unlistenAll() {
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

  /// Send a message to a specific topic.
  ///
  /// [title]: Notification Title.
  /// [text]: Notification Text.
  /// [topic]: Destination topic.
  /// [data]: Data to be included in the notification.
  Future<FirebaseMessagingModel> send({
    required String title,
    required String text,
    required String topic,
    String? path,
    DynamicMap? data,
  }) async {
    if (Config.isWeb) {
      throw Exception("This platform is not supported.");
    }
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return this;
    }
    assert(
      title.isNotEmpty && text.isNotEmpty,
      "There is no information in the message.",
    );
    assert(topic.isNotEmpty, "You have not specified a topic.");
    assert(serverKey.isNotEmpty, "The server key is not set.");
    try {
      data ??= {};
      if (path.isNotEmpty) {
        data["path"] = path;
      }
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode(
          <String, dynamic>{
            "notification": <String, dynamic>{
              "title": title,
              "body": text,
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "channel_id": _androidNotificationChannelId,
              "android_channel_id": _androidNotificationChannelId,
            },
            "priority": "high",
            "data": data,
            "to": "/topics/$topic",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
    return this;
  }

  /// Subscribe to a new topic.
  ///
  /// [topic]: The topic you want to subscribe to.
  FirebaseMessagingModel subscribe(String topic) {
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return this;
    }
    assert(topic.isNotEmpty, "You have not specified a topic.");
    _subscribe(topic);
    return this;
  }

  /// The topic you want to unsubscribe.
  ///
  /// [topic]: The topic you want to unsubscribe to.
  FirebaseMessagingModel unsubscribe(String topic) {
    if (!initialized) {
      debugPrint(
        "It has not been initialized. Please initialize it by executing [initialize()].",
      );
      return this;
    }
    assert(topic.isNotEmpty, "You have not specified a topic.");
    _unsubscribe(topic);
    return this;
  }

  @override
  void dispose() {
    super.dispose();
    _callback.clear();
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    FirebaseMessaging.onBackgroundMessage(_onInitialBackgroundMessage);
  }

  Future<void> _initialize({
    required String androidNotificationChannelId,
    required String androidNotificationChannelTitle,
    required String androidNotificationChannelDescription,
  }) async {
    _androidNotificationChannelId = androidNotificationChannelId;
    await FirebaseCore.initialize();
    await messaging.setAutoInitEnabled(true);
    await messaging.getToken();
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(_onMessage);
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    if (Config.isAndroid) {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            AndroidNotificationChannel(
              androidNotificationChannelId,
              androidNotificationChannelTitle,
              description: androidNotificationChannelDescription,
              importance: Importance.max,
            ),
          );
    } else {
      await messaging.setForegroundNotificationPresentationOptions(
        sound: true,
        badge: true,
        alert: true,
      );
    }
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _initialized = true;
  }

  @override
  bool get notifyOnChangeValue => false;

  Future<void> _onMessage(RemoteMessage message) async {
    final data = message.data;
    value = MessagingValue(
      title: message.notification?.title ?? "",
      text: message.notification?.body ?? "",
      path: data.get("path", nullOfString),
      data: data,
      topic: message.from ?? "",
      onOpenedApp: false,
    );
    _callback.forEach((element) => element.call(value!));
    notifyListeners();
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    final data = message.data;
    value = MessagingValue(
      title: message.notification?.title ?? "",
      text: message.notification?.body ?? "",
      path: data.get("path", nullOfString),
      data: data,
      topic: message.from ?? "",
      onOpenedApp: true,
    );
    _callback.forEach((element) => element.call(value!));
    notifyListeners();
  }

  Future<void> _onBackgroundMessageHandler(RemoteMessage message) async {
    _onMessage(message);
  }

  void _subscribe(String topic) {
    messaging.subscribeToTopic(topic);
  }

  void _unsubscribe(String topic) {
    messaging.unsubscribeFromTopic(topic);
  }

  /// True if the billing system has been initialized.
  bool get initialized => _initialized;
  bool _initialized = false;
}
