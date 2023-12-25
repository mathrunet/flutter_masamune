// ignore_for_file: unused_field

part of '/masamune_notification.dart';

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
class PushNotification extends MasamuneControllerBase<PushNotificationValue,
    PushNotificationMasamuneAdapter> {
  /// Class for handling FirebaseMessaging.
  ///
  /// First, monitor notifications with [listen]. Notifications can be received after this method is executed.
  ///
  /// You can subscribe and unsubscribe to topics by clicking [subscribe] and [unsubscribe].
  ///
  /// Notifications can be sent using [send]. (Assuming that a Function for notification has been set up in FirebaseFunctions. It is also possible to set [FunctionsAdapter] in [PushNotificationMasamuneAdapter.functionsAdapter]).
  ///
  /// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
  ///
  /// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
  ///
  /// Various settings can be overridden by passing [adapter]. If this is not used, [PushNotificationMasamuneAdapter.primary] is used.
  ///
  /// FirebaseMessagingを取り扱うためのクラス。
  ///
  /// まず[listen]で通知の監視を行います。このメソッド実行後から通知の受け取りが可能になります。
  ///
  /// [subscribe]、[unsubscribe]でトピックの購読、購読解除が行なえます。
  ///
  /// [send]で通知の送信が可能です。（FirebaseFunctionsで通知用のFunctionが設定されていること前提。[PushNotificationMasamuneAdapter.functionsAdapter]で[FunctionsAdapter]を設定することも可能です。）
  ///
  /// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
  ///
  /// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
  ///
  /// [adapter]を渡すことで各種設定を上書きすることができます。これが利用されない場合は[PushNotificationMasamuneAdapter.primary]が利用されます。
  PushNotification({super.adapter});

  /// Query for Picker.
  ///
  /// ```dart
  /// appRef.controller(PushNotification.query(parameters));     // Get from application scope.
  /// ref.app.controller(PushNotification.query(parameters));    // Watch at application scope.
  /// ref.page.controller(PushNotification.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$PushNotificationQuery();

  /// Model for Schedule.
  ///
  /// ```dart
  /// ref.model(PushNotification.schedule.document(id));       // Get the document.
  /// ref.model(PushNotification.schedule.collection());       // Get the collection.
  /// ```
  static const schedule = _$PushNotificationSchedule();

  @override
  PushNotificationMasamuneAdapter get primaryAdapter =>
      PushNotificationMasamuneAdapter.primary;

  String? _token;
  Completer<void>? _completer;
  PushNotificationListenResponse? _listenResponse;

  static const String _linkKey = "@link";

  @override
  void dispose() {
    super.dispose();
    _listening = false;
    _listenResponse?.onMessageSubscription?.cancel();
    _listenResponse?.onMessageOpenedAppSubscription?.cancel();
  }

  /// The content of the most recent notice received.
  ///
  /// 受け取った最新の通知の内容。
  @override
  PushNotificationValue? get value => _value;
  PushNotificationValue? _value;

  /// Returns `true` if notification receipt has been initiated.
  ///
  /// 通知の受け取りが開始されている場合`true`を返します。
  bool get listening => _listening;
  bool _listening = false;

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  FutureOr<void> Function(Uri? link, bool onOpenedApp)? get onLink => _onLink;
  FutureOr<void> Function(Uri? link, bool onOpenedApp)? _onLink;

  /// Obtain the FCM token for this terminal.
  ///
  /// The retrieved token is retained. If you want to update the token again, set [reload] to `true`.
  ///
  /// If the token is successfully retrieved, [onRetrievedToken] is executed. If [reload] is `false`, [onRetrievedToken] is not executed if the token has already been retrieved.
  ///
  /// この端末のFCMトークンを取得します。
  ///
  /// 取得されたトークンは保持されます。再度トークンを更新したい場合は[reload]を`true`にしてください。
  ///
  /// トークンの取得に成功した場合[onRetrievedToken]が実行されます。[reload]が`false`の場合、トークンが既に取得されている場合は[onRetrievedToken]は実行されません。
  Future<String?> getToken({
    bool reload = false,
    FutureOr<void> Function(String token)? onRetrievedToken,
  }) async {
    if (!reload && _token.isNotEmpty) {
      return _token;
    }
    _token = await adapter.getToken();
    if (_token.isNotEmpty) {
      await (onRetrievedToken ?? adapter.onRetrievedToken)?.call(_token!);
    }
    _sendLog(PushNotificationLoggerEvent.token, parameters: {
      PushNotificationLoggerEvent.tokenKey: _token,
    });
    return _token;
  }

  /// Start receiving notifications.
  ///
  /// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
  ///
  /// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
  ///
  /// You can specify a callback when the URL is launched with [onLink].
  ///
  /// The PUSH token is retrieved before the reception begins, but [onRetrievedToken] is executed if the token is successfully retrieved.
  ///
  /// 通知の受け取りを開始します。
  ///
  /// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
  ///
  /// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
  ///
  /// [onLink]でURLが起動されたときのコールバックを指定することができます。
  ///
  /// 受け取りを開始する前にPUSHトークンを取得しますが、トークンの取得に成功した場合[onRetrievedToken]が実行されます。
  Future<void> listen({
    FutureOr<void> Function(Uri? link, bool onOpenedApp)? onLink,
    FutureOr<void> Function(String token)? onRetrievedToken,
  }) async {
    if (_completer != null) {
      return _completer?.future;
    }
    if (listening) {
      return;
    }
    _completer = Completer();
    try {
      _onLink = onLink;
      _listenResponse = await adapter.listen(
        onMessage: _onMessage,
        onMessageOpenedApp: _onMessageOpenedApp,
      );
      await getToken(onRetrievedToken: onRetrievedToken);
      _listening = true;
      _sendLog(PushNotificationLoggerEvent.listen, parameters: {});
      _completer?.complete();
      _completer = null;
    } catch (e) {
      debugPrint(e.toString());
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Start the Functions for sending FCM notifications deployed in FirebaseFunctions.
  ///
  /// Please pass the notification title in [title], the content of the notification in [text], the PCM token in [tokens], the topic name in [topic], the notification channel ID for Android in [channel], and other notification data in [data].
  ///
  /// [tokens] and [topic] cannot be specified at the same time.
  ///
  /// See [SendNotificationFunctionsAction] for details.
  ///
  /// FirebaseFunctionsにデプロイされたFCM通知送信用のFunctionsを起動します。
  ///
  /// [title]に通知タイトル、[text]に通知の内容、[tokens]にPCMトークン、[topic]にトピック名、[channel]にAndroid用の通知チャンネルID、[data]にその他の通知データを渡してください。
  ///
  /// [tokens]と[topic]は同時に指定することはできません。
  ///
  /// 詳しくは[SendNotificationFunctionsAction]を御覧ください。
  Future<SendNotificationFunctionsActionResponse> send({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    String? topic,
    ModelToken? tokens,
    Uri? link,
  }) async {
    assert(
      tokens != null || topic != null,
      "[tokens] or [topic] is required",
    );
    assert(
      tokens == null || topic == null,
      "[tokens] and [topic] cannot be set at the same time",
    );
    await listen();
    final f = adapter.functionsAdapter ?? FunctionsAdapter.primary;
    final res = await f.execute(
      SendNotificationFunctionsAction(
        title: title,
        text: text,
        topic: topic,
        tokens: tokens,
        channel: adapter.androidNotificationChannelId,
        data: {
          if (data != null) ...data,
          if (link != null) _linkKey: link.path,
        },
      ),
    );
    _sendLog(PushNotificationLoggerEvent.send, parameters: {
      PushNotificationLoggerEvent.titleKey: title,
      PushNotificationLoggerEvent.bodyKey: text,
      PushNotificationLoggerEvent.toKey:
          tokens != null ? tokens.toString() : topic,
    });
    return res;
  }

  /// Register notifications in the database for scaling.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// Specify the title of the notification in [title]. Specify the body of the notification in [text].
  ///
  /// Specify a PCM token in [tokens] and a topic name in [topic]. [tokens] and [topic] cannot be specified at the same time.
  ///
  /// 通知をデータベースに登録してスケーリングを行います。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
  ///
  /// [tokens]にPCMトークン、[topic]にトピック名を指定します。[tokens]と[topic]は同時に指定することはできません。
  Future<void> scheduling({
    required DateTime time,
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    String? topic,
    ModelToken? tokens,
    Uri? link,
  }) async {
    assert(
      tokens != null || topic != null,
      "[tokens] or [topic] is required",
    );
    assert(
      tokens == null || topic == null,
      "[tokens] and [topic] cannot be set at the same time",
    );
    await listen();
    final m = adapter.modelAdapter ?? ModelAdapter.primary;
    final modelQuery = schedule
        .collection()
        .modelQuery
        .create(SchedulerQuery.generateScheduleId(
          time: time,
          command: ModelServerCommandPushNotificationSchedule.command,
        ));
    final document = PushNotificationScheduleModelDocument(
      modelQuery.copyWith(adapter: m),
    );
    await document.load();
    await document.save(
      document.value?.copyWith(
            command: ModelServerCommandPushNotificationSchedule(
              time: ModelTimestamp(time),
              title: title,
              text: text,
              channelId: channel,
              data: data,
              tokens: tokens,
              topic: topic,
              link: link,
            ),
          ) ??
          PushNotificationScheduleModel(
            command: ModelServerCommandPushNotificationSchedule(
              time: ModelTimestamp(time),
              title: title,
              text: text,
              channelId: channel,
              data: data,
              tokens: tokens,
              topic: topic,
              link: link,
            ),
          ),
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
    if (kIsWeb) {
      debugPrint("You cannot subscribe to topic messages on the Web.");
      return;
    }
    await listen();
    assert(topic.isNotEmpty, "You have not specified a topic.");
    await adapter.subscribe(topic);
    _sendLog(PushNotificationLoggerEvent.subscribe, parameters: {
      PushNotificationLoggerEvent.topicNameKey: topic,
    });
  }

  /// Unsubscribe from a topic name named [topic].
  ///
  /// [topic]の名前のトピック名の購読を解除します。
  Future<void> unsubscribe(String topic) async {
    if (kIsWeb) {
      debugPrint("You cannot subscribe to topic messages on the Web.");
      return;
    }
    await listen();
    assert(topic.isNotEmpty, "You have not specified a topic.");
    await adapter.unsubscribe(topic);
    _sendLog(PushNotificationLoggerEvent.unsubscribe, parameters: {
      PushNotificationLoggerEvent.topicNameKey: topic,
    });
  }

  Future<void> _onMessage(PushNotificationValue value) async {
    _value = value;
    final onLink = this.onLink ?? adapter.onLink;
    if (onLink != null) {
      final uri = value.data.get(_linkKey, nullOfString)?.toUri();
      await onLink.call(uri, false);
    }
    _sendLog(PushNotificationLoggerEvent.receive, parameters: {
      PushNotificationLoggerEvent.titleKey: value.title,
      PushNotificationLoggerEvent.bodyKey: value.text,
      PushNotificationLoggerEvent.toKey: value.target,
    });
    notifyListeners();
  }

  Future<void> _onMessageOpenedApp(PushNotificationValue value) async {
    _value = value;
    final onLink = this.onLink ?? adapter.onLink;
    if (onLink != null) {
      final uri = value.data.get(_linkKey, nullOfString)?.toUri();
      await onLink.call(uri, true);
    }
    _sendLog(PushNotificationLoggerEvent.receive, parameters: {
      PushNotificationLoggerEvent.titleKey: value.title,
      PushNotificationLoggerEvent.bodyKey: value.text,
      PushNotificationLoggerEvent.toKey: value.target,
    });
    notifyListeners();
  }

  void _sendLog(PushNotificationLoggerEvent event, {DynamicMap? parameters}) {
    final loggerAdapters = LoggerAdapter.primary;
    for (final loggerAdapter in loggerAdapters) {
      loggerAdapter.send(event.toString(), parameters: parameters);
    }
  }
}

@immutable
class _$PushNotificationQuery {
  const _$PushNotificationQuery();

  @useResult
  _$_PushNotificationQuery call() => _$_PushNotificationQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_PushNotificationQuery extends ControllerQueryBase<PushNotification> {
  const _$_PushNotificationQuery(
    this._name,
  );

  final String _name;

  @override
  PushNotification Function() call(Ref ref) {
    return () => PushNotification();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}

class _$PushNotificationSchedule {
  const _$PushNotificationSchedule();

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(PushNotificationScheduleModel.document(id));       // Get the document.
  /// ref.model(PushNotificationScheduleModel.document(id))..load();  // Load the document.
  /// ```
  final document = PushNotificationScheduleModel.document;

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(PushNotificationScheduleModel.collection());       // Get the collection.
  /// ref.model(PushNotificationScheduleModel.collection())..load();  // Load the collection.
  /// ref.model(
  ///   PushNotificationScheduleModel.collection().equal(
  ///     PushNotificationScheduleModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  final collection = PushNotificationScheduleModel.collection;
}
