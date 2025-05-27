// Project imports:
import 'package:katana_cli/ai/designs/controller_design.dart';
import 'package:katana_cli/ai/designs/metadata_design.dart';
import 'package:katana_cli/ai/designs/model_design.dart';
import 'package:katana_cli/ai/designs/page_design.dart';
import 'package:katana_cli/ai/designs/plugin_design.dart';
import 'package:katana_cli/ai/designs/theme_design.dart';
import 'package:katana_cli/ai/designs/widget_design.dart';
import 'package:katana_cli/katana_cli.dart';

/// DesignsAiCode is a command that generates AI code to do the design.
///
/// DesignsAiCodeは設計を行うためのAIコードを生成するコマンドです。
class DesignsAiCode extends CliAiCodeCommand {
  /// DesignsAiCode is a command that generates AI code to do the design.
  ///
  /// DesignsAiCodeは設計を行うためのAIコードを生成するコマンドです。
  const DesignsAiCode();

  @override
  final String description =
      "Generate AI code to do the design. 設計を行うためのAIコードを生成します。";

  @override
  Map<String, CliAiCode> get codes => {
        "page_design": const PageDesignMdCliAiCode(),
        "theme_design": const ThemeDesignMdCliAiCode(),
        "widget_design": const WidgetDesignMdCliAiCode(),
        "plugin_design": const PluginDesignMdCliAiCode(),
        "model_design": const ModelDesignMdCliAiCode(),
        "controller_design": const ControllerDesignMdCliAiCode(),
        "metadata_design": const MetadataDesignMdCliAiCode(),
      };
}
