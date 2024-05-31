part of '/masamune_notification.dart';

/// [MasamuneAdapter] for receiving local PUSH notifications.
///
/// ローカルPUSH通知を受信するための[MasamuneAdapter]です。
abstract class LocalNotificationMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for receiving local PUSH notifications.
  ///
  /// ローカルPUSH通知を受信するための[MasamuneAdapter]です。
  const LocalNotificationMasamuneAdapter({
    this.localNotification,
    this.loggerAdapters = const [],
    this.onLink,
    this.onRetrievedToken,
  });

  /// You can retrieve the [LocalNotificationMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[LocalNotificationMasamuneAdapter]を取得することができます。
  static LocalNotificationMasamuneAdapter get primary {
    assert(
      _primary != null,
      "LocalNotificationMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static LocalNotificationMasamuneAdapter? _primary;

  @override
  final List<LoggerAdapter> loggerAdapters;

  /// Specify the object of [LocalNotification].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [LocalNotification]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final LocalNotification? localNotification;

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final FutureOr<void> Function(Uri? link, bool onOpenedApp)? onLink;

  /// Callback when token is obtained.
  ///
  /// トークンが取得された場合のコールバック。
  final FutureOr<void> Function(String token)? onRetrievedToken;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! LocalNotificationMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<LocalNotificationMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
