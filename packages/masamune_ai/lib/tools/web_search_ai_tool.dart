part of "/masamune_ai.dart";

/// A tool to search the web for information.
///
/// AIのWeb検索ツール。
@immutable
class WebSearchAITool extends AITool {
  /// A tool to search the web for information.
  ///
  /// AIのWeb検索ツール。
  const WebSearchAITool();

  @override
  String get name => "__web_search__";

  @override
  String get description => "Search the web for information";

  @override
  Map<String, AISchema> get parameters => const {};
}
