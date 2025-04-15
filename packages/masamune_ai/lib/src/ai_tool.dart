part of '/masamune_ai.dart';

/// A tool for AI.
///
/// AIのツール。
class AITool {
  /// A tool for AI.
  ///
  /// AIのツール。
  const AITool({
    required this.name,
    required this.description,
    required this.parameters,
  });

  /// The name of the tool.
  ///
  /// ツールの名前。
  final String name;

  /// The description of the tool.
  ///
  /// ツールの説明。
  final String description;

  /// The parameters of the tool.
  ///
  /// ツールのパラメーター。
  final Map<String, AISchema> parameters;

  @override
  String toString() {
    return "Tool(name: $name, description: $description, parameters: $parameters)";
  }

  @override
  bool operator ==(Object other) {
    if (other is AITool) {
      return name == other.name;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode;
}
