// Project imports:
import 'package:katana_cli/ai/impls/controller_creation.dart';
import 'package:katana_cli/ai/impls/controller_method_creation.dart';
import 'package:katana_cli/ai/impls/metadata_impl.dart';
import 'package:katana_cli/ai/impls/mock_data_impl.dart';
import 'package:katana_cli/ai/impls/model_impl.dart';
import 'package:katana_cli/ai/impls/page_creation.dart';
import 'package:katana_cli/ai/impls/page_logic_impl.dart';
import 'package:katana_cli/ai/impls/page_ui_impl.dart';
import 'package:katana_cli/ai/impls/plugin_impl.dart';
import 'package:katana_cli/ai/impls/router_impl.dart';
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
        "controller_creation": const ControllerCreationMdCliAiCode(),
        "controller_method_creation": const ControllerImplMdCliAiCode(),
        "controller_impl": const ControllerImplMdCliAiCode(),
        "model_impl": const ModelImplMdCliAiCode(),
        "theme_impl": const ThemeImplMdCliAiCode(),
        "widget_creation": const WidgetCreationMdCliAiCode(),
        "widget_ui_impl": const WidgetUiImplMdCliAiCode(),
        "widget_logic_impl": const WidgetLogicImplMdCliAiCode(),
        "metadata_impl": const MetadataImplMdCliAiCode(),
        "page_creation": const PageCreationMdCliAiCode(),
        "page_ui_impl": const PageUiImplMdCliAiCode(),
        "page_logic_impl": const PageLogicImplMdCliAiCode(),
        "plugin_impl": const PluginImplMdCliAiCode(),
        "mock_data_impl": const MockDataImplMdCliAiCode(),
        "router_impl": const RouterImplMdCliAiCode(),
      };
}
