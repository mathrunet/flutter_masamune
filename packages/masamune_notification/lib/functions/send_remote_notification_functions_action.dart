part of "/masamune_notification.dart";

/// [FunctionsAction] for sending remote PUSH notifications from the server side.
///
/// リモートPUSH通知をサーバー側から送るための[FunctionsAction]。
///
/// {@macro functions_action}
class SendRemoteNotificationFunctionsAction
    extends FunctionsAction<SendRemoteNotificationFunctionsActionResponse> {
  /// [FunctionsAction] for sending remote PUSH notifications from the server side.
  ///
  /// リモートPUSH通知をサーバー側から送るための[FunctionsAction]。
  ///
  /// {@macro functions_action}
  const SendRemoteNotificationFunctionsAction({
    required this.title,
    required this.text,
    required this.target,
    this.channel,
    this.badgeCount,
    this.sound = NotificationSound.defaultSound,
    this.data,
  });

  /// Title of PUSH notification.
  ///
  /// PUSH通知のタイトル。
  final String title;

  /// PUSH Notification Content.
  ///
  /// PUSH通知の内容。
  final String text;

  /// Channel name for PUSH notifications.
  ///
  /// PUSH通知のチャンネル名。
  final String? channel;

  /// Other data to include in PUSH notifications.
  ///
  /// PUSH通知に含めるその他のデータ。
  final DynamicMap? data;

  /// Set up notification destinations.
  ///
  /// Use [TopicNotificationTargetQuery] to specify by topic. Use [TokenNotificationTargetQuery] or [ModelTokenNotificationTargetQuery] to specify by token.
  ///
  /// Use [CollectionNotificationTargetQuery] if you wish to specify it in the collection documentation.
  ///
  /// 通知先の設定。
  ///
  /// トピックで指定したい場合は[TopicNotificationTargetQuery]を使用してください。トークンで指定したい場合は[TokenNotificationTargetQuery]、[ModelTokenNotificationTargetQuery]を使用してください。
  ///
  /// コレクションのドキュメントで指定したい場合は[CollectionNotificationTargetQuery]を使用してください。
  final NotificationTargetQuery target;

  /// Number of badges to display in PUSH notifications.
  ///
  /// PUSH通知で表示するバッジの数。
  final int? badgeCount;

  /// Sound of PUSH notifications.
  ///
  /// PUSH通知のサウンド。
  final NotificationSound sound;

  @override
  String get action => "send_notification";

  @override
  DynamicMap? toMap() {
    return {
      "title": title,
      "body": text,
      if (channel != null) "channel_id": channel,
      if (data != null) "data": data,
      if (badgeCount != null) "badgeCount": badgeCount,
      if (sound != NotificationSound.none) "sound": sound.value,
      ...target.toJson(),
    };
  }

  @override
  SendRemoteNotificationFunctionsActionResponse toResponse(DynamicMap map) {
    return SendRemoteNotificationFunctionsActionResponse(
      map.getAsMap("results", {}).map(
        (key, value) => MapEntry(key, value),
      ),
    );
  }
}

/// [FunctionsAction] response to send remote PUSH notification from the server side.
///
/// リモートPUSH通知をサーバー側から送るための[FunctionsAction]のレスポンス。
class SendRemoteNotificationFunctionsActionResponse
    extends FunctionsActionResponse {
  /// [FunctionsAction] response to send remote PUSH notification from the server side.
  ///
  /// リモートPUSH通知をサーバー側から送るための[FunctionsAction]のレスポンス。
  const SendRemoteNotificationFunctionsActionResponse(this._results);

  final DynamicMap _results;

  /// List of tokens that have been successfully sent.
  ///
  /// 送信に成功したトークンの一覧。
  List<String> get successTokens =>
      _results.where((key, value) => value != null).keys.toList();

  /// List of tokens that have failed to send.
  ///
  /// 送信に失敗したトークンの一覧。
  List<String> get failedTokens =>
      _results.where((key, value) => value == null).keys.toList();
}
