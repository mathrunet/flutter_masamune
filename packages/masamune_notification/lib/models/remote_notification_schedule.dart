// ignore: unused_import, unnecessary_import

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_scheduler/masamune_scheduler.dart';

// Project imports:
import 'package:masamune_notification/masamune_notification.dart';

part 'remote_notification_schedule.m.dart';
part 'remote_notification_schedule.g.dart';
part 'remote_notification_schedule.freezed.dart';

/// This model is for scheduling and registering remote PUSH notifications.
///
/// Specify the date and time to send the notification in [time].
///
/// Specify the title of the notification in [title]. Specify the body of the notification in [text].
///
/// リモートPUSH通知をスケジュールして登録するためのモデルです。
///
/// [time]に通知を送信する日時を指定します。
///
/// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
@freezed
@formValue
@immutable
@CollectionModelPath(
  SchedulerQuery.path,
  adapter: "RemoteNotificationMasamuneAdapter.primary.modelAdapter",
)
class RemoteNotificationScheduleModel
    with _$RemoteNotificationScheduleModel
    implements ModelNotificationScheduleBase {
  /// This model is for scheduling and registering remote PUSH notifications.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// Specify the title of the notification in [title]. Specify the body of the notification in [text].
  ///
  /// リモートPUSH通知をスケジュールして登録するためのモデルです。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
  const factory RemoteNotificationScheduleModel({
    required ModelServerCommandRemoteNotificationSchedule command,
  }) = _RemoteNotificationScheduleModel;
  const RemoteNotificationScheduleModel._();

  factory RemoteNotificationScheduleModel.fromJson(Map<String, Object?> json) =>
      _$RemoteNotificationScheduleModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appref.app.model(RemoteNotificationScheduleModel.document(id));       // Get the document.
  /// ref.app.model(RemoteNotificationScheduleModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$RemoteNotificationScheduleModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(RemoteNotificationScheduleModel.collection());       // Get the collection.
  /// ref.app.model(RemoteNotificationScheduleModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   RemoteNotificationScheduleModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$RemoteNotificationScheduleModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(RemoteNotificationScheduleModel.form(RemoteNotificationScheduleModel()));    // Get the form controller in app scope.
  /// ref.page.form(RemoteNotificationScheduleModel.form(RemoteNotificationScheduleModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$RemoteNotificationScheduleModelFormQuery();
}

/// [Enum] of the name of the value defined in RemoteNotificationScheduleModel.
typedef RemoteNotificationScheduleModelKeys
    = _$RemoteNotificationScheduleModelKeys;

/// Alias for ModelRef<RemoteNotificationScheduleModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(RemoteNotificationScheduleModelDocument) RemoteNotificationScheduleModelRef push_notification_schedule
/// ```
typedef RemoteNotificationScheduleModelRef
    = ModelRef<RemoteNotificationScheduleModel>?;

/// It can be defined as an empty ModelRef<RemoteNotificationScheduleModel>.
///
/// ```dart
/// RemoteNotificationScheduleModelRefPath("xxx") // Define as a path.
/// ```
typedef RemoteNotificationScheduleModelRefPath
    = _$RemoteNotificationScheduleModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     RemoteNotificationScheduleModelInitialCollection(
///       "xxx": RemoteNotificationScheduleModel(...),
///     ),
///   ],
/// );
/// ```
typedef RemoteNotificationScheduleModelInitialCollection
    = _$RemoteNotificationScheduleModelInitialCollection;

/// Document class for storing RemoteNotificationScheduleModel.
typedef RemoteNotificationScheduleModelDocument
    = _$RemoteNotificationScheduleModelDocument;

/// Collection class for storing RemoteNotificationScheduleModel.
typedef RemoteNotificationScheduleModelCollection
    = _$RemoteNotificationScheduleModelCollection;

/// It can be defined as an empty ModelRef<RemoteNotificationScheduleModel>.
///
/// ```dart
/// RemoteNotificationScheduleModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef RemoteNotificationScheduleModelMirrorRefPath
    = _$RemoteNotificationScheduleModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     RemoteNotificationScheduleModelMirrorInitialCollection(
///       "xxx": RemoteNotificationScheduleModel(...),
///     ),
///   ],
/// );
/// ```
typedef RemoteNotificationScheduleModelMirrorInitialCollection
    = _$RemoteNotificationScheduleModelMirrorInitialCollection;

/// Document class for storing RemoteNotificationScheduleModel.
typedef RemoteNotificationScheduleModelMirrorDocument
    = _$RemoteNotificationScheduleModelMirrorDocument;

/// Collection class for storing RemoteNotificationScheduleModel.
typedef RemoteNotificationScheduleModelMirrorCollection
    = _$RemoteNotificationScheduleModelMirrorCollection;

/// [ModelServerCommandBase] for remote PUSH notification to [time].
///
/// Enter the text for the notification in the [title] and [text] fields, and specify a token or topic string for the notification in the [tokens] and [topic] fields.
///
/// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
///
/// [time]にリモートPUSH通知を行うための[ModelServerCommandBase]です。
///
/// [title]や[text]に通知用の文言を入力し、[tokens]や[topic]に通知用のトークンやトピックの文字列を指定します。
///
/// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
class ModelServerCommandRemoteNotificationSchedule
    extends ModelServerCommandBase {
  /// [ModelServerCommandBase] for remote PUSH notification to [time].
  ///
  /// Enter the text for the notification in the [title] and [text] fields, and specify a token or topic string for the notification in the [tokens] and [topic] fields.
  ///
  /// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
  ///
  /// [time]にリモートPUSH通知を行うための[ModelServerCommandBase]です。
  ///
  /// [title]や[text]に通知用の文言を入力し、[tokens]や[topic]に通知用のトークンやトピックの文字列を指定します。
  ///
  /// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
  const factory ModelServerCommandRemoteNotificationSchedule({
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
  }) = _ModelServerCommandRemoteNotificationSchedule;

  const ModelServerCommandRemoteNotificationSchedule._()
      : super(ModelServerCommandRemoteNotificationSchedule.command);

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const ModelServerCommandRemoteNotificationSchedule.fromServer({
    super.publicParameters = const {},
    super.privateParameters = const {},
  }) : super(ModelServerCommandRemoteNotificationSchedule.command);

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

  /// Convert from [json] map to [ModelServerCommandRemoteNotificationSchedule].
  ///
  /// [json]のマップから[ModelServerCommandRemoteNotificationSchedule]に変換します。
  factory ModelServerCommandRemoteNotificationSchedule.fromJson(
      DynamicMap json) {
    return ModelServerCommandRemoteNotificationSchedule.fromServer(
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

class _ModelServerCommandRemoteNotificationSchedule
    extends ModelServerCommandRemoteNotificationSchedule {
  const _ModelServerCommandRemoteNotificationSchedule({
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
  ModelServerCommandRemoteNotificationSchedule get command;
}
