// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use OpenAI's API.
///
/// OpenAIのAPIを利用するためのモジュールを追加します。
class AppOpenAICliAction extends CliCommand with CliActionMixin {
  /// Add a module to use OpenAI's API.
  ///
  /// OpenAIのAPIを利用するためのモジュールを追加します。
  const AppOpenAICliAction();

  @override
  String get description =>
      "Add a module to use OpenAI's API. OpenAIのAPIを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("openai");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    await addFlutterImport(
      [
        "masamune_ai_openai",
      ],
    );
  }
}
