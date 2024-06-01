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
    required super.androidNotificationChannelId,
    required super.androidNotificationChannelTitle,
    required super.androidNotificationChannelDescription,
  });

  @override
  Future<NotificationValue?> listen() => Future.value(null);

  @override
  Future<void> addSchedule(
    String uid, {
    required String title,
    required String text,
    required DateTime time,
    int? badgeCount,
    LocalNotificationRepeatSettings repeat =
        LocalNotificationRepeatSettings.none,
    NotificationSound sound = NotificationSound.defaultSound,
    DynamicMap? data,
    Uri? link,
  }) =>
      Future.value();

  @override
  Future<void> removeAllSchedule() => Future.value();

  @override
  Future<void> removeSchedule(String uid) => Future.value();
}
