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
    super.androidDefaultIcon = "@mipmap/ic_launcher",
    required super.androidNotificationChannelId,
    required super.androidNotificationChannelTitle,
    required super.androidNotificationChannelDescription,
  });

  static FlutterLocalNotificationsPlugin get _instance {
    return __instance ??= FlutterLocalNotificationsPlugin();
  }

  static FlutterLocalNotificationsPlugin? __instance;

  static const String _linkKey = "@link";

  @override
  Future<NotificationValue?> listen() async {
    await _requestPermissions();
    await _instance.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings(androidDefaultIcon),
        iOS: const DarwinInitializationSettings(),
      ),
    );
    final notification = await _instance.getNotificationAppLaunchDetails();
    if (notification == null || !notification.didNotificationLaunchApp) {
      return null;
    }
    final payload = notification.notificationResponse?.payload;
    final data = payload != null ? jsonDecodeAsMap(payload) : null;
    return NotificationValue(
      title: "",
      text: "",
      target: notification.notificationResponse?.id.toString() ?? "",
      whenAppOpened: true,
      data: data ?? {},
    );
  }

  @override
  Future<void> addSchedule(
    String uid, {
    required DateTime time,
    required String title,
    required String text,
    int? badgeCount,
    LocalNotificationRepeatSettings repeat =
        LocalNotificationRepeatSettings.none,
    NotificationSound sound = NotificationSound.defaultSound,
    DynamicMap? data,
    Uri? link,
  }) async {
    await _instance.zonedSchedule(
      uid.toRandomInt(),
      title,
      text,
      TZDateTime.from(time, local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotificationChannelId,
          androidNotificationChannelTitle,
          channelDescription: androidNotificationChannelDescription,
          playSound: sound != NotificationSound.none,
          sound: sound != NotificationSound.none
              ? RawResourceAndroidNotificationSound(sound.value)
              : null,
        ),
        iOS: DarwinNotificationDetails(
          badgeNumber: badgeCount,
          sound: sound != NotificationSound.none ? sound.value : null,
        ),
      ),
      payload: jsonEncode({
        ...data ?? {},
        if (link != null) _linkKey: link.toString(),
      }),
      matchDateTimeComponents: repeat.toDateTimeComponents(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> removeSchedule(String uid) {
    return _instance.cancel(uid.toRandomInt());
  }

  @override
  Future<void> removeAllSchedule() {
    return _instance.cancelAll();
  }

  Future<void> _requestPermissions() async {
    if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      await _instance
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await _instance
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (UniversalPlatform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _instance.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }
}

extension on LocalNotificationRepeatSettings {
  DateTimeComponents? toDateTimeComponents() {
    switch (this) {
      case LocalNotificationRepeatSettings.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case LocalNotificationRepeatSettings.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case LocalNotificationRepeatSettings.daily:
        return DateTimeComponents.dateAndTime;
      default:
        return null;
    }
  }
}
