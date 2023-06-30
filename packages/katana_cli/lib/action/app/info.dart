// Dart imports:

// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/src/app_info.dart';

/// Set the application information.
///
/// アプリケーションの情報を設定します。
class AppInfoCliAction extends CliCommand with CliActionMixin {
  /// Set the application information.
  ///
  /// アプリケーションの情報を設定します。
  const AppInfoCliAction();

  @override
  String get description =>
      "Set the application title, icon, and other information based on the information in `katana.yaml`. `katana.yaml`の情報を元にアプリケーションのタイトルやアイコンなどの情報を設定します。";

  @override
  bool checkEnabled(ExecContext context) {
    final spreadSheet = context.yaml.getAsMap("app").getAsMap("spread_sheet");
    final enabledSpreadSheet = spreadSheet.get("enable", false);
    if (enabledSpreadSheet) {
      return false;
    }
    final info = context.yaml.getAsMap("app").getAsMap("info");
    final enabled = info.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      error("The item [app] is missing. Please add an item.");
      return;
    }
    final info = app.getAsMap("info");
    if (info.isEmpty) {
      error("The item [app]->[info] is missing. Please add an item.");
      return;
    }
    final locale = info.getAsMap("locale").map(
          (key, value) => MapEntry(
            key,
            (value as Map).map(
              (k, v) => MapEntry(k.toString(), v.toString()),
            ),
          ),
        );
    if (locale.isEmpty) {
      error("The item [app]->[info]->[locale] is missing. Please add an item.");
      return;
    }
    final domain = info.get("domain", "");
    String? defaultLocale;
    final data = <String, Map<String, String>>{};
    for (final entry in locale.entries) {
      defaultLocale ??= entry.key;
      data[entry.key] = entry.value;
    }
    await AppInfo.apply(
      data: data,
      domain: domain,
      defaultLocale: defaultLocale,
    );
  }
}
