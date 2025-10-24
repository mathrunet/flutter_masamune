part of "/masamune_ai.dart";

/// Simulates AI interactions only on the runtime without actually connecting to an AI service [AIMasamuneAdapter]
///
/// Please use it for tests, etc.
///
/// 実際にAIサービスに繋げずにランタイム上のみでAIのやり取りをシミュレートする[AIMasamuneAdapter]
///
/// テスト等でご利用ください。
class RuntimeAIMasamuneAdapter extends AIMasamuneAdapter {
  /// Simulates AI interactions only on the runtime without actually connecting to an AI service [AIMasamuneAdapter]
  ///
  /// Please use it for tests, etc.
  ///
  /// 実際にAIサービスに繋げずにランタイム上のみでAIのやり取りをシミュレートする[AIMasamuneAdapter]
  ///
  /// テスト等でご利用ください。
  const RuntimeAIMasamuneAdapter({
    this.onGenerateContent,
    super.threadContentSortCallback =
        AIMasamuneAdapter.defaultThreadContentSortCallback,
    super.vectorModelAdapter,
    super.defaultAgentPromptTemplate,
    super.defaultAgentVectorMemoryConfig,
    super.maxAgentRecordStep = 100,
    super.appRef,
  });

  /// Simulates AI interactions only on the runtime without actually connecting to an AI service [AIMasamuneAdapter]
  ///
  /// Please use it for tests, etc.
  ///
  /// 実際にAIサービスに繋げずにランタイム上のみでAIのやり取りをシミュレートする[AIMasamuneAdapter]
  ///
  /// テスト等でご利用ください。
  final Future<AIContent?> Function(List<AIContent> content, AIConfig? config)?
      onGenerateContent;

  @override
  Future<void> initialize({
    AIConfig? config,
    Set<AITool> tools = const {},
    bool enableSearch = false,
  }) =>
      Future.value();

  @override
  bool isInitializedConfig({
    AIConfig? config,
    Set<AITool> tools = const {},
    bool enableSearch = false,
  }) =>
      true;

  @override
  Future<AIContent?> generateContent(
    List<AIContent> content, {
    Future<List<AIContentFunctionResponsePart>> Function(
            List<AIContentFunctionCallPart>)?
        onFunctionCall,
    AIConfig? config,
    bool includeSystemInitialContent = true,
    AIFunctionCallingConfig? Function(AIContent, Set<AITool>, int)?
        onGenerateFunctionCallingConfig,
    Set<AITool> tools = const {},
    bool enableSearch = false,
  }) async {
    final res = await onGenerateContent?.call(content, config);
    res?.complete();
    return res;
  }
}
