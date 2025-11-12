part of "/masamune_model_github.dart";

/// The level of a Copilot session log.
///
/// Copilotのセッションログのレベル。
enum GithubCopilotSessionLogLevel {
  /// Unknown level.
  ///
  /// 不明なレベル。
  unknown,

  /// Debug level.
  ///
  /// デバッグレベル。
  debug,

  /// Info level.
  ///
  /// 情報レベル。
  info,

  /// Warning level.
  ///
  /// 警告レベル。
  warning,

  /// Error level.
  ///
  /// エラーレベル。
  error;

  /// Converts the level of a Copilot session log from a string.
  ///
  /// 文字列からCopilotのセッションログのレベルを変換します。
  static GithubCopilotSessionLogLevel fromString(String level) {
    switch (level) {
      case "unknown":
        return unknown;
      case "debug":
        return debug;
      case "info":
        return info;
      case "warning":
      case "warn":
        return warning;
      case "error":
        return error;
      default:
        return unknown;
    }
  }
}
