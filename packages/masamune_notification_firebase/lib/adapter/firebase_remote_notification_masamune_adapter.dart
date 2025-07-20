part of "/masamune_notification_firebase.dart";

/// [MasamuneAdapter] for receiving remote PUSH notifications for Firebase.
///
/// Firebase用のリモートPUSH通知を受信するための[MasamuneAdapter]です。
class FirebaseRemoteNotificationMasamuneAdapter
    extends RemoteNotificationMasamuneAdapter {
  /// [MasamuneAdapter] for receiving remote PUSH notifications for Firebase.
  ///
  /// Firebase用のリモートPUSH通知を受信するための[MasamuneAdapter]です。
  const FirebaseRemoteNotificationMasamuneAdapter({
    required super.androidNotificationChannelId,
    required super.androidNotificationChannelTitle,
    required super.androidNotificationChannelDescription,
    super.functionsAdapter,
    super.modelAdapter,
    super.remoteNotification,
    super.subscribeOnBoot = const [],
    super.listenOnBoot = false,
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.windowsOptions,
    this.macosOptions,
    this.linuxOptions,
    super.loggerAdapters = const [],
    super.onLink,
    super.onRetrievedToken,
  }) : _options = options;

  static const _platformInfo = PlatformInfo();

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (_platformInfo.isIOS) {
      return iosOptions ?? _options;
    } else if (_platformInfo.isAndroid) {
      return androidOptions ?? _options;
    } else if (_platformInfo.isWeb) {
      return webOptions ?? _options;
    } else if (_platformInfo.isLinux) {
      return linuxOptions ?? _options;
    } else if (_platformInfo.isWindows) {
      return windowsOptions ?? _options;
    } else if (_platformInfo.isMacOS) {
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
  Future<RemoteNotificationListenResponse?> listen({
    required Future<void> Function(NotificationValue value) onMessage,
    required Future<void> Function(NotificationValue value) onMessageOpenedApp,
  }) async {
    await FirebaseCore.initialize(options: options);
    await _messaging.setAutoInitEnabled(true);
    await _getApnsToken().timeout(const Duration(seconds: 30));
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
    // ignore: cancel_subscriptions
    final onMessageSubscription = FirebaseMessaging.onMessage.listen(
      (message) => _onMessage(message, onMessage),
    );
    // ignore: cancel_subscriptions
    final onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _onMessageOpenedApp(message, onMessageOpenedApp),
    );
    if (initialMessage != null) {
      await _onMessageOpenedApp(initialMessage, onMessageOpenedApp);
    }
    return RemoteNotificationListenResponse(
      onMessageOpenedAppSubscription: onMessageOpenedAppSubscription,
      onMessageSubscription: onMessageSubscription,
    );
  }

  Future<void> _getApnsToken() async {
    if (_platformInfo.isIOS || _platformInfo.isMacOS) {
      String? apnsToken;
      do {
        apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          break;
        }
        await Future.delayed(const Duration(seconds: 1));
      } while (apnsToken == null);
    }
  }

  Future<void> _onMessage(RemoteMessage message,
      Future<void> Function(NotificationValue value) onMessage) async {
    final data = message.data;
    await onMessage.call(
      NotificationValue(
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
    Future<void> Function(NotificationValue value) onMessageOpenedApp,
  ) async {
    final data = message.data;
    await onMessageOpenedApp.call(
      NotificationValue(
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
