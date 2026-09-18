// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Add a module for application handover (buyout) support.
///
/// アプリケーションハンドオーバー（バイアウト）対応のためのモジュールを追加します。
class AppHandoverCliAction extends CliCommand with CliActionMixin {
  /// Add a module for application handover (buyout) support.
  ///
  /// アプリケーションハンドオーバー（バイアウト）対応のためのモジュールを追加します。
  const AppHandoverCliAction();

  @override
  String get description =>
      "Add a module for application handover (buyout) support. アプリケーションハンドオーバー（バイアウト）対応のためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("handover");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final value = context.yaml.getAsMap("app").getAsMap("handover");
    final appId = value.get("app_id", "");
    if (appId.isEmpty) {
      error(
        "[app]->[handover]->[app_id] is empty. Please specify the application ID used for https://api.mathru.net/apps/{app_id}.json.",
      );
      return;
    }
    await addFlutterImport(
      [
        "masamune_handover",
      ],
    );
    label("Add the adapter to main.dart if not already added.");
    // ignore: avoid_print
    print(
      """
Register the following adapter in your main.dart:

final handoverAdapter = HandoverMasamuneAdapter(
  appId: "$appId",
);

The handover configuration will be retrieved from:
https://api.mathru.net/apps/$appId.json

Absence of the file is a normal condition (the app runs in normal mode).
""",
    );
  }
}
