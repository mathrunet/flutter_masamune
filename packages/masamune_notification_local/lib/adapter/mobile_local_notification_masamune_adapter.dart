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
    required super.androidNotificationChannelId,
    required super.androidNotificationChannelTitle,
    required super.androidNotificationChannelDescription,
    super.loggerAdapters = const [],
    super.androidDefaultIcon = "@mipmap/ic_launcher",
    super.defaultTimezone = "UTC",
    super.localNotification,
    super.listenOnBoot = false,
    super.modelAdapter,
    super.onLink,
    this.androidScheduleMode = AndroidScheduleMode.exactAllowWhileIdle,
  });

  static FlutterLocalNotificationsPlugin get _instance {
    return __instance ??= FlutterLocalNotificationsPlugin();
  }

  static FlutterLocalNotificationsPlugin? __instance;

  /// The schedule mode for the local notification.
  ///
  /// ローカル通知のスケジュールモード。
  final AndroidScheduleMode androidScheduleMode;

  @override
  Future<int?> listen() async {
    initializeTimeZones();
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
    final id = notification.notificationResponse?.id;
    return id;
  }

  @override
  Future<int?> addSchedule(
    String uid, {
    required DateTime time,
    required String title,
    required String text,
    int? badgeCount,
    LocalNotificationRepeatSettings repeat =
        LocalNotificationRepeatSettings.none,
    NotificationSound sound = NotificationSound.none,
    DynamicMap? data,
    Uri? link,
    String? timezone,
  }) async {
    final id = uid.toRandomInt();
    await _instance.zonedSchedule(
      id,
      title,
      text,
      TZDateTime.from(time, getLocation(timezone ?? defaultTimezone)),
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
      matchDateTimeComponents: repeat.toDateTimeComponents(),
      androidScheduleMode: androidScheduleMode._toAndroidScheduleMode(),
    );
    return id;
  }

  @override
  Future<int?> removeSchedule(String uid) async {
    final id = uid.toRandomInt();
    await _instance.cancel(id);
    return id;
  }

  @override
  Future<void> removeAllSchedule() async {
    await _instance.cancelAll();
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
