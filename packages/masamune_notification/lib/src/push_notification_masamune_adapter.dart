part of '/masamune_notification.dart';

/// [MasamuneAdapter] for receiving push notifications.
///
/// PUSH通知を受信するための[MasamuneAdapter]です。
abstract class PushNotificationMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for receiving push notifications.
  ///
  /// PUSH通知を受信するための[MasamuneAdapter]です。
  const PushNotificationMasamuneAdapter({
    this.functionsAdapter,
    this.modelAdapter,
    required this.androidNotificationChannelId,
    required this.androidNotificationChannelTitle,
    required this.androidNotificationChannelDescription,
    this.pushNotification,
    this.subscribeOnBoot = const [],
    this.loggerAdapters = const [],
    this.onLink,
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

  /// Specify [FunctionsAdapter] if there are functions to be executed on the server side.
  ///
  /// サーバー側で実行する関数がある場合[FunctionsAdapter]を指定します。
  final FunctionsAdapter? functionsAdapter;

  /// Specify a [ModelAdapter] to register the PUSH notification schedule.
  ///
  /// PUSH通知のスケジュールを登録するための[ModelAdapter]を指定します。
  final ModelAdapter? modelAdapter;

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
  final List<LoggerAdapter> loggerAdapters;

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

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final FutureOr<void> Function(Uri? link, bool onOpenedApp)? onLink;

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

  /// Acquisition of tokens.
  ///
  /// トークンの取得。
  Future<String?> getToken();

  /// Initialize push notifications.
  ///
  /// Push通知の初期化。
  Future<PushNotificationListenResponse?> listen({
    required Future<void> Function(PushNotificationValue value) onMessage,
    required Future<void> Function(PushNotificationValue value)
        onMessageOpenedApp,
  });

  /// Subscribe to a topic named [topic].
  ///
  /// You will be able to retrieve notifications sent under this topic name.
  ///
  /// [topic]の名前のトピックを購読します。
  ///
  /// このトピック名で送られた通知を取得することができるようになります。
  Future<void> subscribe(String topic);

  /// Unsubscribe from a topic name named [topic].
  ///
  /// [topic]の名前のトピック名の購読を解除します。
  Future<void> unsubscribe(String topic);
}

/// Class that stores the response to [PushNotificationMasamuneAdapter.listen].
///
/// [PushNotificationMasamuneAdapter.listen]のレスポンスを格納するクラス。
@immutable
class PushNotificationListenResponse {
  /// Class that stores the response to [PushNotificationMasamuneAdapter.listen].
  ///
  /// [PushNotificationMasamuneAdapter.listen]のレスポンスを格納するクラス。
  const PushNotificationListenResponse({
    required this.onMessageOpenedAppSubscription,
    required this.onMessageSubscription,
  });

  /// [StreamSubscription] in the callback when a message is received.
  ///
  /// メッセージを受信したときのコールバックの[StreamSubscription]。
  final StreamSubscription? onMessageSubscription;

  /// [StreamSubscription] in the callback when a message is received.
  ///
  /// メッセージを受信したときのコールバックの[StreamSubscription]。
  final StreamSubscription? onMessageOpenedAppSubscription;
}
