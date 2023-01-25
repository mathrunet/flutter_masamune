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

    final pathValue = PathValue(
      annotation.read("url").stringValue.trimString("/"),
      annotation.read("version").intValue,
    );
    final classValue = ClassValue(element);
    final loader = LocalizeLoader(pathValue);

    await loader.load();

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...baseClass(classValue, pathValue, loader.locales),
            ...localizeClass(
                classValue, pathValue, loader.localized, loader.locales),
          ],
        ),
    );
    final emitter = DartEmitter();
    final code = generated.accept(emitter).toString();
    return DartFormatter().format(
      code.isEmpty ? "// no code." : code,
    );
  }
}
