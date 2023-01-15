part of masamune_notification_firebase;

/// Stores data for notification.
///
/// The content of the notification is included in [title] and [text].
///
/// The destination of the notification is stored in [target].
///
/// Other notification data is passed to [data].
///
/// The [whenAppOpened] will be `true` for notifications when an app is opened, i.e., when the OS notification bar is tapped.
///
/// 通知用のデータを格納します。
///
/// [title]や[text]に通知の内容が含まれます。
///
/// [target]に通知の宛先が格納されます。
///
/// [data]にその他の通知データが渡されます。
///
/// アプリを開いたときの通知、つまりOSの通知バーをタップした場合などに[whenAppOpened]が`true`になります。
@immutable
class NotificationValue {
  /// Stores data for notification.
  ///
  /// The content of the notification is included in [title] and [text].
  ///
  /// The destination of the notification is stored in [target].
  ///
  /// Other notification data is passed to [data].
  ///
  /// The [whenAppOpened] will be `true` for notifications when an app is opened, i.e., when the OS notification bar is tapped.
  ///
  /// 通知用のデータを格納します。
  ///
  /// [title]や[text]に通知の内容が含まれます。
  ///
  /// [target]に通知の宛先が格納されます。
  ///
  /// [data]にその他の通知データが渡されます。
  ///
  /// アプリを開いたときの通知、つまりOSの通知バーをタップした場合などに[whenAppOpened]が`true`になります。
  const NotificationValue({
    required this.title,
    required this.text,
    required this.target,
    this.whenAppOpened = false,
    this.data = const {},
  });

  /// Title of Notice.
  ///
  /// 通知のタイトル。
  final String title;

  /// Notification text.
  ///
  /// 通知テキスト。
  final String text;

  /// ID of the target (topic token).
  ///
  /// ターゲット（トピック・トークン）のID。
  final String target;

  /// Data contained in the notification.
  ///
  /// 通知に含まれるデータ。
  final DynamicMap data;

  /// true` if received when the app is opened.
  ///
  /// アプリを開いたときに受信した場合`true`。
  final bool whenAppOpened;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode =>
      title.hashCode ^
      target.hashCode ^
      text.hashCode ^
      data.hashCode ^
      whenAppOpened.hashCode;
}
