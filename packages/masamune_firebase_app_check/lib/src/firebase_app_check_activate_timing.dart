part of '/masamune_firebase_app_check.dart';

/// Specify when to activate AppCheck.
///
/// AppCheckをアクティブ化するタイミングを指定します。
enum FirebaseAppCheckActivateTiming {
  /// Activate when the app is launched.
  ///
  /// アプリが起動した際にアクティブ化します。
  onPreRunApp,

  /// Activate when the Boot screen is displayed.
  ///
  /// Boot画面の表示時にアクティブ化します。
  onBoot;
}
