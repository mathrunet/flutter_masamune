part of masamune_notification_firebase;

/// Class for handling FirebaseMessaging.
///
/// First, monitor notifications with [listen]. Notifications can be received after this method is executed.
///
/// You can subscribe and unsubscribe to topics by clicking [subscribe] and [unsubscribe].
///
/// Notifications can be sent using [send]. (Assuming that a Function for notification has been set in FirebaseFunctions. It is also possible to set up a [FunctionsAdapter] in [functions]).
///
/// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
///
/// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
///
/// Be sure to specify the notification settings [androidNotificationChannelTitle] and [androidNotificationChannelDescription] for Android. Matching [androidNotificationChannelId] will enable Android to receive notifications as well.
///
/// FirebaseMessagingを取り扱うためのクラス。
///
/// まず[listen]で通知の監視を行います。このメソッド実行後から通知の受け取りが可能になります。
///
/// [subscribe]、[unsubscribe]でトピックの購読、購読解除が行なえます。
///
/// [send]で通知の送信が可能です。（FirebaseFunctionsで通知用のFunctionが設定されていること前提。[functions]で[FunctionsAdapter]を設定することも可能です。）
///
/// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
///
/// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
///
/// Android用の通知設定[androidNotificationChannelTitle]、[androidNotificationChannelDescription]を必ず指定してください。[androidNotificationChannelId]を合わせることでAndroidでも通知の受け取りが可能になります。
class Notification extends ChangeNotifier
    implements ValueListenable<NotificationValue?> {
  /// Class for handling FirebaseMessaging.
  ///
  /// First, monitor notifications with [listen]. Notifications can be received after this method is executed.
  ///
  /// You can subscribe and unsubscribe to topics by clicking [subscribe] and [unsubscribe].
  ///
  /// Notifications can be sent using [send]. (Assuming that a Function for notification has been set in FirebaseFunctions. It is also possible to set up a [FunctionsAdapter] in [functions]).
  ///
  /// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
  ///
  /// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
  ///
  /// Be sure to specify the notification settings [androidNotificationChannelTitle] and [androidNotificationChannelDescription] for Android. Matching [androidNotificationChannelId] will enable Android to receive notifications as well.
  ///
  /// FirebaseMessagingを取り扱うためのクラス。
  ///
  /// まず[listen]で通知の監視を行います。このメソッド実行後から通知の受け取りが可能になります。
  ///
  /// [subscribe]、[unsubscribe]でトピックの購読、購読解除が行なえます。
  ///
  /// [send]で通知の送信が可能です。（FirebaseFunctionsで通知用のFunctionが設定されていること前提。[functions]で[FunctionsAdapter]を設定することも可能です。）
  ///
  /// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
  ///
  /// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
  ///
  /// Android用の通知設定[androidNotificationChannelTitle]、[androidNotificationChannelDescription]を必ず指定してください。[androidNotificationChannelId]を合わせることでAndroidでも通知の受け取りが可能になります。
  Notification({
    Functions? functions,
    required String androidNotificationChannelDescription,
    required String androidNotificationChannelTitle,
    required String androidNotificationChannelId,
  })  : _functions = functions,
        _androidNotificationChannelId = androidNotificationChannelId,
        _androidNotificationChannelTitle = androidNotificationChannelTitle,
        _androidNotificationChannelDescription =
            androidNotificationChannelDescription;

  /// []
  final Functions? _functions;
  final String _androidNotificationChannelId;
  final String _androidNotificationChannelTitle;
  final String _androidNotificationChannelDescription;

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  FirebaseMessaging get _messaging {
    return FirebaseMessaging.instance;
  }

  @override
  void dispose() {
    super.dispose();
    _listening = false;
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
  }

  /// The content of the most recent notice received.
  ///
  /// 受け取った最新の通知の内容。
  @override
  NotificationValue? get value => _value;
  NotificationValue? _value;

  /// Returns `true` if notification receipt has been initiated.
  ///
  /// 通知の受け取りが開始されている場合`true`を返します。
  bool get listening => _listening;
  bool _listening = false;

  /// Obtain the FCM token for this terminal.
  ///
  /// この端末のFCMトークンを取得します。
  Future<String?> getToken() {
    return _messaging.getToken();
  }

  /// Start receiving notifications.
  ///
  /// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
  ///
  /// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
  ///
  /// 通知の受け取りを開始します。
  ///
  /// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
  ///
  /// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
  Future<void> listen() async {
    if (listening) {
      return;
    }
    try {
      await FirebaseCore.initialize();
      await _messaging.setAutoInitEnabled(true);
      await _messaging.getToken();
      _onMessageSubscription = FirebaseMessaging.onMessage.listen(_onMessage);
      _onMessageOpenedAppSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
      if (!kIsWeb && Platform.isAndroid) {
        await FlutterLocalNotificationsPlugin()
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(
              AndroidNotificationChannel(
                _androidNotificationChannelId,
                _androidNotificationChannelTitle,
                description: _androidNotificationChannelDescription,
                importance: Importance.max,
              ),
            );
      } else {
        await _messaging.setForegroundNotificationPresentationOptions(
          sound: true,
          badge: true,
          alert: true,
        );
      }
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      _listening = true;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Start the Functions for sending FCM notifications deployed in FirebaseFunctions.
  ///
  /// Pass the title of the notification in [title], the content of the notification in [text], the PCM token or topic name in [target], the notification channel ID for Android in [channel], and other notification data in [data].
  ///
  /// See [Functions.sendNotification] for details.
  ///
  /// FirebaseFunctionsにデプロイされたFCM通知送信用のFunctionsを起動します。
  ///
  /// [title]に通知タイトル、[text]に通知の内容、[target]にPCMトークン、もしくはトピック名、[channel]にAndroid用の通知チャンネルID、[data]にその他の通知データを渡してください。
  ///
  /// 詳しくは[Functions.sendNotification]を御覧ください。
  Future<void> send({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
  }) async {
    await listen();
    final f = _functions ?? Functions();
    await f.sendNotification(
      title: title,
      text: text,
      target: target,
      channel: _androidNotificationChannelId,
      data: data,
    );
  }

  /// Subscribe to a topic named [topic].
  ///
  /// You will be able to retrieve notifications sent under this topic name.
  ///
  /// [topic]の名前のトピックを購読します。
  ///
  /// このトピック名で送られた通知を取得することができるようになります。
  Future<void> subscribe(String topic) async {
    await listen();
    assert(topic.isNotEmpty, "You have not specified a topic.");
    _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic name named [topic].
  ///
  /// [topic]の名前のトピック名の購読を解除します。
  Future<void> unsubscribe(String topic) async {
    await listen();
    assert(topic.isNotEmpty, "You have not specified a topic.");
    _messaging.unsubscribeFromTopic(topic);
  }

  Future<void> _onMessage(RemoteMessage message) async {
    final data = message.data;
    _value = NotificationValue(
      title: message.notification?.title ?? "",
      text: message.notification?.body ?? "",
      data: data,
      target: message.from ?? "",
      whenAppOpened: false,
    );
    notifyListeners();
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    final data = message.data;
    _value = NotificationValue(
      title: message.notification?.title ?? "",
      text: message.notification?.body ?? "",
      data: data,
      target: message.from ?? "",
      whenAppOpened: true,
    );
    notifyListeners();
  }
}
