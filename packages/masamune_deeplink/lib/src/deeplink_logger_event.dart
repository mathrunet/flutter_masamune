part of '/masamune_deeplink.dart';

/// DeepLink events for logging.
///
/// ロギング用のDeepLinkイベント。
enum DeeplinkLoggerEvent {
  /// When a notification is received.
  ///
  /// 監視を開始したとき。
  listen,

  /// When DeepLink is received.
  ///
  /// DeepLinkを受信したとき。
  recieve;

  /// Link key.
  ///
  /// リンクのキー。
  static const linkKey = "link";

  /// Short URL key.
  ///
  /// 短いURLのキー。
  static const shortUriKey = "short";

  /// Long URL key.
  ///
  /// 長いURLのキー。
  static const longUriKey = "long";
}
