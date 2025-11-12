part of "/masamune_model_github.dart";

/// The status of the Copilot session.
///
/// Copilotのセッションの状態。
enum GithubCopilotSessionStatus {
  /// No session is running.
  ///
  /// セッションが実行中ではありません。
  none,

  /// Unknown status.
  ///
  /// 不明な状態。
  unknown,

  /// A session is running.
  ///
  /// セッションが実行中です。
  running,

  /// A session is completed.
  ///
  /// セッションが完了しました。
  completed,

  /// A session is failed.
  ///
  /// セッションが失敗しました。
  failed;

  /// Converts the Copilot session state from a string.
  ///
  /// 文字列からCopilotのセッションの状態を変換します。
  static GithubCopilotSessionStatus fromString(String status) {
    switch (status) {
      case "none":
        return none;
      case "unknown":
        return unknown;
      case "running":
      case "in_progress":
        return running;
      case "completed":
      case "success":
        return completed;
      case "failed":
      case "error":
        return failed;
      default:
        return unknown;
    }
  }
}
