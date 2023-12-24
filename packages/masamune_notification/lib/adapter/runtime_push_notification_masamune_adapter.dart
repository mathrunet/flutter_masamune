part of '/masamune_notification.dart';

/// [MasamuneAdapter] to receive PUSH notifications for testing.
///
/// テスト用のPUSH通知を受信するための[MasamuneAdapter]です。
class RuntimePushNotificationMasamuneAdapter
    extends PushNotificationMasamuneAdapter {
  /// [MasamuneAdapter] to receive PUSH notifications for testing.
  ///
  /// テスト用のPUSH通知を受信するための[MasamuneAdapter]です。
  const RuntimePushNotificationMasamuneAdapter({
    super.functionsAdapter,
    super.modelAdapter,
    required super.androidNotificationChannelId,
    required super.androidNotificationChannelTitle,
    required super.androidNotificationChannelDescription,
    super.pushNotification,
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
  Future<PushNotificationListenResponse?> listen({
    required Future<void> Function(PushNotificationValue value) onMessage,
    required Future<void> Function(PushNotificationValue value)
        onMessageOpenedApp,
  }) async {
    return null;
  }

  @override
  Future<void> subscribe(String topic) => Future.value();

  @override
  Future<void> unsubscribe(String topic) => Future.value();
}
