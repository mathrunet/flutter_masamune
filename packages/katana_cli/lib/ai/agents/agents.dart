// Project imports:
import "package:katana_cli/ai/agents/design_implementation_guide.dart";
import "package:katana_cli/ai/agents/design_rules_guide.dart";
import "package:katana_cli/ai/agents/figma_to_flutter_ui.dart";
import "package:katana_cli/ai/agents/firebase_flutter_debugger.dart";
import "package:katana_cli/ai/agents/flutter_widget_inspector.dart";
import "package:katana_cli/ai/agents/image_to_flutter_ui.dart";
import "package:katana_cli/ai/agents/implementation_rules_guide.dart";
import "package:katana_cli/ai/agents/masamune_framework_helper.dart";
import "package:katana_cli/ai/agents/masamune_plugin_guide.dart";
import "package:katana_cli/ai/agents/notion_requirements_analyzer.dart";
import "package:katana_cli/ai/agents/package_finder.dart";
import "package:katana_cli/ai/agents/test_rules_guide.dart";
import "package:katana_cli/ai/agents/text_requirements_analyzer.dart";
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
        "firebase_flutter_debugger":
            const FirebaseFlutterDebuggerClaudeCodeAgentsCliAiCode(),
        "notion_requirements_analyzer":
            const NotionRequirementsAnalyzerClaudeCodeAgentsCliAiCode(),
        "text_requirements_analyzer":
            const TextRequirementsAnalyzerClaudeCodeAgentsCliAiCode(),
        "masamune_plugin_guide":
            const MasamunePluginGuideClaudeCodeAgentsCliAiCode(),
        "package_finder": const PackageFinderClaudeCodeAgentsCliAiCode(),
        "figma_to_flutter_ui": const FigmaToFlutterUiClaudeCodeAgentsCliAiCode(),
        "image_to_flutter_ui": const ImageToFlutterUiClaudeCodeAgentsCliAiCode(),
      };
}
