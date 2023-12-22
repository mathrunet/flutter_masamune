part of '/masamune_notification.dart';

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
    this.tokens,
    this.topic,
    this.channel,
    this.data,
  })  : assert(
          tokens != null || topic != null,
          "[tokens] or [topic] is required",
        ),
        assert(
          tokens == null || topic == null,
          "[tokens] and [topic] cannot be set at the same time",
        );

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

  /// Destination of PUSH notifications (topic name)
  ///
  /// PUSH通知の送信先（トピック名）
  final String? topic;

  /// Destination of PUSH notifications (token)
  ///
  /// PUSH通知の送信先（トークン）
  final ModelToken? tokens;

  @override
  String get action => "send_notification";

  @override
  DynamicMap? toMap() {
    return {
      "title": title,
      "body": text,
      if (channel != null) "channel_id": channel,
      if (data != null) "data": data,
      if (tokens != null) "token": tokens!.value else "topic": topic,
    };
  }

  @override
  SendNotificationFunctionsActionResponse toResponse(DynamicMap map) {
    return SendNotificationFunctionsActionResponse(
      map.getAsMap("results", {}).map(
        (key, value) => MapEntry(key, value),
      ),
    );
  }
}

/// Response to [FunctionsAction] to send PUSH notifications from the server side.
///
/// PUSH通知をサーバー側から送るための[FunctionsAction]のレスポンス。
class SendNotificationFunctionsActionResponse extends FunctionsActionResponse {
  /// Response to [FunctionsAction] to send PUSH notifications from the server side.
  ///
  /// PUSH通知をサーバー側から送るための[FunctionsAction]のレスポンス。
  const SendNotificationFunctionsActionResponse(this._results);

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
