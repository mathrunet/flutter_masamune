part of '/masamune_ai.dart';

/// The configuration of the AI.
///
/// AIの設定。
class AIConfig {
  /// The configuration of the AI.
  ///
  /// AIの設定。
  const AIConfig({
    this.systemPromptContent,
    this.responseSchema,
  });

  /// The system prompt of the AI.
  ///
  /// AIのシステムプロンプト。
  final AIContent? systemPromptContent;

  /// The response schema of the AI.
  ///
  /// AIのレスポンススキーマ。
  final AISchema? responseSchema;

  @override
  String toString() {
    return "AIConfig(systemPrompt: $systemPromptContent, responseSchema: $responseSchema)";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIConfig) {
      return systemPromptContent == other.systemPromptContent &&
          responseSchema == other.responseSchema;
    }
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(systemPromptContent, responseSchema);
  }
}
