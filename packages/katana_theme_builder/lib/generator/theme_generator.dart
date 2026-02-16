part of "/katana_theme_builder.dart";

/// Generator that automatically creates data for themes.
///
/// テーマ用のデータを自動作成するジェネレーター。
class ThemeGenerator extends GeneratorForAnnotation<AppTheme> {
  /// Generator that automatically creates data for themes.
  ///
  /// テーマ用のデータを自動作成するジェネレーター。
  ThemeGenerator();

  static final _ignoreRegExp = RegExp("/[0-9].[0-9]x/");

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! TopLevelVariableElement) {
      throw InvalidGenerationSourceError(
        "`@AppTheme()` should only be given to top-level fields.\n"
        "```\n"
        "\n"
        "```\n",
        element: element,
      );
    }

    final assets = <String, AssetValue>{};
    final fonts = <String, FontValue>{};
    final pubspecFile = File("pubspec.yaml");
    final content = pubspecFile.readAsStringSync();
    final map = loadYaml(content) as YamlMap;
    final assetsSource = map.getAsMap("flutter").getAsList<String>("assets");
    final fontsSource = map.getAsMap("flutter").getAsList<YamlMap>("fonts");
    for (var assetInput in assetsSource) {
      if (assetInput.isEmpty) {
        continue;
      }
      if (assetInput.endsWith("/")) {
        assetInput += "*";
      }
      await for (final assetId in buildStep.findAssets(Glob(assetInput))) {
        final path = assetId.path.trimQuery().trimString("/");
        if (_ignoreRegExp.hasMatch(path) ||
            path.contains("/.") ||
            path.startsWith(".")) {
          continue;
        }
        assets[path] = AssetValue(path: path, type: _type(path));
      }
    }
    for (final fontInput in fontsSource) {
      final family = fontInput.get("family", "");
      if (family.isEmpty) {
        continue;
      }
      fonts[family] = FontValue(path: family);
    }

    final assetNodes = AssetNode.parse(
      assets
          .toTreeMap((key) => key.split(".").first.toCamelCase())
          .getAsMap("assets"),
    );
    final fontNodes = FontNode.parse(fonts);
    const config = AssetConfig();

    final generated = Library(
      (l) => l
        ..body.addAll(
          extension(assetNodes, fontNodes, config),
        ),
    );
    final emitter = DartEmitter();
    final code = generated.accept(emitter).toString();
    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(
      code.isEmpty ? "// no code." : code,
    );
  }
}
