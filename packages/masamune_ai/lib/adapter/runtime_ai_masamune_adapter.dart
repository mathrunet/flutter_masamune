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
  });

  final Future<AIContent?> Function(List<AIContent> content, AIConfig? config)?
      onGenerateContent;

  @override
  Future<void> initialize({AIConfig? config, Set<AITool> tools = const {}}) =>
      Future.value();

  @override
  bool isInitializedConfig({AIConfig? config, Set<AITool> tools = const {}}) =>
      true;

  @override
  Future<AIContent?> generateContent(List<AIContent> content,
      {AIConfig? config,
      bool includeSystemInitialContent = true,
      required Future<List<AIContentFunctionResponsePart>> Function(
              List<AIContentFunctionCallPart>)
          onFunctionCall,
      AIFunctionCallingConfig? Function(AIContent, Set<AITool>, int)?
          onGenerateFunctionCallingConfig,
      Set<AITool> tools = const {}}) async {
    final res = await onGenerateContent?.call(content, config);
    res?.complete();
    return res;
  }
}
