part of "/masamune_scheduler.dart";

/// Abstract class for defining documents with a schedule for deleting all documents in a collection.
///
/// Implement this in the value you want [DocumentBase] to have.
///
/// コレクションの中のすべてのドキュメントを削除するのスケジュールを持ったドキュメントを定義するための抽象クラス。
///
/// これを[DocumentBase]に持たせる値に実装してください。
abstract class ModelDeleteDocumentsScheduleBase {
  /// Get the command for deleting all documents in a collection.
  ///
  /// コレクションの中のすべてのドキュメントを削除するためのコマンドを取得します。
  ModelServerCommandDeleteDocumentsSchedule get command;
}
