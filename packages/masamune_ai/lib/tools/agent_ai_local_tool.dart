part of "/masamune_ai.dart";

/// A local tool for AI.
///
/// AIのローカルツール。
@immutable
class AgentAILocalTool extends AILocalTool {
  /// A local tool for AI.
  ///
  /// AIのローカルツール。
  const AgentAILocalTool({
    required this.prompt,
    required this.description,
    this.parameters = const {
      "prompt": AISchema.string(
        description: "The prompt of the agent.",
        nullable: false,
      ),
    },
    this.name = "Agent",
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
  FutureOr<AIContent?> process(AIToolRef ref) async {
    final agenet = AIAgent(threadId: uuid(), initialContents: [
      AIContent.system(
        [AIContent.text(this.prompt)],
      ),
    ]);
    final prompt = ref.call.args.get("prompt", "");
    if (prompt.isEmpty) {
      return null;
    }
    final res = await agenet.generateContent(
      [AIContent.text(prompt)],
      tools: ref.tools,
      onGenerateFunctionCallingConfig: onGenerateFunctionCallingConfig,
    );
    if (res.isEmpty) {
      return null;
    }
    return AIContent.json(
      onGenerateResults.call(res, ref),
    );
  }
}
