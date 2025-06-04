part of "/masamune_scheduler.dart";

/// Abstract class for defining a document with a schedule for copying the document at a specified date and time.
///
/// Implement this in the value you want [DocumentBase] to have.
///
/// ドキュメントを指定日時にコピーするためのスケジュールを持ったドキュメントを定義するための抽象クラス。
///
/// これを[DocumentBase]に持たせる値に実装してください。
abstract class ModelCopyDocumentScheduleBase {
  /// Get the command for copying the document.
  ///
  /// ドキュメントをコピーするためのコマンドを取得します。
  ModelServerCommandCopyDocumentSchedule get command;
}
