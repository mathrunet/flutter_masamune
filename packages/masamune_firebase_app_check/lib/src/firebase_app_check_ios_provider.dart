part of "/masamune_firebase_app_check.dart";

enum FirebaseAppCheckIOSProvider {
  /// Use the debug provider.
  ///
  /// デバッグプロバイダーを使用します。
  debug,

  /// Use the deviceCheck provider.
  ///
  /// デバイスチェックプロバイダーを使用します。
  deviceCheck,

  /// Use the appAttest provider.
  ///
  /// appAttestプロバイダーを使用します。
  appAttest,

  /// If the appAttest provider is not available, use the device check provider.
  ///
  /// appAttestプロバイダーが利用できない場合はデバイスチェックプロバイダーを使用します。
  appAttestWithDeviceCheckFallback,

  /// Use the [debug] provider if you are in debug mode, otherwise use the [appAttestWithDeviceCheckFallback] provider.
  ///
  /// デバッグモードの場合は[debug]プロバイダーを、それ以外の場合は[appAttestWithDeviceCheckFallback]プロバイダーを使用します。
  platformDependent;

  AppleProvider _toAppleProvider() {
    switch (this) {
      case FirebaseAppCheckIOSProvider.debug:
        return AppleProvider.debug;
      case FirebaseAppCheckIOSProvider.deviceCheck:
        return AppleProvider.deviceCheck;
      case FirebaseAppCheckIOSProvider.appAttest:
        return AppleProvider.appAttest;
      case FirebaseAppCheckIOSProvider.appAttestWithDeviceCheckFallback:
        return AppleProvider.appAttestWithDeviceCheckFallback;
      case FirebaseAppCheckIOSProvider.platformDependent:
        return kDebugMode
            ? AppleProvider.debug
            : AppleProvider.appAttestWithDeviceCheckFallback;
    }
  }
}
