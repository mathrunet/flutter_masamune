part of "/masamune_workflow.dart";

/// The status of the workflow task.
///
/// ワークフロータスクのステータス。
enum WorkflowTaskStatus {
  /// The task is waiting.
  ///
  /// タスクが待機中。
  waiting,

  /// The task is running.
  ///
  /// タスクが実行中。
  running,

  /// The task is failed.
  ///
  /// タスクが失敗しました。
  failed,

  /// The task is completed.
  ///
  /// タスクが完了しました。
  completed,

  /// The task is canceled.
  ///
  /// タスクがキャンセルされました。
  canceled;
}
