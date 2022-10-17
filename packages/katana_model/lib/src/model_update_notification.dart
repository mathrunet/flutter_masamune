part of katana_model;

/// Defines the change status of each model.
///
/// Change the behavior of the data in each model based on this status.
///
/// 各モデルの変更ステータスを定義します。
///
/// このステータスを元に各モデルのデータの振る舞いを変えてください。
enum ModelUpdateNotificationStatus {
  /// When data is added.
  ///
  /// データが追加されたとき。
  added,

  /// When data is changed.
  ///
  /// データが変更されたとき。
  modified,

  /// When data is deleted.
  ///
  /// データが削除されたとき。
  removed,
}

/// This class contains data for change notifications.
///
/// 変更通知を行う際のデータを格納したクラスです。
@immutable
class ModelUpdateNotification {
  /// This class contains data for change notifications.
  ///
  /// 変更通知を行う際のデータを格納したクラスです。
  const ModelUpdateNotification({
    required this.path,
    required this.id,
    required this.status,
    required this.value,
    this.origin,
    this.oldIndex,
    this.newIndex,
  });

  /// The path of the modified document.
  ///
  /// 変更されたドキュメントのパス。
  final String path;

  /// ID of the document being modified.
  ///
  ///　If the document path is `aaaaa/bbbbb/cccccc/ddddd`, the ID is `ddddd`.
  ///
  /// 変更されたドキュメントのID。
  ///
  /// ドキュメントのパスが`aaaa/bbbb/cccc/dddd`の場合、IDは`dddd`となります。
  final String id;

  /// The document/collection object you passed with [ModelAdapterDocumentQuery] when you passed it.
  ///
  /// [ModelAdapterDocumentQuery]を渡したときに一緒に渡したドキュメント/コレクションのオブジェクト。
  final Object? origin;

  /// Change status when changes are made.
  ///
  /// 変更が行われた際の変更ステータス。
  final ModelUpdateNotificationStatus status;

  /// Modified document value ([DynamicMap]).
  ///
  /// 変更後のドキュメントの値（[DynamicMap]）。
  final DynamicMap value;

  /// Index of the collection before the change.
  ///
  /// 変更前のコレクションのインデックス。
  final int? oldIndex;

  /// Index of the modified collection.
  ///
  /// 変更後のコレクションのインデックス。
  final int? newIndex;

  @override
  String toString() {
    return "$runtimeType(path: $path, id: $id, status: $status, origin: $origin, value: $value)";
  }
}
