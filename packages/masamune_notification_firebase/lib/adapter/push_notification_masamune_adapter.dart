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
    this.pushNotification,
    this.subscribeOnBoot = const [],
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

  /// Specify the object of [PushNotification].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [PushNotification]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final PushNotification? pushNotification;

  /// If [pushNotification] is set, specify the list of topics to subscribe to when [onMaybeBoot] is executed.
  ///
  /// [pushNotification]が設定されている場合、[onMaybeBoot]を実行した際合わせてトピックの購読を行う際のトピックリストを指定します。
  final List<String> subscribeOnBoot;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! PushNotificationMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<PushNotificationMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  FutureOr<void> onMaybeBoot() async {
    await super.onMaybeBoot();
    if (subscribeOnBoot.isNotEmpty) {
      for (final topic in subscribeOnBoot) {
        await pushNotification?.subscribe(topic);
      }
    } else {
      await pushNotification?.listen();
    }
  }
}
