part of '/masamune_notification.dart';

/// A query to set the recipients of remote notifications.
///
/// リモート通知の通知先を設定するためのクエリ。
abstract class NotificationTargetQuery {
  /// A query to set the recipients of remote notifications.
  ///
  /// リモート通知の通知先を設定するためのクエリ。
  const NotificationTargetQuery();

  /// Generate Json to pass to the server side.
  ///
  /// サーバー側に渡すためのJsonを生成します。
  DynamicMap toJson();

  /// Generate a database ID for registration in the schedule.
  ///
  /// スケジュールに登録するためのデータベースIDを生成します。
  String toDatabaseId();
}

/// A query that specifies a list of tokens to send PUSH notifications to.
///
/// トークンのリストを指定してPUSH通知の送信先を設定するクエリ。
class TokenNotificationTargetQuery extends NotificationTargetQuery {
  /// A query that specifies a list of tokens to send PUSH notifications to.
  ///
  /// トークンのリストを指定してPUSH通知の送信先を設定するクエリ。
  const TokenNotificationTargetQuery({required this.tokens});

  /// Destination of PUSH notifications (token)
  ///
  /// PUSH通知の送信先（トークン）
  final List<String> tokens;

  static const String _kTokenKey = "targetToken";

  @override
  DynamicMap toJson() {
    return <String, dynamic>{
      _kTokenKey: tokens,
    };
  }

  @override
  String toDatabaseId() {
    return tokens.sortTo().join().limit(256);
  }

  @override
  String toString() {
    return "$runtimeType(${tokens.join(",")})";
  }
}

/// A query that specifies a list of tokens to send PUSH notifications to.
///
/// トークンのリストを指定してPUSH通知の送信先を設定するクエリ。
class ModelTokenNotificationTargetQuery extends NotificationTargetQuery {
  /// A query that specifies a list of tokens to send PUSH notifications to.
  ///
  /// トークンのリストを指定してPUSH通知の送信先を設定するクエリ。
  const ModelTokenNotificationTargetQuery({required this.tokens});

  /// Destination of PUSH notifications (token)
  ///
  /// PUSH通知の送信先（トークン）
  final List<ModelToken> tokens;

  static const String _kTokenKey = "targetToken";

  @override
  DynamicMap toJson() {
    return <String, dynamic>{
      _kTokenKey: tokens.expandAndRemoveEmpty((e) => e.value),
    };
  }

  @override
  String toDatabaseId() {
    return tokens
        .expandAndRemoveEmpty((e) => e.value)
        .sortTo()
        .join()
        .limit(256);
  }

  @override
  String toString() {
    return "$runtimeType(${tokens.expandAndRemoveEmpty((e) => e.value).join(",")})";
  }
}

/// A query that specifies a topic to send PUSH notifications to.
///
/// トピックを指定してPUSH通知の送信先を設定するクエリ。
class TopicNotificationTargetQuery extends NotificationTargetQuery {
  /// A query that specifies a topic to send PUSH notifications to.
  ///
  /// トピックを指定してPUSH通知の送信先を設定するクエリ。
  const TopicNotificationTargetQuery({required this.topic});

  /// Destination of PUSH notifications (topic name)
  ///
  /// PUSH通知の送信先（トピック名）
  final String topic;

  static const String _kTopicKey = "targetTopic";

  @override
  DynamicMap toJson() {
    return <String, dynamic>{
      _kTopicKey: topic,
    };
  }

  @override
  String toDatabaseId() {
    return topic.limit(256);
  }

  @override
  String toString() {
    return "$runtimeType($topic)";
  }
}

/// A query to send a PUSH notification for all tokens in a specific field, with conditions specified for a specific collection.
///
/// 特定のコレクションに対して条件を指定し特定のフィールドにあるトークンすべてに対してPUSH通知を送信するためのクエリ。
class CollectionNotificationTargetQuery extends NotificationTargetQuery {
  /// A query to send a PUSH notification for all tokens in a specific field, with conditions specified for a specific collection.
  ///
  /// 特定のコレクションに対して条件を指定し特定のフィールドにあるトークンすべてに対してPUSH通知を送信するためのクエリ。
  const CollectionNotificationTargetQuery({
    required this.collectionPath,
    required this.tokenField,
    this.wheres = const [],
    this.conditions = const [],
  });

  /// Path of the collection from which to retrieve the list of documents to be deleted.
  ///
  /// Must be a regular Firestore collection path hierarchy.
  ///
  /// 通知の対象となるドキュメント一覧を取得するコレクションのパス。
  ///
  /// Firestoreの正規のコレクションのパス階層である必要があります。
  final String collectionPath;

  /// Key to retrieve a list of eligible tokens.
  ///
  /// The target key must be defined in [ModelToken] or [List].
  ///
  /// 対象となるトークンのリストを取得するキー。
  ///
  /// 対象となるキーには[ModelToken]もしくは[List]で定義されている必要があります。
  final ModelServerCommandField tokenField;

  /// Specify the conditions for retrieving from the collection.
  ///
  /// All are And conditions.
  ///
  /// コレクションから取得するための条件を指定します。
  ///
  /// すべてAnd条件となります。
  final List<ModelServerCommandCondition> wheres;

  /// Specify the condition for the acquired data.
  ///
  /// All are And conditions.
  ///
  /// 取得したデータに対する条件を指定します。
  ///
  /// すべてAnd条件となります。
  final List<ModelServerCommandCondition> conditions;

  static const String _kCollectionPathKey = "targetConditionPath";
  static const String _kTokenFieldKey = "targetTokenField";
  static const String _kWheresKey = "targetWheres";
  static const String _kConditionsKey = "targetConditions";

  @override
  DynamicMap toJson() {
    return <String, dynamic>{
      _kCollectionPathKey: collectionPath,
      _kTokenFieldKey: tokenField.toJson(),
      _kWheresKey: wheres.map((e) => e.toJson()).toList(),
      _kConditionsKey: conditions.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toDatabaseId() {
    return collectionPath.replaceAll("/", "").limit(256);
  }

  @override
  String toString() {
    return "$runtimeType($collectionPath)";
  }
}
