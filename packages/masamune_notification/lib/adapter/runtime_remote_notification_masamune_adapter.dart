part of "/masamune_notification.dart";

/// [MasamuneAdapter] to receive remote PUSH notifications for testing.
///
/// テスト用のリモートPUSH通知を受信するための[MasamuneAdapter]です。
class RuntimeRemoteNotificationMasamuneAdapter
    extends RemoteNotificationMasamuneAdapter {
  /// [MasamuneAdapter] to receive remote PUSH notifications for testing.
  ///
  /// テスト用のリモートPUSH通知を受信するための[MasamuneAdapter]です。
  const RuntimeRemoteNotificationMasamuneAdapter({
    super.functionsAdapter,
    super.modelAdapter,
    required super.androidNotificationChannelId,
    required super.androidNotificationChannelTitle,
    required super.androidNotificationChannelDescription,
    super.remoteNotification,
    super.subscribeOnBoot = const [],
    super.loggerAdapters = const [],
    super.onLink,
    super.onRetrievedToken,
  });

  static String? _token;

  @override
  Future<String?> getToken() async {
    _token ??= uuid();
    return _token;
  }

  @override
  Future<RemoteNotificationListenResponse?> listen({
    required Future<void> Function(NotificationValue value) onMessage,
    required Future<void> Function(NotificationValue value) onMessageOpenedApp,
  }) async {
    return null;
  }

  @override
  Future<void> subscribe(String topic) => Future.value();

  @override
  Future<void> unsubscribe(String topic) => Future.value();
}
