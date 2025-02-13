part of "/masamune_notification_local.dart";

/// Describes how the fire date (date used to schedule a notification) of the
/// `UILocalNotification` on iOS is interpreted.
///
/// This is needed as time zone support in the deprecated UILocalNotification
/// APIs is limited. See official docs at
/// https://developer.apple.com/documentation/uikit/uilocalnotification/1616659-timezone
/// for more details.
///
/// ローカル通知の fire date の解釈方法を記述します。
///
/// 非推奨の UILocalNotification API では、時間帯のサポートが限定的です。
/// 詳細は公式ドキュメントを参照してください。
/// https://developer.apple.com/documentation/uikit/uilocalnotification/1616659-timezone
enum UILocalNotificationDateInterpretation {
  /// The date is interpreted as absolute GMT time.
  ///
  /// 日付は絶対的な GMT 時間として解釈されます。
  absoluteTime,

  /// The date is interpreted as a wall-clock time.
  ///
  /// 日付は壁時計時間として解釈されます。
  wallClockTime;

  /// Converts the [UILocalNotificationDateInterpretation] to the
  /// [local_notifications.UILocalNotificationDateInterpretation].
  local_notifications.UILocalNotificationDateInterpretation
      _toUILocalNotificationDateInterpretation() {
    switch (this) {
      case UILocalNotificationDateInterpretation.absoluteTime:
        return local_notifications
            .UILocalNotificationDateInterpretation.absoluteTime;
      case UILocalNotificationDateInterpretation.wallClockTime:
        return local_notifications
            .UILocalNotificationDateInterpretation.wallClockTime;
    }
  }
}
