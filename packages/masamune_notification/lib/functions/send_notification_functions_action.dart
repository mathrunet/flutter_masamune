part of masamune_notification;

/// [FunctionsAction] for sending PUSH notifications from the server side.
///
/// PUSH通知をサーバー側から送るための[FunctionsAction]。
///
/// {@macro functions_action}
class SendNotificationFunctionsAction
    extends FunctionsAction<SendNotificationFunctionsActionResponse> {
  /// [FunctionsAction] for sending PUSH notifications from the server side.
  ///
  /// PUSH通知をサーバー側から送るための[FunctionsAction]。
  ///
  /// {@macro functions_action}
  const SendNotificationFunctionsAction({
    required this.title,
    required this.text,
    required this.target,
    this.channel,
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

  /// Send PUSH notifications to (topic name or token)
  ///
  /// PUSH通知の送信先（トピック名 or トークン）
  final String target;

  @override
  String get action => "send_notification";

  @override
  DynamicMap? toMap() {
    final regExp = RegExp(r"[a-zA-Z0-9]{11}:[0-9a-zA-Z_-]+");
    final isToken = regExp.hasMatch(target);

    return {
      "title": title,
      "text": text,
      if (channel != null) "channel_id": channel,
      if (data != null) "data": data,
      if (isToken) "token": target else "topic": target,
    };
  }

  @override
  SendNotificationFunctionsActionResponse toResponse(DynamicMap map) {
    return const SendNotificationFunctionsActionResponse();
  }
}

/// Response to [FunctionsAction] to send PUSH notifications from the server side.
///
/// PUSH通知をサーバー側から送るための[FunctionsAction]のレスポンス。
class SendNotificationFunctionsActionResponse extends FunctionsActionResponse {
  /// Response to [FunctionsAction] to send PUSH notifications from the server side.
  ///
  /// PUSH通知をサーバー側から送るための[FunctionsAction]のレスポンス。
  const SendNotificationFunctionsActionResponse();
}
