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

  @override
  LocalNotificationMasamuneAdapter get primaryAdapter =>
      LocalNotificationMasamuneAdapter.primary;

  Completer<void>? _completer;

  /// The content of the most recent notice received.
  ///
  /// 受け取った最新の通知の内容。
  @override
  NotificationValue? get value => _value;
  NotificationValue? _value;

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  FutureOr<void> Function(Uri? link, bool onOpenedApp)? get onLink => _onLink;
  FutureOr<void> Function(Uri? link, bool onOpenedApp)? _onLink;

  /// Register notifications and perform scaling.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// Specify the title of the notification in [title]. Specify the body of the notification in [text].
  ///
  /// 通知を登録してスケーリングを行います。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
  Future<void> addSchedule({
    required DateTime time,
    required String title,
    required String text,
  }) async {}

  /// Delete a notification schedule that has already been registered.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// すでに登録されている通知スケジュールを削除します。
  ///
  /// [time]に通知を送信する日時を指定します。
  Future<void> removeSchedule({
    required DateTime time,
  }) async {}

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
