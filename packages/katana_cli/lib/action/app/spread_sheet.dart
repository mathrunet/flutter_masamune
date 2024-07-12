// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:csv/csv.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/src/app_info.dart';

/// Spreadsheet cache path.
///
/// スプレッドシートのキャッシュパス。
const kGoogleSpreadSheetPath = ".dart_tool/katana/google_spread_sheet.json";

final _mapping = [
  "timestamp",
  "email",
  "name",
  "locale",
  "title",
  "short_title",
  "overview",
  "detail",
  "keyword",
  "official_url",
  "support_url",
  "support_email",
  "terms_url",
  "privacy_url",
  "icon",
  "feature",
  "screenshot_5.5",
  "screenshot_6.5",
  "screenshot_tablet",
  "screenshot_6.7",
  "copyright",
];

/// Set the application information from the spreadsheet.
///
/// スプレッドシートからのアプリケーションの情報を設定します。
class AppSpreadSheetCliAction extends CliCommand with CliActionMixin {
  /// Set the application information from the spreadsheet.
  ///
  /// スプレッドシートからのアプリケーションの情報を設定します。
  const AppSpreadSheetCliAction();

  @override
  String get description =>
      "Set the application title, icon, and other information based on the information in `katana.yaml`. `katana.yaml`の情報を元にアプリケーションのタイトルやアイコンなどの情報を設定します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("spread_sheet");
    final enabled = value.get("enable", false);
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
    final spreadSheet = app.getAsMap("spread_sheet");
    if (spreadSheet.isEmpty) {
      error("The item [app]->[spread_sheet] is missing. Please add an item.");
      return;
    }
    final url = spreadSheet.get("url", "");
    if (url.isEmpty) {
      error(
        "The item [app]->[spread_sheet]->[url] is missing. Please include the URL of the spreadsheet here.",
      );
      return;
    }
    final email = spreadSheet.get("email", "");
    if (email.isEmpty) {
      error(
        "The item [app]->[spread_sheet]->[email] is missing. Include here the email address of the collection account to be retrieved in the spreadsheet.",
      );
      return;
    }
    final domain = spreadSheet.get("domain", "");
    final endpoint = url.replaceAllMapped(
        RegExp(r"/edit(\?([^#]+))?(#gid=([0-9]+))?$"), (match) {
      final gid = match.group(4);
      if (gid.isEmpty) {
        return "/export?format=csv";
      }
      return "/export?format=csv&gid=$gid";
    });
    label("Load from $endpoint");
    String? defaultLocale;
    final request = await HttpClient().getUrl(Uri.parse(endpoint));
    final response = await request.close();
    final csv = await response.transform(utf8.decoder).join();
    final raw = const CsvToListConverter().convert(csv);
    final data = <String, Map<String, String>>{};
    for (int i = 1; i < raw.length; i++) {
      final line = raw[i];
      if (line.length <= 1) {
        continue;
      }
      final mapped = <String, String>{};
      for (int j = 0; j < line.length; j++) {
        if (_mapping.length <= j) {
          break;
        }
        mapped[_mapping.get(j, "")] = line.get(j, "");
      }
      final id = mapped.get("email", "");
      final locale = mapped
          .get("locale", "en")
          .replaceAllMapped(RegExp(r"^.+\(([a-z]+)\)$"), (m) {
        return m.group(1) ?? "en";
      });
      if (id.isEmpty || id != email || locale.isEmpty) {
        continue;
      }
      defaultLocale ??= locale;
      data[locale] = mapped;
      label(
        "[${mapped.get("email", "")}] ${mapped.get("short_title", "")} (${mapped.get("locale", "")})",
      );
    }
    label("Cache the information");
    final cacheDir = Directory(".dart_tool/katana");
    if (!cacheDir.existsSync()) {
      await cacheDir.create(recursive: true);
    }
    final cacheFile = File(kGoogleSpreadSheetPath);
    await cacheFile.writeAsString(jsonEncode(data));
    await AppInfo.apply(
      data: data,
      domain: domain,
      defaultLocale: defaultLocale,
    );
  }
}
