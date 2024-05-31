part of '/masamune_notification.dart';

/// Sound of push notification.
///
/// PUSH通知のサウンド。
enum NotificationSound {
  /// No sound.
  ///
  /// サウンドなし。
  none,

  /// Default sound.
  ///
  /// デフォルトのサウンド。
  defaultSound;

  /// Actual value.
  ///
  /// 実際の値。
  String? get value {
    switch (this) {
      case NotificationSound.none:
        return null;
      case NotificationSound.defaultSound:
        return "default";
    }
  }
}
