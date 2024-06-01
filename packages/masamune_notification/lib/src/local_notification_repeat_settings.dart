part of '/masamune_notification.dart';

/// Set up repeated local PUSH notifications.
///
/// ローカルPUSH通知を繰り返す設定。
enum LocalNotificationRepeatSettings {
  /// Not to be repeated.
  ///
  /// 繰り返さない。
  none,

  /// Repeat at the same time every day.
  ///
  /// 毎日同じ時間に繰り返す。
  daily,

  /// Repeat at the same time on the same day of the week each week.
  ///
  /// 毎週同じ曜日の同じ時間に繰り返す。
  weekly,

  /// Repeat at the same time on the same day each month.
  ///
  /// 毎月同じ日の同じ時間に繰り返す。
  monthly,

  /// Repeat every year in the same month and on the same day at the same time.
  ///
  /// 毎年同じ月と同じ日の同じ時間に繰り返す。
  yearly;
}
