part of 'web.dart';

/// Class that manages all aspects of GoogleAd.
///
/// [initialize] is executed to initialize the advertisement.
///
/// GoogleAdの全般を管理するクラス。
///
/// [initialize]を実行することで広告の初期化を行います。
class GoogleAdsCore {
  GoogleAdsCore._();

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  static bool get initialized => _initialized;
  static bool _initialized = false;

  static Completer<void>? _completer;

  /// Initialize the advertisement.
  ///
  /// 広告を初期化します。
  static Future<void> initialize() async {
    if (initialized) {
      return;
    }
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      debugPrint("The web does not support GoogleAd.");
      _initialized = true;
      _completer = Completer<void>();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Request permission.
  /// 
  /// 許可をリクエストします。
  static Future<void> permission() async {
    debugPrint("The web does not support GoogleAd.");
  }
}
