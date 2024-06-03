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
    super.defaultTimezone = "UTC",
    super.localNotification,
    super.modelAdapter,
  });

  @override
  Future<int?> listen() => Future.value(null);

  @override
  Future<int?> addSchedule(
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
    String? timezone,
  }) =>
      Future.value();

  @override
  Future<void> removeAllSchedule() => Future.value();

  @override
  Future<int?> removeSchedule(String uid) => Future.value();
}
