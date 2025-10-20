part of "/masamune_ai.dart";

/// A local tool for WebSearch.
///
/// WebSearchのローカルツール。
@immutable
class WebSearchAILocalTool extends AILocalTool {
  /// A local tool for WebSearch.
  ///
  /// WebSearchのローカルツール。
  const WebSearchAILocalTool({
    this.parameters = const {
      "query": AISchema.string(
        description: "The search keywords or question to look up on the web.",
        nullable: false,
      ),
    },
    this.name = "WebSearch",
    this.onGenerateFunctionCallingConfig,
    this.onGenerateResults = defaultOnGenerateResults,
  });

  @override
  final String description =
      "Perform a live web search for the given query and return a concise, source-aware summary.";

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
  final String name;

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
  FutureOr<AIContent?> process(AIToolRef ref) async {
    final query = ref.call.args.get("query", "").trim();
    if (query.isEmpty) {
      return null;
    }
    final ai = AISingle(
      enableSearch: true,
      config: AIConfig(
        systemPromptContent: AIContent.system([
          AIContent.text(
            "You are a web search assistant. Use available web search tools to gather the most recent and relevant information, cite notable sources when possible, and return a concise summary of findings.",
          ),
        ]),
      ),
    );
    final res = await ai.generateContent(
      [
        AIContent.text(
          "Search the web for: \"$query\"\nSummarize the key findings and include source references when available.",
        ),
      ],
      includeSystemInitialContent: true,
    );
    if (res == null) {
      return null;
    }
    return AIContent.json(
      onGenerateResults.call([res], ref),
      references: res.references,
    );
  }
}
