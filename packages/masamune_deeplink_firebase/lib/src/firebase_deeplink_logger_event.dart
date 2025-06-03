part of "/masamune_deeplink_firebase.dart";

/// DeepLink events for logging.
///
/// ロギング用のDeepLinkイベント。
enum FirebaseDeeplinkLoggerEvent {
  /// When you create a DynamicLink.
  ///
  /// DynamicLinkを作成したとき。
  create,

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
