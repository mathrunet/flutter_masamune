part of "/masamune_workflow.dart";

/// The phase of the task log.
///
/// タスクログのフェーズ。
enum TaskLogPhase {
  /// The log phase is start.
  ///
  /// ログフェーズは開始です。
  start,

  /// The log phase is end.
  ///
  /// ログフェーズは終了です。
  end,

  /// The log phase is error.
  ///
  /// ログフェーズはエラーです。
  error,

  /// The log phase is warning.
  ///
  /// ログフェーズは警告です。
  warning,

  /// The log phase is info.
  ///
  /// ログフェーズは情報です。
  info;
}
