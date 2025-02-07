import 'package:katana_cli/ai/docs/flutter_types.dart';
import 'package:katana_cli/ai/docs/katana_cli.dart';
import 'package:katana_cli/ai/docs/masamune.dart';
import 'package:katana_cli/ai/docs/modal_usage.dart';
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';
import 'package:katana_cli/ai/docs/model_filter_conditions.dart';
import 'package:katana_cli/ai/docs/model_usage.dart';
import 'package:katana_cli/ai/docs/primitive_types.dart';
import 'package:katana_cli/ai/docs/router_usage.dart';
import 'package:katana_cli/ai/docs/state_management_usage.dart';
import 'package:katana_cli/ai/docs/theme_usage.dart';
import 'package:katana_cli/ai/docs/transition_usage.dart';
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
        "masamune": const MasamuneDocsMdcCliAiCode(),
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
      };
}
