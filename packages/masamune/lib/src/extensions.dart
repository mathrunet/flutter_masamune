part of "/masamune.dart";

/// Extension methods for [BuildContext].
///
/// [BuildContext]の拡張メソッドです。
extension MasamuneBuildContextExtensions on BuildContext {
  /// Restart the application.
  ///
  /// Reload all widgets and states.
  ///
  /// You can describe the process at restart by passing [onRestart].
  ///
  /// アプリをリスタートします。
  ///
  /// すべてのウィジェットや状態をリロードします。
  ///
  /// [onRestart]を渡すことでリスタート時の処理を記述することができます。
  Future<void> restartApp({
    FutureOr<void> Function()? onRestart,
  }) =>
      MasamuneApp.restartApp(this, onRestart: onRestart);
}
