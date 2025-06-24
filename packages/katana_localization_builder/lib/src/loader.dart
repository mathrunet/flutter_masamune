part of "/katana_localization_builder.dart";

/// The type of file to load.
///
/// ロードするファイルの種類。
enum LocalizeFileType {
  /// Google Spreadsheet.
  ///
  /// Googleスプレッドシート。
  googleSpreadSheet,

  /// Yaml.
  ///
  /// Yaml。
  yaml,
}

/// Loads translation data.
///
/// 翻訳データをロードします。
class LocalizeLoader {
  /// Loads translation data.
  ///
  /// 翻訳データをロードします。
  LocalizeLoader(this.paths, this.type);

  /// The type of file to load.
  ///
  /// ロードするファイルの種類。
  final LocalizeFileType type;

  /// The list of paths to load translation data.
  ///
  /// 翻訳データをロードするパスのリスト。
  final List<PathValue> paths;

  /// The list of locales.
  ///
  /// ロケールのリスト。
  late final List<String> locales;

  /// The list of localized values.
  ///
  /// ローカライズされた値のリスト。
  late final List<LocalizeValue> localized;

  /// Loads the file.
  ///
  /// ロードを行ないます。
  Future<void> load() async {
    switch (type) {
      case LocalizeFileType.googleSpreadSheet:
        final dir = Directory(".dart_tool/katana");
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
        }
        final Map<String, Uint8List> bytes = {};
        for (final path in paths) {
          final id = path.path.toSHA1();
          final file = File("${dir.path}/l.$id.${path.version}.csv");
          if (file.existsSync()) {
            bytes[id] = await file.readAsBytes();
          } else {
            final endpoint = path.path.replaceAllMapped(
                RegExp(r"/edit(\?([^#]+))?(#gid=([0-9]+))?$"), (match) {
              final gid = match.group(4);
              if (gid.isEmpty) {
                return "/export?format=csv";
              }
              return "/export?format=csv&gid=$gid";
            });
            // ignore: avoid_print
            print("Load from $endpoint");
            final res = await http.get(Uri.parse(endpoint));
            if (res.statusCode != 200) {
              throw InvalidGenerationSourceError(
                "${path.path} could not be accessed successfully, please check if the URL and share settings are correct.",
              );
            }
            final list = dir.listSync();
            for (final file in list) {
              if (!file.path.contains("${dir.path}/localization.")) {
                continue;
              }
              await file.delete();
            }
            final byte = bytes[id] = res.bodyBytes;
            await File("${dir.path}/localization.${path.version}.csv")
                .writeAsBytes(byte);
          }
        }

        final sourceValues = <String, LocalizeSourceValue>{};
        final destValues = <LocalizeValue>[];
        final localeSet = <String>{};
        final num2lang = <int, String>{};
        for (final tmp in bytes.entries) {
          final csv = utf8
              .decode(tmp.value)
              .replaceAll("\r\n", "\n")
              .replaceAll("\r", "\n");
          final converted = const CsvToListConverter().convert(csv, eol: "\n");
          // Organize by language
          for (var y = 1; y < converted.length; y++) {
            final line = converted[y];
            if (line.isEmpty) {
              continue;
            }
            for (var x = 1; x < line.length; x++) {
              final cell = line[x]?.toString();
              if (cell.isEmpty) {
                continue;
              }
              if (y == 1) {
                if (cell?.startsWith("#") ?? false) {
                  continue;
                }
                num2lang[x - 1] = cell!;
              } else {
                final key = line.first;
                final val = line[x]?.toString();
                if (val.isEmpty ||
                    key.isEmpty ||
                    key.startsWith("#") ||
                    !num2lang.containsKey(x - 1)) {
                  continue;
                }
                final locale = num2lang[x - 1]!;
                if (locale == _kBaseName) {
                  continue;
                }
                localeSet.add(locale);
                if (sourceValues.containsKey(key)) {
                  sourceValues[key]?.addLocalize({locale: val!});
                } else {
                  sourceValues[key] = LocalizeSourceValue(key: key)
                    ..addLocalize({locale: val!});
                }
              }
            }
          }
        }
        // Put the translation data at the end of the node
        for (final tmp in sourceValues.values) {
          tmp.build();
        }
        // Classified as wood structure
        for (final tmp in sourceValues.entries) {
          final words = tmp.value.words;
          LocalizeValue.add(destValues, words, 0);
        }
        locales = localeSet.toList();
        localized = destValues;
        break;
      case LocalizeFileType.yaml:
        final dir = Directory.current;
        final Map<String, Uint8List> bytes = {};
        for (final path in paths) {
          final id = path.path.toSHA1();
          final file = File("${dir.path}/$path");
          if (!file.existsSync()) {
            continue;
          }
          bytes[id] = await file.readAsBytes();
        }

        final sourceValues = <String, LocalizeSourceValue>{};
        final destValues = <LocalizeValue>[];
        final localeSet = <String>{};
        for (final tmp in bytes.entries) {
          final yamlTxt = utf8.decode(tmp.value);
          final yaml = loadYaml(yamlTxt);
          if (yaml is! Map) {
            continue;
          }
          final localizes = yaml.getAsList<Map>("localize");
          for (final localize in localizes) {
            final key = localize.get(_kYamlKey, "");
            if (key.isEmpty) {
              continue;
            }
            for (final entry in localize.entries) {
              final locale = entry.key.toString();
              final val = entry.value.toString();
              if (locale == _kYamlKey || val.isEmpty) {
                continue;
              }
              localeSet.add(locale);
              if (sourceValues.containsKey(key)) {
                sourceValues[key]?.addLocalize({locale: val});
              } else {
                sourceValues[key] = LocalizeSourceValue(key: key)
                  ..addLocalize({locale: val});
              }
            }
          }
        }
        // Put the translation data at the end of the node
        for (final tmp in sourceValues.values) {
          tmp.build();
        }
        // Classified as wood structure
        for (final tmp in sourceValues.entries) {
          final words = tmp.value.words;
          LocalizeValue.add(destValues, words, 0);
        }
        locales = localeSet.toList();
        localized = destValues;
        break;
    }
  }
}
