import 'package:katana_cli/ai/impls/controller_impl.dart';
import 'package:katana_cli/ai/impls/meta_impl.dart';
import 'package:katana_cli/ai/impls/model_impl.dart';
import 'package:katana_cli/ai/impls/theme_impl.dart';
import 'package:katana_cli/ai/impls/widget_impl.dart';
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
        "widget_impl": const WidgetImplMdcCliAiCode(),
        "meta_impl": const MetaImplMdcCliAiCode(),
      };
}
