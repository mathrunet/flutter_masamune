part of "/masamune_ai.dart";

/// Web search tool.
///
/// Web検索のツール。
@immutable
class WebSearchAIRemoteTool extends AIRemoteTool {
  /// Web search tool.
  ///
  /// Web検索のツール。
  const WebSearchAIRemoteTool({
    required this.prompt,
    required this.description,
    this.parameters = const {
      "query": AISchema.string(
        description: "The query of the web search.",
        nullable: false,
      ),
    },
    this.name = "WebSearch",
    this.onGenerateFunctionCallingConfig,
    this.onGenerateResults = defaultOnGenerateResults,
  });

  /// The prompt of the agent.
  ///
  /// エージェントのプロンプト。
  final String prompt;

  /// The function calling config of the agent.
  ///
  /// エージェントの関数呼び出し設定。
  final AIFunctionCallingConfig? Function(AIContent, Set<AITool>, int)?
      onGenerateFunctionCallingConfig;

  /// The function to generate the results of the agent.
  ///
  /// エージェントの結果を生成する関数。
  final DynamicMap Function(List<AIContent> contents, AIToolRef ref)
      onGenerateResults;

  @override
  Uri get endpoint => throw UnimplementedError();

  @override
  final String name;

  @override
  final String description;

  @override
  final Map<String, AISchema> parameters;

  /// The default function to generate the results of the agent.
  ///
  /// エージェントの結果を生成するデフォルト関数。
  static DynamicMap defaultOnGenerateResults(
      List<AIContent> contents, AIToolRef ref) {
    return {
      "result": contents.map((e) => e.toString()).join("\n"),
    };
  }

  @override
  Future<void> initialize() => Future.value();

  @override
  FutureOr<AIContent?> convertFromResponse(DynamicMap json) {
    // TODO: implement convertFromResponse
    throw UnimplementedError();
  }
}
