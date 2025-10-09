// Project imports:
import "package:katana_cli/ai/docs/commit.dart";
import "package:katana_cli/ai/docs/dart_doc.dart";
import "package:katana_cli/ai/docs/design_document.dart";
import "package:katana_cli/ai/docs/enum_usage.dart";
import "package:katana_cli/ai/docs/file_structure.dart";
import "package:katana_cli/ai/docs/flutter_types.dart";
import "package:katana_cli/ai/docs/flutter_widgets.dart";
import "package:katana_cli/ai/docs/form_usage.dart";
import "package:katana_cli/ai/docs/functions_usage.dart";
import "package:katana_cli/ai/docs/katana_cli.dart";
import "package:katana_cli/ai/docs/katana_ui_usage.dart";
import "package:katana_cli/ai/docs/mock_data_usage.dart";
import "package:katana_cli/ai/docs/modal_usage.dart";
import "package:katana_cli/ai/docs/model_field_value_usage.dart";
import "package:katana_cli/ai/docs/model_filter_conditions.dart";
import "package:katana_cli/ai/docs/model_usage.dart";
import "package:katana_cli/ai/docs/naming_convention.dart";
import "package:katana_cli/ai/docs/page_types.dart";
import "package:katana_cli/ai/docs/plugin_usage.dart";
import "package:katana_cli/ai/docs/pre_commit.dart";
import "package:katana_cli/ai/docs/primitive_types.dart";
import "package:katana_cli/ai/docs/router_usage.dart";
import "package:katana_cli/ai/docs/state_management_usage.dart";
import "package:katana_cli/ai/docs/technology_stack.dart";
import "package:katana_cli/ai/docs/terminology.dart";
import "package:katana_cli/ai/docs/theme_usage.dart";
import "package:katana_cli/ai/docs/transition_usage.dart";
import "package:katana_cli/ai/docs/universal_ui_usage.dart";
import "package:katana_cli/ai/tests/tests.dart";
import "package:katana_cli/katana_cli.dart";

/// DocsAiCode is a command that generates AI code to do the design.
///
/// DocsAiCodeは設計を行うためのAIコードを生成するコマンドです。
class DocsAiCode extends CliAiCodeCommand {
  /// DocsAiCode is a command that generates AI code to do the design.
  ///
  /// DocsAiCodeは設計を行うためのAIコードを生成するコマンドです。
  const DocsAiCode();

  @override
  final String description =
      "Generate documentation for AI for the Masamune framework. MasamuneフレームワークのAI向けドキュメントを生成します。";

  @override
  Map<String, CliAiCode> get codes => {
        "katana_cli": const KatanaCliDocsMdCliAiCode(),
        "model_usage": const ModelUsageMdCliAiCode(),
        "enum_usage": const EnumUsageMdCliAiCode(),
        "state_management_usage": const StateManagementUsageMdCliAiCode(),
        "transition_usage": const TransitionUsageMdCliAiCode(),
        "router_usage": const RouterUsageMdCliAiCode(),
        "theme_usage": const ThemeUsageMdCliAiCode(),
        "modal_usage": const ModalUsageMdCliAiCode(),
        "model_field_value_usage": const ModelFieldValueUsageMdCliAiCode(),
        for (final entry in kModelFieldValueList.entries)
          entry.key.toSnakeCase(): entry.value,
        "page_types": const PageTypesMdCliAiCode(),
        "primitive_types": const PrimitiveTypesMdCliAiCode(),
        "flutter_types": const FlutterTypesMdCliAiCode(),
        "model_filter_conditions": const ModelFilterConditionsMdCliAiCode(),
        "katana_ui_usage": const KatanaUiUsageMdCliAiCode(),
        for (final entry in kUniversalUiList.entries)
          entry.key.toSnakeCase(): entry.value,
        "universal_ui_usage": const UniversalUiUsageMdCliAiCode(),
        for (final entry in kKatanaUiList.entries)
          entry.key.toSnakeCase(): entry.value,
        "form_usage": const FormUsageMdCliAiCode(),
        for (final entry in kFormList.entries)
          entry.key.toSnakeCase(): entry.value,
        "flutter_widgets": const FlutterWidgetsMdCliAiCode(),
        "plugin_usage": const PluginUsageMdCliAiCode(),
        for (final entry in kPluginList.entries)
          entry.key.toSnakeCase(): entry.value,
        "design_document": const DesignDocumentDocsMdCliAiCode(),
        "file_structure": const FileStructureDocsMdCliAiCode(),
        "naming_convention": const NamingConventionDocsMdCliAiCode(),
        "technology_stack": const TechnologyStackDocsMdCliAiCode(),
        "terminology": const TerminologyDocsMdCliAiCode(),
        "functions_usage": const FunctionsUsageDocsMdCliAiCode(),
        "dart_doc": const DartDocDocsMdCliAiCode(),
        "pre_commit": const PreCommitMdCliAiCode(),
        "commit": const CommitMdCliAiCode(),
        "mock_data_usage": const MockDataUsageMdCliAiCode(),
        "test": const TestMdCliAiCode(),
      };
}
