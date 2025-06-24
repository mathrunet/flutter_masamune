part of "/katana_localization_builder.dart";

/// Automatic generation of translations from Google spreadsheets.
///
/// Googleスプレッドシートから翻訳の自動生成を行います。
class YamlLocalizeGenerator extends GeneratorForAnnotation<YamlLocalize> {
  /// Automatic generation of translations from Google spreadsheets.
  ///
  /// Googleスプレッドシートから翻訳の自動生成を行います。
  YamlLocalizeGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    try {
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@YamlLocalize()` can only be used on classes.",
          element: element,
        );
      }

      final pathValues = <PathValue>[];

      if (annotation.read("path").isString) {
        pathValues.add(
          PathValue(
            annotation.read("path").stringValue.trimString("/"),
            1,
          ),
        );
      } else if (annotation.read("url").isList) {
        final list = annotation.read("url").listValue;

        if (list.isEmpty) {
          throw InvalidGenerationSourceError(
            "Be sure to add at least one URL to the `path` of `@YamlLocalize()`.",
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
              1,
            ),
          );
        }
      }

      final classValue = ClassValue(element);
      final loader = LocalizeLoader(
        pathValues,
        LocalizeFileType.yaml,
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
