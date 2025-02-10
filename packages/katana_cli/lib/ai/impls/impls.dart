// Project imports:
import 'package:katana_cli/ai/impls/controller_method_creation.dart';
import 'package:katana_cli/ai/impls/metadata_impl.dart';
import 'package:katana_cli/ai/impls/mock_data_impl.dart';
import 'package:katana_cli/ai/impls/model_impl.dart';
import 'package:katana_cli/ai/impls/page_creation.dart';
import 'package:katana_cli/ai/impls/page_logic_impl.dart';
import 'package:katana_cli/ai/impls/page_ui_impl.dart';
import 'package:katana_cli/ai/impls/plugin_impl.dart';
import 'package:katana_cli/ai/impls/theme_impl.dart';
import 'package:katana_cli/ai/impls/widget_creation.dart';
import 'package:katana_cli/ai/impls/widget_logic_impl.dart';
import 'package:katana_cli/ai/impls/widget_ui_impl.dart';
import 'package:katana_cli/katana_cli.dart';

/// ImplsAiCode is a command that generates AI code to do the design.
///
/// ImplsAiCodeは設計を行うためのAIコードを生成するコマンドです。
class ImplsAiCode extends CliAiCodeCommand {
  /// ImplsAiCode is a command that generates AI code to do the design.
  ///
  /// ImplsAiCodeは設計を行うためのAIコードを生成するコマンドです。
  const ImplsAiCode();

  @override
  final String description =
      "Generate AI code for implementation. 実装を行うためのAIコードを生成します。";

  @override
  Map<String, CliAiCode> get codes => {
        "controller_impl": const ControllerImplMdcCliAiCode(),
        "model_impl": const ModelImplMdcCliAiCode(),
        "theme_impl": const ThemeImplMdcCliAiCode(),
        "widget_creation": const WidgetCreationMdcCliAiCode(),
        "widget_ui_impl": const WidgetUiImplMdcCliAiCode(),
        "widget_logic_impl": const WidgetLogicImplMdcCliAiCode(),
        "metadata_impl": const MetadataImplMdcCliAiCode(),
        "page_creation": const PageCreationMdcCliAiCode(),
        "page_ui_impl": const PageUiImplMdcCliAiCode(),
        "page_logic_impl": const PageLogicImplMdcCliAiCode(),
        "plugin_impl": const PluginImplMdcCliAiCode(),
        "mock_data_impl": const MockDataImplMdcCliAiCode(),
      };
}
