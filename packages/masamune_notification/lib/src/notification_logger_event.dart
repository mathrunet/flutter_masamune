part of "/masamune_notification.dart";

/// Push notification event for logging.
///
/// ロギング用のPUSH通知イベント。
enum NotificationLoggerEvent {
  /// When a topic is subscribed to.
  ///
  /// トピックが購読されたとき。
  subscribe,

  /// When a topic is unsubscribed.
  ///
  /// トピックが購読解除されたとき。
  unsubscribe,

  /// When a notification is sent.
  ///
  /// 通知が送信されたとき。
  send,

  /// When a notification is received.
  ///
  /// 監視を開始したとき。
  listen,

  /// When a notification is received.
  ///
  /// 通知を受信したとき。
  receive,

  /// When a token is received.
  ///
  /// トークンを受信したとき。
  token,

  /// When a schedule is added.
  ///
  /// スケジュールを追加したとき。
  addSchedule,

  /// When a schedule is deleted.
  ///
  /// スケジュールを削除したとき。
  removeSchedule;

  /// UID key.
  ///
  /// UIDのキー。
  static const uidKey = "uid";

  /// Topic name key.
  ///
  /// トピック名のキー。
  static const topicNameKey = "topic";

  /// Key to the title of the notification.
  ///
  /// 通知のタイトルのキー。
  static const titleKey = "title";

  /// Key to the text of the notice.
  ///
  /// 通知の文章のキー。
  static const bodyKey = "body";

  /// Notification Destination Key
  ///
  /// 通知の宛先のキー
  static const toKey = "to";

  /// Key of the token.
  ///
  /// トークンのキー。
  static const tokenKey = "token";

  /// Time Key.
  ///
  /// 時間のキー。
  static const timeKey = "time";
}
