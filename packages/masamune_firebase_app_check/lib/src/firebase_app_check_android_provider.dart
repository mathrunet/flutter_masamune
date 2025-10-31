part of "/masamune_firebase_app_check.dart";

/// The provider for Android.
///
/// Androidのプロバイダー。
enum FirebaseAppCheckAndroidProvider {
  /// Use the debug provider.
  ///
  /// デバッグプロバイダーを使用します。
  debug,

  /// Use the playIntegrity provider.
  ///
  /// プレイインテグリティプロバイダーを使用します。
  playIntegrity,

  /// Use the [debug] provider if you are in debug mode, otherwise use the [playIntegrity] provider.
  ///
  /// デバッグモードの場合は[debug]プロバイダーを、それ以外の場合は[playIntegrity]プロバイダーを使用します。
  platformDependent;

  AndroidAppCheckProvider _toAndroidProvider() {
    switch (this) {
      case FirebaseAppCheckAndroidProvider.debug:
        return const AndroidDebugProvider();
      case FirebaseAppCheckAndroidProvider.playIntegrity:
        return const AndroidPlayIntegrityProvider();
      case FirebaseAppCheckAndroidProvider.platformDependent:
        return kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider();
    }
  }
}
