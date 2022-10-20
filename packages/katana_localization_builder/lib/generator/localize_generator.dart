part of katana_localization_builder;

/// Automatic generation of translations from Google spreadsheets.
///
/// Googleスプレッドシートから翻訳の自動生成を行います。
class GoogleSpreadSheetLocalizeGenerator
    extends GeneratorForAnnotation<GoogleSpreadSheetLocalize> {
  /// Automatic generation of translations from Google spreadsheets.
  ///
  /// Googleスプレッドシートから翻訳の自動生成を行います。
  GoogleSpreadSheetLocalizeGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (!element.library!.isNonNullableByDefault) {
      throw InvalidGenerationSourceError(
        "Generator cannot target libraries that have not been migrated to "
        "null-safety.",
        element: element,
      );
    }

    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "`@GoogleSpreadSheetLocalize()` can only be used on classes.",
        element: element,
      );
    }

    final _path = PathValue(annotation.read("url").stringValue.trimString("/"));
    final _class = ClassValue(element);
    final _loader = LocalizeLoader(_path);

    await _loader.load();

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...baseClass(_class, _path, _loader.locales),
            ...localizeClass(_class, _path, _loader.localized, _loader.locales),
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      "${generated.accept(emitter)}",
    );
  }
}
