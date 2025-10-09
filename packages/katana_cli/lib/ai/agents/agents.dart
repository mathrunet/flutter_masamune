// Project imports:
import "package:katana_cli/ai/agents/design_implementation_guide.dart";
import "package:katana_cli/ai/agents/design_rules_guide.dart";
import "package:katana_cli/ai/agents/flutter_widget_inspector.dart";
import "package:katana_cli/ai/agents/implementation_rules_guide.dart";
import "package:katana_cli/ai/agents/masamune_framework_helper.dart";
import "package:katana_cli/ai/agents/test_rules_guide.dart";
import "package:katana_cli/katana_cli.dart";

/// AgentsAiCode is a command that generates agents.
///
/// AgentsAiCodeはエージェントを生成するコマンドです。
class AgentsAiCode extends CliAiCodeCommand {
  /// AgentsAiCode is a command that generates agents.
  ///
  /// AgentsAiCodeはエージェントを生成するコマンドです。
  const AgentsAiCode();

  @override
  String get defaultDirectory => ".claude";

  @override
  bool get includeName => false;

  @override
  final String description =
      "Generate Markdown code to do the agents. エージェントを生成するためのMarkdownコードを生成します。";

  @override
  Map<String, CliAiCode> get codes => {
        "design_rules_guide": const DesignRulesGuideClaudeCodeAgentsCliAiCode(),
        "implementation_rules_guide":
            const ImplementationRulesGuideClaudeCodeAgentsCliAiCode(),
        "test_rules_guide": const TestRulesGuideClaudeCodeAgentsCliAiCode(),
        "masamune_framework_helper":
            const MasamuneFrameworkHelperClaudeCodeAgentsCliAiCode(),
        "design_implementation_guide":
            const DesignImplementationGuideClaudeCodeAgentsCliAiCode(),
        "flutter_widget_inspector":
            const FlutterWidgetInspectorClaudeCodeAgentsCliAiCode(),
      };
}
