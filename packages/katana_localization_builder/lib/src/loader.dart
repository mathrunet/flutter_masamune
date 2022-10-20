part of katana_localization_builder;

/// Loads translation data.
///
/// 翻訳データをロードします。
class LocalizeLoader {
  /// Loads translation data.
  ///
  /// 翻訳データをロードします。
  LocalizeLoader(this.path);

  final PathValue path;

  late final List<String> locales;

  late final List<LocalizeValue> localized;

  /// Loads the file.
  ///
  /// ロードを行ないます。
  Future<void> load() async {
    final endpoint =
        path.path.replaceAllMapped(RegExp(r"/edit(#gid=([0-9]+))?$"), (match) {
      final gid = match.group(2);
      if (gid.isEmpty) {
        return "/export?format=csv";
      }
      return "/export?format=csv&gid=$gid";
    });
    print("Load from $endpoint");
    final res = await http.get(Uri.parse(endpoint));
    if (res.statusCode != 200) {
      throw InvalidGenerationSourceError(
        "${path.path} could not be accessed successfully, please check if the URL and share settings are correct.",
      );
    }
    res.body;

    final sourceValues = <String, LocalizeSourceValue>{};
    final destValues = <LocalizeValue>[];
    final _locales = <String>{};
    final num2lang = <int, String>{};
    final csv = utf8
        .decode(res.bodyBytes)
        .replaceAll("\r\n", "\n")
        .replaceAll("\r", "\n");
    final converted = const CsvToListConverter().convert(csv, eol: "\n");
    // Organize by language
    for (int y = 1; y < converted.length; y++) {
      final line = converted[y];
      if (line.isEmpty) {
        continue;
      }
      for (int x = 1; x < line.length; x++) {
        final cell = line[x];
        if (cell.isEmpty) {
          continue;
        }
        if (y == 1) {
          num2lang[x - 1] = cell;
        } else {
          final key = line.first;
          final val = line[x];
          if (val.isEmpty || key.isEmpty || key.startsWith("#")) {
            continue;
          }
          final locale = num2lang[x - 1]!;
          if (locale == _kBaseName) {
            continue;
          }
          _locales.add(locale);
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
    locales = _locales.toList();
    localized = destValues;
  }
}
