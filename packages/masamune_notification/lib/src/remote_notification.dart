// ignore_for_file: unused_field

part of '/masamune_notification.dart';

/// Class for handling FirebaseMessaging.
///
/// First, monitor notifications with [listen]. Notifications can be received after this method is executed.
///
/// You can subscribe and unsubscribe to topics by clicking [subscribe] and [unsubscribe].
///
/// Notifications can be sent using [send]. (Assuming that a Function for notification has been set up in FirebaseFunctions. It is also possible to set [FunctionsAdapter] in [RemoteNotificationMasamuneAdapter.functionsAdapter]).
///
/// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
///
/// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
///
/// Various settings can be overridden by passing [adapter]. If this is not used, [RemoteNotificationMasamuneAdapter.primary] is used.
///
/// FirebaseMessagingを取り扱うためのクラス。
///
/// まず[listen]で通知の監視を行います。このメソッド実行後から通知の受け取りが可能になります。
///
/// [subscribe]、[unsubscribe]でトピックの購読、購読解除が行なえます。
///
/// [send]で通知の送信が可能です。（FirebaseFunctionsで通知用のFunctionが設定されていること前提。[RemoteNotificationMasamuneAdapter.functionsAdapter]で[FunctionsAdapter]を設定することも可能です。）
///
/// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
///
/// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
///
/// [adapter]を渡すことで各種設定を上書きすることができます。これが利用されない場合は[RemoteNotificationMasamuneAdapter.primary]が利用されます。
class RemoteNotification extends MasamuneControllerBase<NotificationValue,
    RemoteNotificationMasamuneAdapter> {
  /// Class for handling FirebaseMessaging.
  ///
  /// First, monitor notifications with [listen]. Notifications can be received after this method is executed.
  ///
  /// You can subscribe and unsubscribe to topics by clicking [subscribe] and [unsubscribe].
  ///
  /// Notifications can be sent using [send]. (Assuming that a Function for notification has been set up in FirebaseFunctions. It is also possible to set [FunctionsAdapter] in [RemoteNotificationMasamuneAdapter.functionsAdapter]).
  ///
  /// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
  ///
  /// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
  ///
  /// Various settings can be overridden by passing [adapter]. If this is not used, [RemoteNotificationMasamuneAdapter.primary] is used.
  ///
  /// FirebaseMessagingを取り扱うためのクラス。
  ///
  /// まず[listen]で通知の監視を行います。このメソッド実行後から通知の受け取りが可能になります。
  ///
  /// [subscribe]、[unsubscribe]でトピックの購読、購読解除が行なえます。
  ///
  /// [send]で通知の送信が可能です。（FirebaseFunctionsで通知用のFunctionが設定されていること前提。[RemoteNotificationMasamuneAdapter.functionsAdapter]で[FunctionsAdapter]を設定することも可能です。）
  ///
  /// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
  ///
  /// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
  ///
  /// [adapter]を渡すことで各種設定を上書きすることができます。これが利用されない場合は[RemoteNotificationMasamuneAdapter.primary]が利用されます。
  RemoteNotification({super.adapter});

  /// Query for Picker.
  ///
  /// ```dart
  /// appRef.controller(RemoteNotification.query(parameters));     // Get from application scope.
  /// ref.app.controller(RemoteNotification.query(parameters));    // Watch at application scope.
  /// ref.page.controller(RemoteNotification.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$RemoteNotificationQuery();

  /// Model for Schedule.
  ///
  /// ```dart
  /// ref.app.model(RemoteNotification.schedule.document(id));       // Get the document.
  /// ref.app.model(RemoteNotification.schedule.collection());       // Get the collection.
  /// ```
  static const schedule = _$RemoteNotificationSchedule();

  @override
  RemoteNotificationMasamuneAdapter get primaryAdapter =>
      RemoteNotificationMasamuneAdapter.primary;

  String? _token;
  Completer<void>? _completer;
  RemoteNotificationListenResponse? _listenResponse;

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
  NotificationValue? get value => _value;
  NotificationValue? _value;

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
    _sendLog(NotificationLoggerEvent.token, parameters: {
      NotificationLoggerEvent.tokenKey: _token,
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
      _sendLog(NotificationLoggerEvent.listen, parameters: {});
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
  /// See [SendRemoteNotificationFunctionsAction] for details.
  ///
  /// FirebaseFunctionsにデプロイされたFCM通知送信用のFunctionsを起動します。
  ///
  /// [title]に通知タイトル、[text]に通知の内容、[tokens]にPCMトークン、[topic]にトピック名、[channel]にAndroid用の通知チャンネルID、[data]にその他の通知データを渡してください。
  ///
  /// [tokens]と[topic]は同時に指定することはできません。
  ///
  /// [sound]には通知のサウンドを指定します。[badgeCount]にはバッジに表示する数を指定します。
  ///
  /// 詳しくは[SendRemoteNotificationFunctionsAction]を御覧ください。
  Future<SendRemoteNotificationFunctionsActionResponse> send({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    String? topic,
    ModelToken? tokens,
    int? badgeCount,
    NotificationSound sound = NotificationSound.defaultSound,
    Uri? link,
    String? targetCollectionPath,
    String? targetTokenFieldKey,
    List<ModelServerCommandCondition>? targetWheres,
    List<ModelServerCommandCondition>? targetConditions,
  }) async {
    assert(
      tokens != null || topic != null || targetCollectionPath != null,
      "[tokens] or [topic], [targetCollectionPath] is required",
    );
    assert(
      tokens == null || topic == null || targetCollectionPath == null,
      "[tokens] and [topic], [targetCollectionPath] cannot be set at the same time",
    );
    assert(
      (targetCollectionPath == null && targetTokenFieldKey == null) ||
          (targetCollectionPath != null && targetTokenFieldKey != null),
      "[targetCollectionPath] and [targetTokenFieldKey] must be set at the same time",
    );
    await listen();
    final f = adapter.functionsAdapter ?? FunctionsAdapter.primary;
    final res = await f.execute(
      SendRemoteNotificationFunctionsAction(
        title: title,
        text: text,
        topic: topic,
        tokens: tokens,
        channel: adapter.androidNotificationChannelId,
        badgeCount: badgeCount,
        sound: sound,
        data: {
          if (data != null) ...data,
          if (link != null) _linkKey: link.path,
        },
        targetCollectionPath: targetCollectionPath,
        targetTokenFieldKey: targetTokenFieldKey,
        targetWheres: targetWheres,
        targetConditions: targetConditions,
      ),
    );
    _sendLog(NotificationLoggerEvent.send, parameters: {
      NotificationLoggerEvent.titleKey: title,
      NotificationLoggerEvent.bodyKey: text,
      NotificationLoggerEvent.toKey: tokens != null
          ? tokens.toString()
          : (targetCollectionPath.isEmpty ? topic : targetCollectionPath),
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
  /// You can specify the ID of the database by specifying [targetId].
  ///
  /// 通知をデータベースに登録してスケーリングを行います。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
  ///
  /// [tokens]にPCMトークン、[topic]にトピック名を指定します。[tokens]と[topic]は同時に指定することはできません。
  ///
  /// [targetId]を指定するとデータベースのIDを指定することができます。
  Future<void> addSchedule({
    required DateTime time,
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    String? topic,
    ModelToken? tokens,
    int? badgeCount,
    NotificationSound sound = NotificationSound.defaultSound,
    Uri? link,
    String? targetId,
    String? targetCollectionPath,
    String? targetTokenFieldKey,
    List<ModelServerCommandCondition>? targetWheres,
    List<ModelServerCommandCondition>? targetConditions,
  }) async {
    assert(
      tokens != null || topic != null || targetCollectionPath != null,
      "[tokens] or [topic], [targetCollectionPath] is required",
    );
    assert(
      tokens == null || topic == null || targetCollectionPath == null,
      "[tokens] and [topic], [targetCollectionPath] cannot be set at the same time",
    );
    assert(
      (targetCollectionPath == null && targetTokenFieldKey == null) ||
          (targetCollectionPath != null && targetTokenFieldKey != null),
      "[targetCollectionPath] and [targetTokenFieldKey] must be set at the same time",
    );
    await listen();
    targetId ??= topic.isEmpty
        ? tokens?.value.sortTo().join().limit(256)
        : (targetCollectionPath.isEmpty
            ? topic?.limit(256)
            : targetCollectionPath?.replaceAll("/", "").limit(256));
    final m = adapter.modelAdapter ?? ModelAdapter.primary;
    final modelQuery = schedule
        .collection()
        .modelQuery
        .create(SchedulerQuery.generateScheduleId(
          time: time,
          command: ModelServerCommandRemoteNotificationSchedule.command,
          target: targetId,
        ));
    final document = RemoteNotificationScheduleModelDocument(
      modelQuery.copyWith(adapter: m),
    );
    await document.reload();
    await document.save(
      document.value?.copyWith(
            command: ModelServerCommandRemoteNotificationSchedule(
              time: ModelTimestamp(time),
              title: title,
              text: text,
              channelId: channel,
              data: data,
              tokens: tokens,
              topic: topic,
              link: link,
              sound: sound.value,
              badgeCount: badgeCount,
              targetCollectionPath: targetCollectionPath,
              targetTokenFieldKey: targetTokenFieldKey,
              targetWheres: targetWheres,
              targetConditions: targetConditions,
            ),
          ) ??
          RemoteNotificationScheduleModel(
            command: ModelServerCommandRemoteNotificationSchedule(
              time: ModelTimestamp(time),
              title: title,
              text: text,
              channelId: channel,
              data: data,
              tokens: tokens,
              topic: topic,
              link: link,
              sound: sound.value,
              badgeCount: badgeCount,
              targetCollectionPath: targetCollectionPath,
              targetTokenFieldKey: targetTokenFieldKey,
              targetWheres: targetWheres,
              targetConditions: targetConditions,
            ),
          ),
    );
    _sendLog(NotificationLoggerEvent.addSchedule, parameters: {
      NotificationLoggerEvent.titleKey: title,
      NotificationLoggerEvent.bodyKey: text,
      NotificationLoggerEvent.toKey: tokens != null
          ? tokens.toString()
          : (targetCollectionPath.isEmpty ? topic : targetCollectionPath),
      NotificationLoggerEvent.timeKey: time.toIso8601String(),
    });
  }

  /// Delete a notification schedule that has already been registered.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// Specify a PCM token in [tokens] and a topic name in [topic]. [tokens] and [topic] cannot be specified at the same time.
  ///
  /// You can specify the ID of the database by specifying [targetId].
  ///
  /// すでに登録されている通知スケジュールを削除します。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [tokens]にPCMトークン、[topic]にトピック名を指定します。[tokens]と[topic]は同時に指定することはできません。
  ///
  /// [targetId]を指定するとデータベースのIDを指定することができます。
  Future<void> removeSchedule({
    required DateTime time,
    String? topic,
    ModelToken? tokens,
    String? targetId,
    String? targetCollectionPath,
  }) async {
    assert(
      tokens != null || topic != null || targetCollectionPath != null,
      "[tokens] or [topic], [targetCollectionPath] is required",
    );
    assert(
      tokens == null || topic == null || targetCollectionPath == null,
      "[tokens] and [topic], [targetCollectionPath] cannot be set at the same time",
    );
    await listen();
    targetId ??= topic.isEmpty
        ? tokens?.value.sortTo().join().limit(256)
        : (targetCollectionPath.isEmpty
            ? topic?.limit(256)
            : targetCollectionPath?.replaceAll("/", "").limit(256));
    final m = adapter.modelAdapter ?? ModelAdapter.primary;
    final modelQuery = schedule
        .collection()
        .modelQuery
        .create(SchedulerQuery.generateScheduleId(
          time: time,
          command: ModelServerCommandRemoteNotificationSchedule.command,
          target: targetId,
        ));
    final document = RemoteNotificationScheduleModelDocument(
      modelQuery.copyWith(adapter: m),
    );
    await document.reload();
    await document.delete();
    _sendLog(NotificationLoggerEvent.removeSchedule, parameters: {
      NotificationLoggerEvent.toKey: tokens != null
          ? tokens.toString()
          : (targetCollectionPath.isEmpty ? topic : targetCollectionPath),
      NotificationLoggerEvent.timeKey: time.toIso8601String(),
    });
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
    _sendLog(NotificationLoggerEvent.subscribe, parameters: {
      NotificationLoggerEvent.topicNameKey: topic,
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
    _sendLog(NotificationLoggerEvent.unsubscribe, parameters: {
      NotificationLoggerEvent.topicNameKey: topic,
    });
  }

  Future<void> _onMessage(NotificationValue value) async {
    _value = value;
    final onLink = this.onLink ?? adapter.onLink;
    if (onLink != null) {
      final uri = value.data.get(_linkKey, nullOfString)?.toUri();
      await onLink.call(uri, false);
    }
    _sendLog(NotificationLoggerEvent.receive, parameters: {
      NotificationLoggerEvent.titleKey: value.title,
      NotificationLoggerEvent.bodyKey: value.text,
      NotificationLoggerEvent.toKey: value.target,
    });
    notifyListeners();
  }

  Future<void> _onMessageOpenedApp(NotificationValue value) async {
    _value = value;
    final onLink = this.onLink ?? adapter.onLink;
    if (onLink != null) {
      final uri = value.data.get(_linkKey, nullOfString)?.toUri();
      await onLink.call(uri, true);
    }
    _sendLog(NotificationLoggerEvent.receive, parameters: {
      NotificationLoggerEvent.titleKey: value.title,
      NotificationLoggerEvent.bodyKey: value.text,
      NotificationLoggerEvent.toKey: value.target,
    });
    notifyListeners();
  }

  void _sendLog(NotificationLoggerEvent event, {DynamicMap? parameters}) {
    final loggerAdapters = LoggerAdapter.primary;
    for (final loggerAdapter in loggerAdapters) {
      loggerAdapter.send(event.toString(), parameters: parameters);
    }
  }
}

@immutable
class _$RemoteNotificationQuery {
  const _$RemoteNotificationQuery();

  @useResult
  _$_RemoteNotificationQuery call() => _$_RemoteNotificationQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_RemoteNotificationQuery
    extends ControllerQueryBase<RemoteNotification> {
  const _$_RemoteNotificationQuery(
    this._name,
  );

  final String _name;

  @override
  RemoteNotification Function() call(Ref ref) {
    return () => RemoteNotification();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}

class _$RemoteNotificationSchedule {
  const _$RemoteNotificationSchedule();

  /// Query for document.
  ///
  /// ```dart
  /// appref.app.model(RemoteNotificationScheduleModel.document(id));       // Get the document.
  /// ref.app.model(RemoteNotificationScheduleModel.document(id))..load();  // Load the document.
  /// ```
  final document = RemoteNotificationScheduleModel.document;

  /// Query for collection.
  ///
  /// ```dart
  /// appref.app.model(RemoteNotificationScheduleModel.collection());       // Get the collection.
  /// ref.app.model(RemoteNotificationScheduleModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   RemoteNotificationScheduleModel.collection().equal(
  ///     RemoteNotificationScheduleModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  final collection = RemoteNotificationScheduleModel.collection;
}
