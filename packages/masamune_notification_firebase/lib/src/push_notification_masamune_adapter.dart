part of masamune_notification_firebase;

/// [MasamuneAdapter] for receiving push notifications.
///
/// PUSH通知を受信するための[MasamuneAdapter]です。
class PushNotificationMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for receiving push notifications.
  ///
  /// PUSH通知を受信するための[MasamuneAdapter]です。
  const PushNotificationMasamuneAdapter({
    this.functions,
    required this.androidNotificationChannelId,
    required this.androidNotificationChannelTitle,
    required this.androidNotificationChannelDescription,
  });

  /// You can retrieve the [PushNotificationMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[PushNotificationMasamuneAdapter]を取得することができます。
  static PushNotificationMasamuneAdapter get primary {
    assert(
      _primary != null,
      "PushNotificationMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static PushNotificationMasamuneAdapter? _primary;

  /// Specify if there are functions to be executed on the server side.
  ///
  /// サーバー側で実行する関数がある場合指定します。
  final Functions? functions;

  /// Notification channel IDs supported only by **Android**.
  ///
  /// **Android**でのみサポートされる通知チャンネルのIDです。
  final String androidNotificationChannelId;

  /// This is the title of a notification channel that is only supported by **Android**.
  ///
  /// **Android**でのみサポートされる通知チャンネルのタイトルです。
  final String androidNotificationChannelTitle;

  /// This is a description of the notification channels supported only on **Android**.
  ///
  /// **Android**でのみサポートされる通知チャンネルの説明です。
  final String androidNotificationChannelDescription;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! PushNotificationMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }
}
