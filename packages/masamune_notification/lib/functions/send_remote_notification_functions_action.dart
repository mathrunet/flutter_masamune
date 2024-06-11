part of '/masamune_notification.dart';

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
    this.tokens,
    this.topic,
    this.channel,
    this.badgeCount,
    this.sound = NotificationSound.defaultSound,
    this.data,
    this.targetCollectionPath,
    this.targetTokenFieldKey,
    this.targetWheres,
    this.targetConditions,
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

  /// Number of badges to display in PUSH notifications.
  ///
  /// PUSH通知で表示するバッジの数。
  final int? badgeCount;

  /// Sound of PUSH notifications.
  ///
  /// PUSH通知のサウンド。
  final NotificationSound sound;

  /// Path of the collection from which to retrieve the list of documents to be deleted.
  ///
  /// Must be a regular Firestore collection path hierarchy.
  ///
  /// 通知の対象となるドキュメント一覧を取得するコレクションのパス。
  ///
  /// Firestoreの正規のコレクションのパス階層である必要があります。
  final String? targetCollectionPath;

  /// Key to retrieve a list of target tokens if [targetCollectionPath] was specified.
  ///
  /// The target key must be defined in [ModelToken].
  ///
  /// [targetCollectionPath]が指定されていた場合、対象となるトークンのリストを取得するキー。
  ///
  /// 対象となるキーには[ModelToken]で定義されている必要があります。
  final String? targetTokenFieldKey;

  /// If [targetCollectionPath] was specified, specify the conditions for retrieving from the collection.
  ///
  /// All are And conditions.
  ///
  /// [targetCollectionPath]が指定されていた場合、コレクションから取得するための条件を指定します。
  ///
  /// すべてAnd条件となります。
  final List<ModelServerCommandCondition>? targetWheres;

  /// If [targetCollectionPath] was specified, specify the condition for the acquired data.
  ///
  /// All are And conditions.
  ///
  /// [targetCollectionPath]が指定されていた場合、取得したデータに対する条件を指定します。
  ///
  /// すべてAnd条件となります。
  final List<ModelServerCommandCondition>? targetConditions;

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
      if (badgeCount != null) "badgeCount": badgeCount,
      if (sound != NotificationSound.none) "sound": sound.value,
      if (targetCollectionPath != null)
        "targetCollectionPath": targetCollectionPath,
      if (targetTokenFieldKey != null)
        "targetTokenFieldKey": targetTokenFieldKey,
      if (targetWheres != null)
        "targetWheres": targetWheres!.map((e) => e.toJson()).toList(),
      if (targetConditions != null)
        "targetConditions": targetConditions!.map((e) => e.toJson()).toList(),
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
