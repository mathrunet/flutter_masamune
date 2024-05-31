part of '/masamune_notification.dart';

/// [MasamuneAdapter] to receive local PUSH notifications for testing.
///
/// テスト用のローカルPUSH通知を受信するための[MasamuneAdapter]です。
class RuntimeLocalNotificationMasamuneAdapter
    extends LocalNotificationMasamuneAdapter {
  /// [MasamuneAdapter] to receive local PUSH notifications for testing.
  ///
  /// テスト用のローカルPUSH通知を受信するための[MasamuneAdapter]です。
  const RuntimeLocalNotificationMasamuneAdapter({
    super.loggerAdapters = const [],
    super.onLink,
    super.onRetrievedToken,
  });
}
