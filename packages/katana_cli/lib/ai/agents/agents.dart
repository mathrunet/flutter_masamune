// Project imports:
import "package:katana_cli/ai/agents/enhancement_development_implimenter.dart";
import "package:katana_cli/ai/agents/enhancement_development_requirements_analyzer.dart";
import "package:katana_cli/ai/agents/firebase_flutter_debugger.dart";
import "package:katana_cli/ai/agents/initial_development_designer.dart";
import "package:katana_cli/ai/agents/initial_development_implimenter.dart";
import "package:katana_cli/ai/agents/initial_development_requirements_analyzer.dart";
import "package:katana_cli/ai/agents/masamune_framework_advisor.dart";
import "package:katana_cli/ai/agents/package_advisor.dart";
import "package:katana_cli/ai/agents/test_runner.dart";
import "package:katana_cli/ai/agents/ui_builder.dart";
import "package:katana_cli/ai/agents/ui_debugger.dart";
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
        "masamune_framework_advisor":
            const MasamuneFrameworkAdvisorClaudeCodeAgentsCliAiCode(),
        "package_advisor": const PackageAdvisorClaudeCodeAgentsCliAiCode(),
        "initial_development_requirements_analyzer":
            const InitialDevelopmentRequirementsAnalyzerClaudeCodeAgentsCliAiCode(),
        "initial_development_designer":
            const InitialDevelopmentDesignerClaudeCodeAgentsCliAiCode(),
        "initial_development_implimenter":
            const InitialDevelopmentImplimenterClaudeCodeAgentsCliAiCode(),
        "enhancement_development_requirements_analyzer":
            const EnhancementDevelopmentRequirementsAnalyzerClaudeCodeAgentsCliAiCode(),
        "enhancement_development_implimenter":
            const EnhancementDevelopmentImplimenterClaudeCodeAgentsCliAiCode(),
        "firebase_flutter_debugger":
            const FirebaseFlutterDebuggerClaudeCodeAgentsCliAiCode(),
        "ui_builder": const UiBuilderClaudeCodeAgentsCliAiCode(),
        "ui_debugger": const UiDebuggerClaudeCodeAgentsCliAiCode(),
        "test_runner": const TestRunnerClaudeCodeAgentsCliAiCode(),
      };
}
