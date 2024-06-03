// ignore_for_file: unused_field

part of '/masamune_notification.dart';

/// Class for handling LocalPush notifications.
///
/// Notification can be set by [addSchedule]. [removeSchedule] allows you to remove a notification you have set.
///
/// Various settings can be overridden by passing [adapter]. If this is not used, [LocalNotificationMasamuneAdapter.primary] is used.
///
/// LocalPush通知を取り扱うためのクラス。
///
/// [addSchedule]で通知の設定が可能です。[removeSchedule]で設定した通知を削除することが可能です。
///
/// [adapter]を渡すことで各種設定を上書きすることができます。これが利用されない場合は[LocalNotificationMasamuneAdapter.primary]が利用されます。
class LocalNotification extends MasamuneControllerBase<NotificationValue,
    LocalNotificationMasamuneAdapter> {
  /// Class for handling LocalPush notifications.
  ///
  /// Notification can be set by [addSchedule]. [RemoveSchedule] allows you to remove a notification you have set.
  ///
  /// Various settings can be overridden by passing [adapter]. If this is not used, [LocalNotificationMasamuneAdapter.primary] is used.
  ///
  /// LocalPush通知を取り扱うためのクラス。
  ///
  /// [addSchedule]で通知の設定が可能です。[removeSchedule]で設定した通知を削除することが可能です。
  ///
  /// [adapter]を渡すことで各種設定を上書きすることができます。これが利用されない場合は[LocalNotificationMasamuneAdapter.primary]が利用されます。
  LocalNotification({super.adapter});

  /// Query for Picker.
  ///
  /// ```dart
  /// appRef.controller(LocalNotification.query(parameters));     // Get from application scope.
  /// ref.app.controller(LocalNotification.query(parameters));    // Watch at application scope.
  /// ref.page.controller(LocalNotification.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$LocalNotificationQuery();

  /// Model for Schedule.
  ///
  /// ```dart
  /// ref.app.model(LocalNotification.schedule.document(id));       // Get the document.
  /// ref.app.model(LocalNotification.schedule.collection());       // Get the collection.
  /// ```
  static const schedule = _$LocalNotificationSchedule();

  @override
  LocalNotificationMasamuneAdapter get primaryAdapter =>
      LocalNotificationMasamuneAdapter.primary;

  Completer<void>? _completer;

  static const String _linkKey = "@link";

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
  FutureOr<void> Function(Uri? link)? get onLink => _onLink;
  FutureOr<void> Function(Uri? link)? _onLink;

  /// Start receiving notifications.
  ///
  /// When a notification is retrieved, [value] is updated and [notifyListeners] is called.
  ///
  /// By monitoring the status with [addListener], it is possible to do something when a notification comes in.
  ///
  /// You can specify a callback when the URL is invoked with [onLink].
  ///
  /// 通知の受け取りを開始します。
  ///
  /// 通知を取得した場合、[value]が更新され、[notifyListeners]が呼ばれます。
  ///
  /// [addListener]で状態を監視することで通知が来たときになにかしらの処理を行うことが可能です。
  ///
  /// [onLink]でURLが起動されたときのコールバックを指定することができます。
  Future<void> listen({
    FutureOr<void> Function(Uri? link)? onLink,
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
      final modelQuery = LocalNotificationScheduleModel.collection().modelQuery;
      final col = LocalNotificationScheduleModelCollection(modelQuery);
      await col.load();
      await wait(
        col.map((e) =>
            e.value?.repeat == LocalNotificationRepeatSettings.none &&
                    e.value?.time.value.isBefore(DateTime.now()) == true
                ? e.delete()
                : null),
      );
      final id = await adapter.listen();
      _listening = true;
      _sendLog(NotificationLoggerEvent.listen, parameters: {});
      if (id != null) {
        final found = col.firstWhereOrNull((e) => e.value?.id == id)?.value;
        if (found != null) {
          await _onMessageOpenedApp(
            NotificationValue(
              title: found.title,
              text: found.text,
              target: "",
              whenAppOpened: true,
              data: found.data,
            ),
          );
        }
      }
      notifyListeners();
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
  /// スケジュールを追加します。
  ///
  /// [uid]に一意のIDを指定します。このIDが重複すると以前のスケジュールが上書きされます。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知のメッセージを指定します。
  ///
  /// [time]に通知を行う日時を指定します。
  ///
  /// [repeat]を指定することで通知を繰り返す設定を行うことができます。
  Future<void> addSchedule(
    String uid, {
    required DateTime time,
    required String title,
    required String text,
    int? badgeCount,
    LocalNotificationRepeatSettings repeat =
        LocalNotificationRepeatSettings.none,
    NotificationSound sound = NotificationSound.none,
    DynamicMap? data,
    Uri? link,
  }) async {
    if (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
    try {
      await adapter.listen();
      final modelQuery = LocalNotificationScheduleModel.collection().modelQuery;
      final col = LocalNotificationScheduleModelCollection(modelQuery);
      await col.load();
      final found =
          col.firstWhereOrNull((e) => e.uid == uid) ?? col.create(uid);
      final id = await adapter.addSchedule(
        uid,
        time: time,
        title: title,
        text: text,
        badgeCount: badgeCount,
        repeat: repeat,
        sound: sound,
      );
      await found.save(
        LocalNotificationScheduleModel(
          id: id,
          time: ModelTimestamp(time),
          repeat: repeat,
          title: title,
          text: text,
        ),
      );
      _sendLog(NotificationLoggerEvent.addSchedule, parameters: {
        NotificationLoggerEvent.uidKey: uid,
        NotificationLoggerEvent.titleKey: title,
        NotificationLoggerEvent.bodyKey: text,
        NotificationLoggerEvent.timeKey: time.toIso8601String(),
      });
      notifyListeners();
      _completer?.complete();
      _completer = null;
    } catch (e, stacktrace) {
      _completer?.completeError(e, stacktrace);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Remove the schedule.
  ///
  /// Specify the ID of the schedule to be deleted in [uid].
  ///
  /// スケジュールを削除します。
  ///
  /// [uid]に削除するスケジュールのIDを指定します。
  Future<void> removeSchedule(String uid) async {
    if (_completer != null) {
      await _completer!.future;
    }
    await adapter.listen();
    _completer = Completer<void>();
    try {
      final modelQuery = LocalNotificationScheduleModel.collection().modelQuery;
      final col = LocalNotificationScheduleModelCollection(modelQuery);
      await col.load();
      final id = await adapter.removeSchedule(uid);
      if (id != null) {
        final found = col.firstWhereOrNull((e) => e.value?.id == id);
        await found?.delete();
      }
      _sendLog(NotificationLoggerEvent.removeSchedule, parameters: {
        NotificationLoggerEvent.uidKey: uid,
      });
      notifyListeners();
      _completer?.complete();
      _completer = null;
    } catch (e, stacktrace) {
      _completer?.completeError(e, stacktrace);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Remove all schedules.
  ///
  /// すべてのスケジュールを削除します。
  Future<void> removeAllSchedule() async {
    if (_completer != null) {
      await _completer!.future;
    }
    await adapter.listen();
    _completer = Completer<void>();
    try {
      final modelQuery = LocalNotificationScheduleModel.collection().modelQuery;
      final col = LocalNotificationScheduleModelCollection(modelQuery);
      await col.load();
      await adapter.removeAllSchedule();
      await wait(col.map((e) => e.delete()));
      _sendLog(NotificationLoggerEvent.removeSchedule, parameters: {});
      notifyListeners();
      _completer?.complete();
      _completer = null;
    } catch (e, stacktrace) {
      _completer?.completeError(e, stacktrace);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  Future<void> _onMessageOpenedApp(NotificationValue? value) async {
    if (value == null) {
      return;
    }
    _value = value;
    final onLink = this.onLink ?? adapter.onLink;
    if (onLink != null) {
      final uri = value.data.get(_linkKey, nullOfString)?.toUri();
      await onLink.call(uri);
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
class _$LocalNotificationQuery {
  const _$LocalNotificationQuery();

  @useResult
  _$_LocalNotificationQuery call() => _$_LocalNotificationQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_LocalNotificationQuery extends ControllerQueryBase<LocalNotification> {
  const _$_LocalNotificationQuery(
    this._name,
  );

  final String _name;

  @override
  LocalNotification Function() call(Ref ref) {
    return () => LocalNotification();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}

class _$LocalNotificationSchedule {
  const _$LocalNotificationSchedule();

  /// Query for document.
  ///
  /// ```dart
  /// appref.app.model(LocalNotificationScheduleModel.document(id));       // Get the document.
  /// ref.app.model(LocalNotificationScheduleModel.document(id))..load();  // Load the document.
  /// ```
  final document = LocalNotificationScheduleModel.document;

  /// Query for collection.
  ///
  /// ```dart
  /// appref.app.model(LocalNotificationScheduleModel.collection());       // Get the collection.
  /// ref.app.model(LocalNotificationScheduleModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   LocalNotificationScheduleModel.collection().equal(
  ///     LocalNotificationScheduleModelCollectionKey.xxx,
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  final collection = LocalNotificationScheduleModel.collection;
}
