part of '/katana_prefs_builder.dart';

/// Generator that automatically creates classes to read and write SharedPreferences.
///
/// SharedPreferencesを読み書きするクラスを自動作成するジェネレーター。
class PrefsGenerator extends GeneratorForAnnotation<Prefs> {
  /// Generator that automatically creates classes to read and write SharedPreferences.
  ///
  /// SharedPreferencesを読み書きするクラスを自動作成するジェネレーター。
  PrefsGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "`@Prefs()` can only be used on classes.",
        element: element,
      );
    }

    final classValue = ClassValue(element);

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...baseClass(classValue),
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
