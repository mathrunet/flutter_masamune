// Dart imports:
import "dart:io";

// Package imports:
import "package:html/dom.dart";
import "package:html/parser.dart";
import "package:xml/xml.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Application Information.
///
/// アプリケーションの情報。
class AppInfo {
  const AppInfo._();

  /// Apply the application information.
  ///
  /// アプリケーションの情報を適用します。
  static Future<void> apply({
    required Map<String, Map<String, String>> data,
    String? defaultLocale,
    String? domain,
  }) async {
    label("Replace web information");
    if (defaultLocale != null) {
      final localizedData = data[defaultLocale];
      final indexHtmlFile = File("web/index.html");
      final htmlDocument = parse(await indexHtmlFile.readAsString());
      final head = htmlDocument.head;
      final title =
          head?.children.firstWhereOrNull((item) => item.localName == "title");
      if (title == null) {
        head?.children.add(
            Element.tag("title")..innerHtml = localizedData.get("title", ""));
      } else {
        title.innerHtml = localizedData.get("title", "");
      }
      final description = head?.children.firstWhereOrNull(
        (item) =>
            item.localName == "meta" &&
            item.attributes["name"] == "description",
      );
      if (description == null) {
        head?.children.add(
          Element.tag("meta")
            ..attributes["name"] = "description"
            ..attributes["content"] = localizedData.get("overview", ""),
        );
      } else {
        description.attributes["content"] = localizedData.get("overview", "");
      }
      final ogTitle = head?.children.firstWhereOrNull(
        (item) =>
            item.localName == "meta" &&
            item.attributes["property"] == "og:title",
      );
      if (ogTitle == null) {
        head?.children.add(
          Element.tag("meta")
            ..attributes["property"] = "og:title"
            ..attributes["content"] = localizedData.get("title", ""),
        );
      } else {
        ogTitle.attributes["content"] = localizedData.get("title", "");
      }
      final ogDescription = head?.children.firstWhereOrNull(
        (item) =>
            item.localName == "meta" &&
            item.attributes["property"] == "og:description",
      );
      if (ogDescription == null) {
        head?.children.add(
          Element.tag("meta")
            ..attributes["property"] = "og:description"
            ..attributes["content"] = localizedData.get("overview", ""),
        );
      } else {
        ogDescription.attributes["content"] = localizedData.get("overview", "");
      }
      if (domain.isNotEmpty) {
        final ogImage = head?.children.firstWhereOrNull(
          (item) =>
              item.localName == "meta" &&
              item.attributes["property"] == "og:image",
        );
        if (ogImage == null) {
          head?.children.add(
            Element.tag("meta")
              ..attributes["property"] = "og:image"
              ..attributes["content"] = "https://$domain/feature.png",
          );
        } else {
          ogImage.attributes["content"] = "https://$domain/feature.png";
        }
        final ogUrl = head?.children.firstWhereOrNull(
          (item) =>
              item.localName == "meta" &&
              item.attributes["property"] == "og:url",
        );
        if (ogUrl == null) {
          head?.children.add(
            Element.tag("meta")
              ..attributes["property"] = "og:url"
              ..attributes["content"] = "https://$domain",
          );
        } else {
          ogUrl.attributes["content"] = "https://$domain";
        }
      }
      final ogSiteName = head?.children.firstWhereOrNull(
        (item) =>
            item.localName == "meta" &&
            item.attributes["property"] == "og:site_name",
      );
      if (ogSiteName == null) {
        head?.children.add(
          Element.tag("meta")
            ..attributes["property"] = "og:site_name"
            ..attributes["content"] = localizedData.get("title", ""),
        );
      } else {
        ogSiteName.attributes["content"] = localizedData.get("title", "");
      }
      final ogType = head?.children.firstWhereOrNull(
        (item) =>
            item.localName == "meta" &&
            item.attributes["property"] == "og:type",
      );
      if (ogType == null) {
        head?.children.add(
          Element.tag("meta")
            ..attributes["property"] = "og:type"
            ..attributes["content"] = "website",
        );
      } else {
        ogType.attributes["content"] = "website";
      }
      final ogLocale = head?.children.firstWhereOrNull(
        (item) =>
            item.localName == "meta" &&
            item.attributes["property"] == "og:locale",
      );
      if (ogLocale == null) {
        head?.children.add(
          Element.tag("meta")
            ..attributes["property"] = "og:locale"
            ..attributes["content"] = defaultLocale,
        );
      } else {
        ogLocale.attributes["content"] = defaultLocale;
      }
      await indexHtmlFile.writeAsString(htmlDocument.outerHtml);
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
    if (defaultLocale.isNotEmpty) {
      await _createIOSInfoPlist(data[defaultLocale!]!);
    }
    await _createIOSInfoPlistStrings({
      if (defaultLocale.isNotEmpty) "": data[defaultLocale!]!,
      ...data,
    });
    final xcode = XCode();
    await xcode.load();
    xcode.pbxProject = xcode.pbxProject?.copyWith(
      defaultLocale: defaultLocale,
      locales: data.keys.toList(),
    );
    await xcode.save();
  }

  static Future<void> _createAndroidResValues(
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
        builder.processing("xml", 'version="1.0" encoding="utf-8" ');
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

  static Future<void> _removeAndroidResValues(
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

  static Future<void> _replaceAndroidManifest() async {
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

  static Future<void> _createIOSInfoPlist(Map<String, String> data) async {
    label("Edit Info.plist.");
    final plist = File("ios/Runner/Info.plist");
    final document = XmlDocument.parse(await plist.readAsString());
    final dict = document.findAllElements("dict").firstOrNull;
    if (dict == null) {
      throw Exception(
        "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
      );
    }
    final node = dict.children.firstWhereOrNull((p0) {
      return p0 is XmlElement &&
          p0.name.toString() == "key" &&
          p0.innerText == "CFBundleDisplayName";
    });
    if (node == null) {
      dict.children.addAll(
        [
          XmlElement(
            XmlName("key"),
            [],
            [XmlText("CFBundleDisplayName")],
          ),
          XmlElement(
            XmlName("string"),
            [],
            [
              XmlText(data.get("short_title", "")),
            ],
          ),
        ],
      );
    } else {
      final next = node.nextElementSibling;
      if (next is XmlElement && next.name.toString() == "string") {
        next.children
          ..clear()
          ..add(
            XmlText(data.get("short_title", "")),
          );
      } else {
        throw Exception(
          "The `ios/Runner/Info.plist` configuration is broken.",
        );
      }
    }
    await plist.writeAsString(
      document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
    );
  }

  static Future<void> _createIOSInfoPlistStrings(
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
