part of "/masamune_ai.dart";

/// The configuration of the AI.
///
/// AIの設定。
@immutable
class AIConfig {
  /// The configuration of the AI.
  ///
  /// AIの設定。
  const AIConfig({
    this.systemPromptContent,
    this.responseSchema,
    this.model,
  });

  /// The model of the AI.
  ///
  /// AIのモデル。
  final String? model;

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
    return "AIConfig(systemPrompt: $systemPromptContent, responseSchema: $responseSchema, model: $model)";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIConfig) {
      return systemPromptContent == other.systemPromptContent &&
          responseSchema == other.responseSchema &&
          model == other.model;
    }
    return false;
  }

  @override
  int get hashCode {
    return systemPromptContent.hashCode ^
        responseSchema.hashCode ^
        model.hashCode;
  }
}

/// AI tools and settings.
///
/// AIのツールと設定。
@immutable
class AIConfigKey {
  /// AI tools and settings.
  ///
  /// AIのツールと設定。
  const AIConfigKey({
    this.config,
    this.tools = const {},
  });

  /// The configuration of the AI.
  ///
  /// AIの設定。
  final AIConfig? config;

  /// The tools of the AI.
  ///
  /// AIのツール。
  final Set<AITool> tools;

  @override
  String toString() {
    return "AIConfigKey(config: $config, tools: $tools)";
  }

  @override
  bool operator ==(Object other) {
    if (other is AIConfigKey) {
      return config == other.config && tools.equalsTo(other.tools);
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = config.hashCode;
    for (final tool in tools) {
      hash = hash ^ tool.hashCode;
    }
    return hash;
  }
}
