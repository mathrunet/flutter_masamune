part of '/masamune_notification.dart';

/// Sound of push notification.
///
/// PUSH通知のサウンド。
enum PushNotificationSound {
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
      case PushNotificationSound.none:
        return null;
      case PushNotificationSound.defaultSound:
        return "default";
    }
  }
}
