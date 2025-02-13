part of "/masamune_notification_local.dart";

/// Used to specify how notifications should be scheduled on Android.
///
/// This leverages the use of alarms to schedule notifications as described
/// at https://developer.android.com/training/scheduling/alarms
///
/// この列挙型は、Androidで通知をスケジュールする方法を指定するためのものです。
///
/// 詳細は公式ドキュメントを参照してください。
/// https://developer.android.com/training/scheduling/alarms
enum AndroidScheduleMode {
  /// Used to specify that the notification should be scheduled to be shown at
  /// the exact time specified AND will execute whilst device is in
  /// low-power idle mode. Requires SCHEDULE_EXACT_ALARM permission.
  ///
  /// 指定された正確な時間に通知を表示する必要があり、デバイスが低電力アイドルモードにある場合、
  /// 通知を実行する必要があります。SCHEDULE_EXACT_ALARM権限が必要です。
  alarmClock,

  /// Used to specify that the notification should be scheduled to be shown at
  /// the exact time specified but may not execute whilst device is in
  /// low-power idle mode.
  ///
  /// 指定された正確な時間に通知を表示する必要があり、デバイスが低電力アイドルモードにある場合、
  /// 通知を実行する必要があります。
  exact,

  /// Used to specify that the notification should be scheduled to be shown at
  /// the exact time specified and will execute whilst device is in
  /// low-power idle mode.
  ///
  /// 指定された正確な時間に通知を表示する必要があり、デバイスが低電力アイドルモードにある場合、
  /// 通知を実行する必要があります。
  exactAllowWhileIdle,

  /// Used to specify that the notification should be scheduled to be shown at
  /// at roughly specified time but may not execute whilst device is in
  /// low-power idle mode.
  ///
  /// 指定された時間に通知を表示する必要があり、デバイスが低電力アイドルモードにある場合、
  /// 通知を実行する必要があります。
  inexact,

  /// Used to specify that the notification should be scheduled to be shown at
  /// at roughly specified time and will execute whilst device is in
  /// low-power idle mode.
  ///
  /// 指定された時間に通知を表示する必要があり、デバイスが低電力アイドルモードにある場合、
  /// 通知を実行する必要があります。
  inexactAllowWhileIdle;

  /// Converts the [AndroidScheduleMode] to the
  /// [local_notifications.AndroidScheduleMode].
  ///
  /// このメソッドは、[AndroidScheduleMode]を
  /// [local_notifications.AndroidScheduleMode]に変換します。
  local_notifications.AndroidScheduleMode _toAndroidScheduleMode() {
    switch (this) {
      case AndroidScheduleMode.alarmClock:
        return local_notifications.AndroidScheduleMode.alarmClock;
      case AndroidScheduleMode.exact:
        return local_notifications.AndroidScheduleMode.exact;
      case AndroidScheduleMode.exactAllowWhileIdle:
        return local_notifications.AndroidScheduleMode.exactAllowWhileIdle;
      case AndroidScheduleMode.inexact:
        return local_notifications.AndroidScheduleMode.inexact;
      case AndroidScheduleMode.inexactAllowWhileIdle:
        return local_notifications.AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }
}
