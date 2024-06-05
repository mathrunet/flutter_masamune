// ignore: unused_import, unnecessary_import

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

// Project imports:
import 'package:masamune_notification/masamune_notification.dart';

part 'local_notification_schedule.m.dart';
part 'local_notification_schedule.g.dart';
part 'local_notification_schedule.freezed.dart';

/// Model for scheduling and registering local PUSH notifications.
///
/// Specify the date and time to send the notification in [time].
///
/// Specify the title of the notification in [title]. Specify the body of the notification in [text].
///
/// ローカルPUSH通知をスケジュールして登録するためのモデルです。
///
/// [time]に通知を送信する日時を指定します。
///
/// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
@freezed
@formValue
@immutable
@CollectionModelPath(
  SchedulerQuery.path,
  adapter: "LocalNotificationMasamuneAdapter.primary.modelAdapter",
)
class LocalNotificationScheduleModel with _$LocalNotificationScheduleModel {
  /// Model for scheduling and registering local PUSH notifications.
  ///
  /// Specify the date and time to send the notification in [time].
  ///
  /// Specify the title of the notification in [title]. Specify the body of the notification in [text].
  ///
  /// ローカルPUSH通知をスケジュールして登録するためのモデルです。
  ///
  /// [time]に通知を送信する日時を指定します。
  ///
  /// [title]に通知のタイトルを指定します。[text]に通知の本文を指定します。
  const factory LocalNotificationScheduleModel({
    int? id,
    @Default(ModelTimestamp()) ModelTimestamp time,
    @Default(LocalNotificationRepeatSettings.none)
    LocalNotificationRepeatSettings repeat,
    @Default("") String title,
    @Default("") String text,
    @Default({}) DynamicMap data,
  }) = _LocalNotificationScheduleModel;
  const LocalNotificationScheduleModel._();

  factory LocalNotificationScheduleModel.fromJson(Map<String, Object?> json) =>
      _$LocalNotificationScheduleModelFromJson(json);

  /// Collection path for registering local PUSH schedules.
  ///
  /// ローカルPUSHスケジュールを登録するためのコレクションパス。
  static const String path = "plugins/local_notification/schedule";

  /// Query for document.
  ///
  /// ```dart
  /// appref.app.model(LocalNotificationScheduleModel.document(id));       // Get the document.
  /// ref.app.model(LocalNotificationScheduleModel.document(id))..load();  // Load the document.
  /// ```
  static const document = _$LocalNotificationScheduleModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(LocalNotificationScheduleModel.collection());       // Get the collection.
  /// ref.app.model(LocalNotificationScheduleModel.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   LocalNotificationScheduleModel.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _$LocalNotificationScheduleModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(LocalNotificationScheduleModel.form(LocalNotificationScheduleModel()));    // Get the form controller in app scope.
  /// ref.page.form(LocalNotificationScheduleModel.form(LocalNotificationScheduleModel()));    // Get the form controller in page scope.
  /// ```
  static const form = _$LocalNotificationScheduleModelFormQuery();
}

/// [Enum] of the name of the value defined in LocalNotificationScheduleModel.
typedef LocalNotificationScheduleModelKeys
    = _$LocalNotificationScheduleModelKeys;

/// Alias for ModelRef<LocalNotificationScheduleModel>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(LocalNotificationScheduleModelDocument) LocalNotificationScheduleModelRef push_notification_schedule
/// ```
typedef LocalNotificationScheduleModelRef
    = ModelRef<LocalNotificationScheduleModel>?;

/// It can be defined as an empty ModelRef<LocalNotificationScheduleModel>.
///
/// ```dart
/// LocalNotificationScheduleModelRefPath("xxx") // Define as a path.
/// ```
typedef LocalNotificationScheduleModelRefPath
    = _$LocalNotificationScheduleModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     LocalNotificationScheduleModelInitialCollection(
///       "xxx": LocalNotificationScheduleModel(...),
///     ),
///   ],
/// );
/// ```
typedef LocalNotificationScheduleModelInitialCollection
    = _$LocalNotificationScheduleModelInitialCollection;

/// Document class for storing LocalNotificationScheduleModel.
typedef LocalNotificationScheduleModelDocument
    = _$LocalNotificationScheduleModelDocument;

/// Collection class for storing LocalNotificationScheduleModel.
typedef LocalNotificationScheduleModelCollection
    = _$LocalNotificationScheduleModelCollection;

/// It can be defined as an empty ModelRef<LocalNotificationScheduleModel>.
///
/// ```dart
/// LocalNotificationScheduleModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef LocalNotificationScheduleModelMirrorRefPath
    = _$LocalNotificationScheduleModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     LocalNotificationScheduleModelMirrorInitialCollection(
///       "xxx": LocalNotificationScheduleModel(...),
///     ),
///   ],
/// );
/// ```
typedef LocalNotificationScheduleModelMirrorInitialCollection
    = _$LocalNotificationScheduleModelMirrorInitialCollection;

/// Document class for storing LocalNotificationScheduleModel.
typedef LocalNotificationScheduleModelMirrorDocument
    = _$LocalNotificationScheduleModelMirrorDocument;

/// Collection class for storing LocalNotificationScheduleModel.
typedef LocalNotificationScheduleModelMirrorCollection
    = _$LocalNotificationScheduleModelMirrorCollection;
