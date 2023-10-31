part of masamune_notification_firebase;

/// MasamuneAdapter] for receiving PUSH notifications for Firebase.
///
/// Firebase用のPUSH通知を受信するための[MasamuneAdapter]です。
class FirebasePushNotificationMasamuneAdapter
    extends PushNotificationMasamuneAdapter {
  /// MasamuneAdapter] for receiving PUSH notifications for Firebase.
  ///
  /// Firebase用のPUSH通知を受信するための[MasamuneAdapter]です。
  const FirebasePushNotificationMasamuneAdapter({
    super.functionsAdapter,
    super.modelAdapter,
    required super.androidNotificationChannelId,
    required super.androidNotificationChannelTitle,
    required super.androidNotificationChannelDescription,
    super.pushNotification,
    super.subscribeOnBoot = const [],
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.windowsOptions,
    this.macosOptions,
    this.linuxOptions,
    super.loggerAdapters = const [],
    super.onLink,
  }) : _options = options;

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  FirebaseMessaging get _messaging {
    return FirebaseMessaging.instance;
  }

  @override
  Future<String?> getToken() {
    return _messaging.getToken();
  }

  @override
  Future<PushNotificationListenResponse?> listen({
    required Future<void> Function(PushNotificationValue value) onMessage,
    required Future<void> Function(PushNotificationValue value)
        onMessageOpenedApp,
  }) async {
    await FirebaseCore.initialize(options: options);
    await _messaging.setAutoInitEnabled(true);
    final onMessageSubscription = FirebaseMessaging.onMessage.listen(
      (message) => _onMessage(message, onMessage),
    );
    final onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _onMessageOpenedApp(message, onMessageOpenedApp),
    );
    if (!kIsWeb && Platform.isAndroid) {
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
      await _messaging.setForegroundNotificationPresentationOptions(
        sound: true,
        badge: true,
        alert: true,
      );
    }
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _onMessageOpenedApp(initialMessage, onMessageOpenedApp);
    }
    return PushNotificationListenResponse(
      onMessageOpenedAppSubscription: onMessageOpenedAppSubscription,
      onMessageSubscription: onMessageSubscription,
    );
  }

  Future<void> _onMessage(RemoteMessage message,
      Future<void> Function(PushNotificationValue value) onMessage) async {
    final data = message.data;
    onMessage.call(
      PushNotificationValue(
        title: message.notification?.title ?? "",
        text: message.notification?.body ?? "",
        data: data,
        target: message.from ?? "",
        whenAppOpened: false,
      ),
    );
  }

  Future<void> _onMessageOpenedApp(
    RemoteMessage message,
    Future<void> Function(PushNotificationValue value) onMessageOpenedApp,
  ) async {
    final data = message.data;
    onMessageOpenedApp.call(
      PushNotificationValue(
        title: message.notification?.title ?? "",
        text: message.notification?.body ?? "",
        data: data,
        target: message.from ?? "",
        whenAppOpened: true,
      ),
    );
  }

  @override
  Future<void> subscribe(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribe(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
