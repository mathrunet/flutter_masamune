part of "/masamune_firebase_app_check.dart";

/// Provider for iOS App Check.
///
/// iOS App Checkのプロバイダー。
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

  AppleAppCheckProvider _toAppleProvider() {
    switch (this) {
      case FirebaseAppCheckIOSProvider.debug:
        return const AppleDebugProvider();
      case FirebaseAppCheckIOSProvider.deviceCheck:
        return const AppleDeviceCheckProvider();
      case FirebaseAppCheckIOSProvider.appAttest:
        return const AppleAppAttestProvider();
      case FirebaseAppCheckIOSProvider.appAttestWithDeviceCheckFallback:
        return const AppleAppAttestWithDeviceCheckFallbackProvider();
      case FirebaseAppCheckIOSProvider.platformDependent:
        return kDebugMode
            ? const AppleDebugProvider()
            : const AppleAppAttestWithDeviceCheckFallbackProvider();
    }
  }
}
