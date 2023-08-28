// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

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
@CollectionModelPath("plugins/notification/schedule")
class PushNotificationScheduleModel with _$PushNotificationScheduleModel {
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
    required ModelTimestamp time,
    required String title,
    required String text,
    String? channelId,
    DynamicMap? data,
    String? token,
    String? topic,
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
