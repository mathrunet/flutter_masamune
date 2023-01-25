import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:katana_cli/katana_cli.dart';
import 'package:xml/xml.dart';

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
    final endpoint =
        url.replaceAllMapped(RegExp(r"/edit(#gid=([0-9]+))?$"), (match) {
      final gid = match.group(2);
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
      error(
        "[${mapped.get("email", "")}] ${mapped.get("short_title", "")} (${mapped.get("locale", "")})",
      );
    }
    label("Replace android information");
    await _createAndroidResValues({
      if (defaultLocale.isNotEmpty) "": data[defaultLocale!]!,
      ...data,
    });
    await _removeAndroidResValues(data);
    await _replaceAndroidManifest();
    label("Replace ios information");
    await XCode.createIOSInfoPlistStrings(data.keys.toList());
    await _createIOSInfoPlistStrings({
      if (defaultLocale.isNotEmpty) "": data[defaultLocale!]!,
      ...data,
    });
  }

  Future<void> _createAndroidResValues(
    Map<String, Map<String, String>> data,
  ) async {
    for (final tmp in data.entries) {
      final dir = Directory(
        "android/app/src/main/res/values${tmp.key.isEmpty ? "" : "-${tmp.key}"}",
      );
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final file = File("${dir.path}/strings.xml");
      if (!file.existsSync()) {
        final builder = XmlBuilder();
        builder.processing('xml', 'version="1.0" encoding="utf-8" ');
        builder.element(
          "resources",
          nest: () {
            builder.element(
              "string",
              nest: () {
                builder.attribute("name", "app_name");
                builder.text(tmp.value.get("short_title", ""));
              },
            );
          },
        );
        final document = builder.buildDocument();
        await file.writeAsString(
          document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
        );
      } else {
        final document = XmlDocument.parse(await file.readAsString());
        final resources = document.findElements("resources");
        if (resources.isEmpty) {
          document.rootElement.children.add(
            XmlElement(
              XmlName("resources"),
              [],
              [
                XmlElement(
                  XmlName("string"),
                  [XmlAttribute(XmlName("name"), "app_name")],
                  [XmlText(tmp.value.get("short_title", ""))],
                ),
              ],
            ),
          );
        } else {
          final strings = resources.first.findElements("string");
          if (strings.isEmpty) {
            resources.first.children.add(
              XmlElement(
                XmlName("string"),
                [XmlAttribute(XmlName("name"), "app_name")],
                [XmlText(tmp.value.get("short_title", ""))],
              ),
            );
          } else {
            final appName = strings.firstWhereOrNull(
              (item) => item.attributes.any(
                (p0) => p0.name.local == "name" && p0.value == "app_name",
              ),
            );
            if (appName != null) {
              appName.children
                ..clear()
                ..add(
                  XmlText(tmp.value.get("short_title", "")),
                );
            } else {
              resources.first.children.add(
                XmlElement(
                  XmlName("string"),
                  [XmlAttribute(XmlName("name"), "app_name")],
                  [XmlText(tmp.value.get("short_title", ""))],
                ),
              );
            }
          }
        }
        await file.writeAsString(
          document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
        );
      }
    }
  }

  Future<void> _removeAndroidResValues(
    Map<String, Map<String, String>> data,
  ) async {
    final dir = Directory("android/app/src/main/res");
    final regExp = RegExp(r"/values-([a-z]{2})$");
    await for (final tmp in dir.list()) {
      final match = regExp.firstMatch(tmp.path);
      if (match == null) {
        continue;
      }
      final locale = match.group(1);
      if (!data.containsKey(locale)) {
        error("Remove at `android/app/src/main/res/values-$locale`");
        await tmp.delete(recursive: true);
      }
    }
  }

  Future<void> _replaceAndroidManifest() async {
    final file = File("android/app/src/main/AndroidManifest.xml");
    if (!file.existsSync()) {
      throw Exception(
        "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
      );
    }
    final document = XmlDocument.parse(await file.readAsString());
    final application = document.findAllElements("application");
    if (application.isEmpty) {
      throw Exception(
        "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
      );
    }
    final label = application.first.getAttributeNode("android:label");
    if (label != null) {
      label.value = "@string/app_name";
    } else {
      application.first.attributes.add(
        XmlAttribute(XmlName("android:label"), "@string/app_name"),
      );
    }
    await file.writeAsString(
      document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
  }

  Future<void> _createIOSInfoPlistStrings(
    Map<String, Map<String, String>> data,
  ) async {
    for (final tmp in data.entries) {
      if (tmp.key.isEmpty) {
        continue;
      }
      final dir = Directory(
        "ios/Runner/${tmp.key}.lproj",
      );
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final text =
          'CFBundleDisplayName = "${tmp.value.get("short_title", "")}";';
      final file = File("${dir.path}/InfoPlist.strings");
      if (!file.existsSync()) {
        await file.writeAsString(text);
      } else {
        final data = await file.readAsString();
        final regExp = RegExp(r'CFBundleDisplayName[\s]*=[\s]*"([^"]+)";');
        if (regExp.hasMatch(data)) {
          await file.writeAsString(data.replaceAll(regExp, text));
        } else {
          await file.writeAsString("$data\n$text");
        }
      }
    }
    final base = data.entries.firstWhereOrNull((item) => item.key == "") ??
        data.entries.firstOrNull;
    if (base != null) {
      final dir = Directory("ios/Runner/Base.lproj");
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final text =
          'CFBundleDisplayName = "${base.value.get("short_title", "")}";';
      final file = File("${dir.path}/InfoPlist.strings");
      if (!file.existsSync()) {
        await file.writeAsString(text);
      } else {
        final data = await file.readAsString();
        final regExp = RegExp(r'CFBundleDisplayName[\s]*=[\s]*"([^"]+)";');
        if (regExp.hasMatch(data)) {
          await file.writeAsString(data.replaceAll(regExp, text));
        } else {
          await file.writeAsString("$data\n$text");
        }
      }
    }
  }
}
