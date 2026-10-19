part of "/katana_localization_builder.dart";

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
    try {
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@GoogleSpreadSheetLocalize()` can only be used on classes.",
          element: element,
        );
      }

      final pathValues = <PathValue>[];
      final version = annotation.read("version").intValue;

      if (annotation.read("url").isString) {
        pathValues.add(
          PathValue(
            annotation.read("url").stringValue.trimString("/"),
            version,
          ),
        );
      } else if (annotation.read("url").isList) {
        final list = annotation.read("url").listValue;

        if (list.isEmpty) {
          throw InvalidGenerationSourceError(
            "Be sure to add at least one URL to the `url` of `@GoogleSpreadSheetLocalize()`.",
            element: element,
          );
        }

        for (final item in list) {
          final val = item.toStringValue();
          if (val.isEmpty) {
            continue;
          }
          pathValues.add(
            PathValue(
              val!.trimString("/"),
              version,
            ),
          );
        }
      }

      final classValue = ClassValue(element);
      final loader = LocalizeLoader(
        pathValues,
        LocalizeFileType.googleSpreadSheet,
      );

      await loader.load();

      final generated = Library(
        (l) => l
          ..body.addAll(
            [
              ...baseClass(classValue, pathValues, loader.locales),
              ...localizeClass(
                  classValue, pathValues, loader.localized, loader.locales),
            ],
          ),
      );
      final emitter = DartEmitter();
      final code = generated.accept(emitter).toString();
      return DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
      ).format(
        code.isEmpty ? "// no code." : code,
      );
    } catch (e, stack) {
      // ignore: avoid_print
      print("${e.toString()}: ${stack.toString()}");
    }
    return "";
  }
}
