part of "/masamune_notification.dart";

/// [MasamuneAdapter] for receiving local PUSH notifications.
///
/// ローカルPUSH通知を受信するための[MasamuneAdapter]です。
abstract class LocalNotificationMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for receiving local PUSH notifications.
  ///
  /// ローカルPUSH通知を受信するための[MasamuneAdapter]です。
  const LocalNotificationMasamuneAdapter({
    this.localNotification,
    this.modelAdapter,
    this.loggerAdapters = const [],
    this.androidDefaultIcon = "@mipmap/ic_launcher",
    required this.androidNotificationChannelId,
    required this.androidNotificationChannelTitle,
    required this.androidNotificationChannelDescription,
    this.onLink,
    this.defaultTimezone = "UTC",
    this.listenOnBoot = false,
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

  /// Specify a [ModelAdapter] to register the PUSH notification schedule.
  ///
  /// PUSH通知のスケジュールを登録するための[ModelAdapter]を指定します。
  final ModelAdapter? modelAdapter;

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

  /// `true` if [localNotification] is set to `true` to start monitoring when [onMaybeBoot] is executed.
  ///
  /// [localNotification]が設定されている場合、[onMaybeBoot]を実行した際合わせて監視を開始する場合`true`。
  final bool listenOnBoot;

  /// Default time zone.
  ///
  /// デフォルトのタイムゾーン。
  final String defaultTimezone;

  /// Android default icon.
  ///
  /// Androidのデフォルトアイコン。
  final String androidDefaultIcon;

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

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final FutureOr<void> Function(Uri? link)? onLink;

  /// Initialization. If the application is launched from a notification, the content of the notification is retrieved.
  ///
  /// If there is notification data, return the ID for the response notification.
  ///
  /// 初期化を行います。通知からアプリが起動された場合は、通知の内容を取得します。
  ///
  /// 通知データがある場合はレスポンス通知用のIDを返してください。
  Future<int?> listen();

  /// Add a schedule.
  ///
  /// Specify a unique ID for [uid]. If this ID is duplicated, the previous schedule will be overwritten.
  ///
  /// Specify the title of the notification in [title]. Specify the message of the notification in the [text] field.
  ///
  /// Specify the date and time for notification in [time].
  ///
  /// You can set the notification to repeat by specifying [repeat].
  ///
  /// Return the ID of the notification when it is registered.
  ///
  /// スケジュールを追加します。
  ///
  /// [uid]に一意のIDを指定します。このIDが重複すると以前のスケジュールが上書きされます。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知のメッセージを指定します。
  ///
  /// [time]に通知を行う日時を指定します。
  ///
  /// [repeat]を指定することで通知を繰り返す設定を行うことができます。
  ///
  /// 通知が登録された時そのIDを返してください。
  Future<int?> addSchedule(
    String uid, {
    required String title,
    required String text,
    required DateTime time,
    int? badgeCount,
    LocalNotificationRepeatSettings repeat =
        LocalNotificationRepeatSettings.none,
    NotificationSound sound = NotificationSound.defaultSound,
    DynamicMap? data,
    Uri? link,
    String? timezone,
  });

  /// Remove the schedule.
  ///
  /// Specify the ID of the schedule to be deleted in [uid].
  ///
  /// Return the ID when the notification is deleted.
  ///
  /// スケジュールを削除します。
  ///
  /// [uid]に削除するスケジュールのIDを指定します。
  ///
  /// 通知が削除された時そのIDを返してください。
  Future<int?> removeSchedule(String uid);

  /// Remove all schedules.
  ///
  /// すべてのスケジュールを削除します。
  Future<void> removeAllSchedule();

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

  @override
  FutureOr<void> onMaybeBoot(BuildContext context) async {
    await super.onMaybeBoot(context);
    if (listenOnBoot) {
      await localNotification?.listen();
    }
  }
}
