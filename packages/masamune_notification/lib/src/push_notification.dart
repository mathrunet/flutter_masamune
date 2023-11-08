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
  FutureOr<void> Function(Uri link)? get onLink => _onLink;
  FutureOr<void> Function(Uri link)? _onLink;

  /// Obtain the FCM token for this terminal.
  ///
  /// この端末のFCMトークンを取得します。
  Future<String?> getToken() {
    final token = adapter.getToken();
    _sendLog(PushNotificationLoggerEvent.token, parameters: {
      PushNotificationLoggerEvent.tokenKey: token,
    });
    return token;
  }

  /// Start receiving notifications.
  ///
  /// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
  ///
  /// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
  ///
  /// You can specify a callback when the URL is launched with [onLink].
  ///
  /// 通知の受け取りを開始します。
  ///
  /// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
  ///
  /// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
  ///
  /// [onLink]でURLが起動されたときのコールバックを指定することができます。
  Future<void> listen({
    FutureOr<void> Function(Uri link)? onLink,
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
  /// Pass the title of the notification in [title], the content of the notification in [text], the PCM token or topic name in [target], the notification channel ID for Android in [channel], and other notification data in [data].
  ///
  /// See [SendNotificationFunctionsAction] for details.
  ///
  /// FirebaseFunctionsにデプロイされたFCM通知送信用のFunctionsを起動します。
  ///
  /// [title]に通知タイトル、[text]に通知の内容、[target]にPCMトークン、もしくはトピック名、[channel]にAndroid用の通知チャンネルID、[data]にその他の通知データを渡してください。
  ///
  /// 詳しくは[SendNotificationFunctionsAction]を御覧ください。
  Future<void> send({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
    Uri? link,
  }) async {
    await listen();
    final f = adapter.functionsAdapter ?? FunctionsAdapter.primary;
    await f.execute(
      SendNotificationFunctionsAction(
        title: title,
        text: text,
        target: target,
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
      PushNotificationLoggerEvent.toKey: target,
    });
  }

  /// Register notifications in the database for scaling.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// Specify the title of the notification in [title]. Specify the body of the notification in [text].
  ///
  /// 通知をデータベースに登録してスケーリングを行います。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
  Future<void> scheduling({
    required DateTime time,
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
    Uri? link,
  }) async {
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
              target: target,
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
              target: target,
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
    if (onLink != null && value.data.containsKey(_linkKey)) {
      final uri = value.data.get(_linkKey, "").toUri();
      if (uri != null) {
        await onLink.call(uri);
      }
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
    if (onLink != null && value.data.containsKey(_linkKey)) {
      final uri = value.data.get(_linkKey, "").toUri();
      if (uri != null) {
        await onLink.call(uri);
      }
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
