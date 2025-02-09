// Project imports:
import 'package:katana_cli/ai/docs/design_document.dart';
import 'package:katana_cli/ai/docs/file_structure.dart';
import 'package:katana_cli/ai/docs/flutter_types.dart';
import 'package:katana_cli/ai/docs/flutter_widgets.dart';
import 'package:katana_cli/ai/docs/form_usage.dart';
import 'package:katana_cli/ai/docs/functions_usage.dart';
import 'package:katana_cli/ai/docs/katana_cli.dart';
import 'package:katana_cli/ai/docs/katana_ui_usage.dart';
import 'package:katana_cli/ai/docs/modal_usage.dart';
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';
import 'package:katana_cli/ai/docs/model_filter_conditions.dart';
import 'package:katana_cli/ai/docs/model_usage.dart';
import 'package:katana_cli/ai/docs/naming_convention.dart';
import 'package:katana_cli/ai/docs/plugin_usage.dart';
import 'package:katana_cli/ai/docs/primitive_types.dart';
import 'package:katana_cli/ai/docs/router_usage.dart';
import 'package:katana_cli/ai/docs/state_management_usage.dart';
import 'package:katana_cli/ai/docs/technology_stack.dart';
import 'package:katana_cli/ai/docs/terminology.dart';
import 'package:katana_cli/ai/docs/theme_usage.dart';
import 'package:katana_cli/ai/docs/transition_usage.dart';
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';
import 'package:katana_cli/katana_cli.dart';

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
        "katana_cli": const KatanaCliDocsMdcCliAiCode(),
        "model_usage": const ModelUsageMdcCliAiCode(),
        "state_management_usage": const StateManagementUsageMdcCliAiCode(),
        "transition_usage": const TransitionUsageMdcCliAiCode(),
        "router_usage": const RouterUsageMdcCliAiCode(),
        "theme_usage": const ThemeUsageMdcCliAiCode(),
        "modal_usage": const ModalUsageMdcCliAiCode(),
        "model_field_value_usage": const ModelFieldValueUsageMdcCliAiCode(),
        for (final entry in kModelFieldValueList.entries)
          entry.key.toSnakeCase(): entry.value,
        "primitive_types": const PrimitiveTypesMdcCliAiCode(),
        "flutter_types": const FlutterTypesMdcCliAiCode(),
        "model_filter_conditions": const ModelFilterConditionsMdcCliAiCode(),
        "katana_ui_usage": const KatanaUiUsageMdcCliAiCode(),
        for (final entry in kUniversalUiList.entries)
          entry.key.toSnakeCase(): entry.value,
        "universal_ui_usage": const UniversalUiUsageMdcCliAiCode(),
        for (final entry in kKatanaUiList.entries)
          entry.key.toSnakeCase(): entry.value,
        "form_usage": const FormUsageMdcCliAiCode(),
        for (final entry in kFormList.entries)
          entry.key.toSnakeCase(): entry.value,
        "flutter_widgets": const FlutterWidgetsMdcCliAiCode(),
        "plugin_usage": const PluginUsageMdcCliAiCode(),
        for (final entry in kPluginList.entries)
          entry.key.toSnakeCase(): entry.value,
        "design_document": const DesignDocumentDocsMdcCliAiCode(),
        "file_structure": const FileStructureDocsMdcCliAiCode(),
        "naming_convention": const NamingConventionDocsMdcCliAiCode(),
        "technology_stack": const TechnologyStackDocsMdcCliAiCode(),
        "terminology": const TerminologyDocsMdcCliAiCode(),
        "functions_usage": const FunctionsUsageDocsMdcCliAiCode(),
      };
}
