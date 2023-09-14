part of masamune_location_platform_interface;

/// Represent the possible location accuracy values.
///
/// 可能な位置精度の値を表します。
enum LocationAccuracy {
  /// Location is accurate within a distance of 3000m on iOS and 500m on Android.
  ///
  /// iOSでは3000m、Androidでは500m以内の距離で位置が正確です。
  lowest,

  /// Location is accurate within a distance of 1000m on iOS and 500m on Android.
  ///
  /// iOSでは1000m、Androidでは500m以内の距離で位置が正確です。
  low,

  /// Location is accurate within a distance of 100m on iOS and between 100m and 500m on Android.
  ///
  /// iOSでは100m、Androidでは100mから500mの距離で位置が正確です。
  medium,

  /// Location is accurate within a distance of 10m on iOS and between 0m and 100m on Android.
  ///
  /// iOSでは10m、Androidでは0mから100mの距離で位置が正確です。
  high,

  /// Location is accurate within a distance of ~0m on iOS and between 0m and 100m on Android.
  ///
  /// iOSでは~0m、Androidでは0mから100mの距離で位置が正確です。
  best,

  /// Location accuracy is optimized for navigation on iOS and matches the [LocationAccuracy.best] on Android.
  ///
  /// iOSではナビゲーション用に位置精度が最適化され、Androidでは[LocationAccuracy.best]と一致します。
  navigation,

  /// Location accuracy is reduced for iOS 14+ devices, matches the [LocationAccuracy.lowest] on iOS 13 and below and all other platforms.
  ///
  /// iOS 14+デバイスでは位置精度が低下し、iOS 13以下およびその他のすべてのプラットフォームでは[LocationAccuracy.lowest]と一致します。
  reduced;
}
