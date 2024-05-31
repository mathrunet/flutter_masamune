part of "/masamune_notification_local.dart";

/// [MasamuneAdapter] for receiving local PUSH notifications for mobile.
///
/// モバイル用のローカルPUSH通知を受信するための[MasamuneAdapter]です。
class MobileLocalNotificationMasamuneAdapter
    extends LocalNotificationMasamuneAdapter {
  /// [MasamuneAdapter] for receiving local PUSH notifications for mobile.
  ///
  /// モバイル用のローカルPUSH通知を受信するための[MasamuneAdapter]です。
  const MobileLocalNotificationMasamuneAdapter({
    super.loggerAdapters = const [],
    super.onLink,
    super.onRetrievedToken,
  });
}
