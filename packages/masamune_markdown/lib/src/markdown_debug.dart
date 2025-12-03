part of "package:masamune_markdown/masamune_markdown.dart";

/// Prints a debug message only when [MarkdownMasamuneAdapter.showDebugLogs] is true.
///
/// デバッグメッセージを [MarkdownMasamuneAdapter.showDebugLogs] が true のときのみ出力します。
void markdownDebugPrint(String message) {
  if (MarkdownMasamuneAdapter.primary.showDebugLogs) {
    debugPrint(message);
  }
}
