// ignore: unused_import, unnecessary_import

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_notification/masamune_notification.dart';
import 'package:masamune_scheduler/masamune_scheduler.dart';

part 'push_notification_schedule.m.dart';
part 'push_notification_schedule.g.dart';
part 'push_notification_schedule.freezed.dart';

/// This model is for scheduling and registering notifications.
///
/// Specify the date and time to send the notification in [time].
///
/// Specify the title of the notification in [title]. Specify the body of the notification in [text].
///
/// 通知をスケジュールして登録するためのモデルです。
///
/// [time]に通知を送信する日時を指定します。
///
/// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
@freezed
@formValue
@immutable
@CollectionModelPath(SchedulerQuery.path)
class PushNotificationScheduleModel
    with _$PushNotificationScheduleModel
    implements ModelNotificationScheduleBase {
  /// This model is for scheduling and registering notifications.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// Specify the title of the notification in [title]. Specify the body of the notification in [text].
  ///
  /// 通知をスケジュールして登録するためのモデルです。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
  const factory PushNotificationScheduleModel({
    required ModelServerCommandPushNotificationSchedule command,
  }) = _PushNotificationScheduleModel;
  const PushNotificationScheduleModel._();

  factory PushNotificationScheduleModel.fromJson(Map<String, Object?> json) =>
      _$PushNotificationScheduleModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(PushNotificationScheduleModel.document(id));       // Get the document.
  /// ref.model(PushNotificationScheduleModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$PushNotificationScheduleModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(PushNotificationScheduleModel.collection());       // Get the collection.
  /// ref.model(PushNotificationScheduleModel.collection())..load();  // Load the collection.
  /// ref.model(
  ///   PushNotificationScheduleModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$PushNotificationScheduleModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(PushNotificationScheduleModel.form(PushNotificationScheduleModel()));    // Get the form controller.
  /// ```
  static const form = _$PushNotificationScheduleModelFormQuery();
}

/// [Enum] of the name of the value defined in PushNotificationScheduleModel.
typedef PushNotificationScheduleModelKeys = _$PushNotificationScheduleModelKeys;

/// Alias for ModelRef<PushNotificationScheduleModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(PushNotificationScheduleModelDocument) PushNotificationScheduleModelRef push_notification_schedule
/// ```
typedef PushNotificationScheduleModelRef
    = ModelRef<PushNotificationScheduleModel>?;

/// It can be defined as an empty ModelRef<PushNotificationScheduleModel>.
///
/// ```dart
/// PushNotificationScheduleModelRefPath("xxx") // Define as a path.
/// ```
typedef PushNotificationScheduleModelRefPath
    = _$PushNotificationScheduleModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PushNotificationScheduleModelInitialCollection(
///       "xxx": PushNotificationScheduleModel(...),
///     ),
///   ],
/// );
/// ```
typedef PushNotificationScheduleModelInitialCollection
    = _$PushNotificationScheduleModelInitialCollection;

/// Document class for storing PushNotificationScheduleModel.
typedef PushNotificationScheduleModelDocument
    = _$PushNotificationScheduleModelDocument;

/// Collection class for storing PushNotificationScheduleModel.
typedef PushNotificationScheduleModelCollection
    = _$PushNotificationScheduleModelCollection;

/// It can be defined as an empty ModelRef<PushNotificationScheduleModel>.
///
/// ```dart
/// PushNotificationScheduleModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef PushNotificationScheduleModelMirrorRefPath
    = _$PushNotificationScheduleModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     PushNotificationScheduleModelMirrorInitialCollection(
///       "xxx": PushNotificationScheduleModel(...),
///     ),
///   ],
/// );
/// ```
typedef PushNotificationScheduleModelMirrorInitialCollection
    = _$PushNotificationScheduleModelMirrorInitialCollection;

/// Document class for storing PushNotificationScheduleModel.
typedef PushNotificationScheduleModelMirrorDocument
    = _$PushNotificationScheduleModelMirrorDocument;

/// Collection class for storing PushNotificationScheduleModel.
typedef PushNotificationScheduleModelMirrorCollection
    = _$PushNotificationScheduleModelMirrorCollection;

/// [ModelServerCommandBase] for PUSH notification to [time].
///
/// Enter the text for the notification in the [title] and [text] fields, and specify a token or topic string for the notification in the [tokens] and [topic] fields.
///
/// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
///
/// [time]にPUSH通知を行うための[ModelServerCommandBase]です。
///
/// [title]や[text]に通知用の文言を入力し、[tokens]や[topic]に通知用のトークンやトピックの文字列を指定します。
///
/// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
class ModelServerCommandPushNotificationSchedule
    extends ModelServerCommandBase {
  /// [ModelServerCommandBase] for PUSH notification to [time].
  ///
  /// Enter the text for the notification in the [title] and [text] fields, and specify a token or topic string for the notification in the [tokens] and [topic] fields.
  ///
  /// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
  ///
  /// [time]にPUSH通知を行うための[ModelServerCommandBase]です。
  ///
  /// [title]や[text]に通知用の文言を入力し、[tokens]や[topic]に通知用のトークンやトピックの文字列を指定します。
  ///
  /// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
  const factory ModelServerCommandPushNotificationSchedule({
    required ModelTimestamp time,
    required String title,
    required String text,
    String? channelId,
    DynamicMap? data,
    String? topic,
    ModelToken? tokens,
    Uri? link,
    int? badgeCount,
    String? sound,
  }) = _ModelServerCommandPushNotificationSchedule;

  const ModelServerCommandPushNotificationSchedule._()
      : super(ModelServerCommandPushNotificationSchedule.command);

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const ModelServerCommandPushNotificationSchedule.fromServer({
    super.publicParameters = const {},
    super.privateParameters = const {},
  }) : super(ModelServerCommandPushNotificationSchedule.command);

  /// Specify the date and time to copy.
  ///
  /// コピーする日時を指定します。
  ModelTimestamp get time => throw UnimplementedError();

  /// The title of the notification.
  ///
  /// 通知のタイトル。
  String get title => throw UnimplementedError();

  /// The body of the notification.
  ///
  /// 通知の本文。
  String get text => throw UnimplementedError();

  /// The channel ID of the notification.
  ///
  /// 通知のチャンネルID。
  String? get channelId => throw UnimplementedError();

  /// The data of the notification.
  ///
  /// 通知のデータ。
  DynamicMap? get data => throw UnimplementedError();

  /// Notification Topics.
  ///
  /// 通知のトピック。
  String? get topic => throw UnimplementedError();

  /// List of tokens of notification.
  ///
  /// 通知のトークンのリスト。
  ModelToken? get tokens => throw UnimplementedError();

  /// A link to transition from the notification.
  ///
  /// 通知から遷移するリンク。
  Uri? get link => throw UnimplementedError();

  /// Number of badges to display in PUSH notifications.
  ///
  /// PUSH通知で表示するバッジの数。
  int? get badgeCount => throw UnimplementedError();

  /// Sound of PUSH notifications.
  ///
  /// PUSH通知のサウンド。
  String? get sound => throw UnimplementedError();

  /// Command Name.
  ///
  /// コマンド名。
  static const command = "notification";

  static const String _kTimeKey = "_time";
  static const String _kDoneKey = "_done";
  static const String _kTitleKey = "title";
  static const String _kTextKey = "text";
  static const String _kChannelIdKey = "channelId";
  static const String _kSoundKey = "sound";
  static const String _kBadgeCountKey = "badgeCount";
  static const String _kDataKey = "data";
  static const String _kTopicKey = "topic";
  static const String _kTokenKey = "token";
  static const String _kLinkKey = "@link";

  /// Convert from [json] map to [ModelServerCommandPushNotificationSchedule].
  ///
  /// [json]のマップから[ModelServerCommandPushNotificationSchedule]に変換します。
  factory ModelServerCommandPushNotificationSchedule.fromJson(DynamicMap json) {
    return ModelServerCommandPushNotificationSchedule.fromServer(
      publicParameters:
          json.getAsMap(ModelServerCommandBase.kPublicParametersKey, {}),
      privateParameters:
          json.getAsMap(ModelServerCommandBase.kPrivateParametersKey, {}),
    );
  }

  @override
  DynamicMap get privateParameters {
    return {
      _kTitleKey: title,
      _kTextKey: text,
      _kChannelIdKey: channelId,
      _kDataKey: {
        if (data != null) ...data!,
        if (link != null) _kLinkKey: link!.path,
      },
      _kTokenKey: tokens?.value,
      _kTopicKey: topic,
      if (sound != null) _kSoundKey: sound,
      if (badgeCount != null) _kBadgeCountKey: badgeCount,
    };
  }

  @override
  DynamicMap get publicParameters {
    return {
      _kDoneKey: false,
      _kTimeKey: time.value.millisecondsSinceEpoch,
    };
  }
}

class _ModelServerCommandPushNotificationSchedule
    extends ModelServerCommandPushNotificationSchedule {
  const _ModelServerCommandPushNotificationSchedule({
    required this.time,
    required this.title,
    required this.text,
    this.channelId,
    this.data,
    this.topic,
    this.tokens,
    this.link,
    this.badgeCount,
    this.sound,
  }) : super._();

  @override
  final ModelTimestamp time;

  @override
  final String title;

  @override
  final String text;

  @override
  final String? channelId;

  @override
  final DynamicMap? data;

  @override
  final Uri? link;

  @override
  final String? topic;

  @override
  final ModelToken? tokens;

  @override
  final int? badgeCount;

  @override
  final String? sound;
}

/// Abstract class for defining a document with a schedule for PUSH notifications.
///
/// Implement this in the value you want [DocumentBase] to have.
///
/// PUSH通知を行うスケジュールを持ったドキュメントを定義するための抽象クラス。
///
/// これを[DocumentBase]に持たせる値に実装してください。
abstract class ModelNotificationScheduleBase {
  /// Submission Date.
  ///
  /// 投稿日時。
  ModelServerCommandPushNotificationSchedule get command;
}
