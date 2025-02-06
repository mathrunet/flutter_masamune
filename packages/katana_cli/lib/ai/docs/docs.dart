import 'package:katana_cli/ai/docs/katana_cli.dart';
import 'package:katana_cli/ai/docs/masamune.dart';
import 'package:katana_cli/ai/docs/model_usage.dart';
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
      };
}
