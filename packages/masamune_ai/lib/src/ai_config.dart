part of '/masamune_ai.dart';

/// The configuration of the AI.
///
/// AIの設定。
class AIConfig {
  /// The configuration of the AI.
  ///
  /// AIの設定。
  const AIConfig({
    this.systemPrompt,
    this.responseSchema,
  });

  /// The system prompt of the AI.
  ///
  /// AIのシステムプロンプト。
  final String? systemPrompt;

  /// The response schema of the AI.
  ///
  /// AIのレスポンススキーマ。
  final AISchema? responseSchema;

  @override
  String toString() {
    return "AIConfig(systemPrompt: $systemPrompt, responseSchema: $responseSchema)";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIConfig) {
      return systemPrompt == other.systemPrompt &&
          responseSchema == other.responseSchema;
    }
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(systemPrompt, responseSchema);
  }
}
