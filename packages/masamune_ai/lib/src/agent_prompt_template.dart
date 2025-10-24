part of "/masamune_ai.dart";

/// A template for structuring agent prompts.
///
/// エージェントプロンプトを構造化するためのテンプレート。
@immutable
class AgentPromptTemplate {
  /// A template for structuring agent prompts.
  ///
  /// エージェントプロンプトを構造化するためのテンプレート。
  const AgentPromptTemplate({
    required this.role,
    required this.task,
    this.rules = const [],
    this.examples = const [],
    this.outputFormat,
    this.constraints = const [],
    this.context,
  });

  /// The role of the agent.
  ///
  /// エージェントの役割。
  final String role;

  /// The task description.
  ///
  /// タスクの説明。
  final String task;

  /// The execution rules.
  ///
  /// 実行ルール。
  final List<String> rules;

  /// The usage examples (for few-shot learning).
  ///
  /// 使用例（Few-shot学習用）。
  final List<String> examples;

  /// The output format specification.
  ///
  /// 出力フォーマットの仕様。
  final String? outputFormat;

  /// The constraints or limitations.
  ///
  /// 制約や制限事項。
  final List<String> constraints;

  /// Additional context information.
  ///
  /// 追加のコンテキスト情報。
  final String? context;

  /// Generates a structured prompt string.
  ///
  /// 構造化されたプロンプト文字列を生成します。
  String generate() {
    final buffer = StringBuffer();

    // Role
    buffer.writeln("# Role");
    buffer.writeln(role);
    buffer.writeln();

    // Task
    buffer.writeln("# Task");
    buffer.writeln(task);
    buffer.writeln();

    // Context
    if (context != null && context!.isNotEmpty) {
      buffer.writeln("# Context");
      buffer.writeln(context);
      buffer.writeln();
    }

    // Rules
    if (rules.isNotEmpty) {
      buffer.writeln("# Rules");
      for (var i = 0; i < rules.length; i++) {
        buffer.writeln("${i + 1}. ${rules[i]}");
      }
      buffer.writeln();
    }

    // Constraints
    if (constraints.isNotEmpty) {
      buffer.writeln("# Constraints");
      for (var i = 0; i < constraints.length; i++) {
        buffer.writeln("${i + 1}. ${constraints[i]}");
      }
      buffer.writeln();
    }

    // Examples
    if (examples.isNotEmpty) {
      buffer.writeln("# Examples");
      for (var i = 0; i < examples.length; i++) {
        buffer.writeln("Example ${i + 1}:");
        buffer.writeln(examples[i]);
        buffer.writeln();
      }
    }

    // Output Format
    if (outputFormat != null && outputFormat!.isNotEmpty) {
      buffer.writeln("# Output Format");
      buffer.writeln(outputFormat);
      buffer.writeln();
    }

    return buffer.toString().trim();
  }

  /// Creates a copy of this template with some fields replaced.
  ///
  /// このテンプレートのコピーを、一部のフィールドを置き換えて作成します。
  AgentPromptTemplate copyWith({
    String? role,
    String? task,
    List<String>? rules,
    List<String>? examples,
    String? outputFormat,
    List<String>? constraints,
    String? context,
  }) {
    return AgentPromptTemplate(
      role: role ?? this.role,
      task: task ?? this.task,
      rules: rules ?? this.rules,
      examples: examples ?? this.examples,
      outputFormat: outputFormat ?? this.outputFormat,
      constraints: constraints ?? this.constraints,
      context: context ?? this.context,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AgentPromptTemplate) {
      return false;
    }
    return runtimeType == other.runtimeType &&
        role == other.role &&
        task == other.task &&
        rules.equalsTo(other.rules) &&
        examples.equalsTo(other.examples) &&
        outputFormat == other.outputFormat &&
        constraints.equalsTo(other.constraints) &&
        context == other.context;
  }

  @override
  int get hashCode =>
      role.hashCode ^
      task.hashCode ^
      Object.hashAll(rules) ^
      Object.hashAll(examples) ^
      (outputFormat?.hashCode ?? 0) ^
      Object.hashAll(constraints) ^
      (context?.hashCode ?? 0);
}
