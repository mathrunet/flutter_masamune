part of "/masamune_builder.dart";

/// Generator of form queries for classes annotated with [FormValue].
///
/// [FormValue]アノテーションを付与されたクラスに対するフォームクエリーのジェネレーター。
class FormValueGenerator extends GeneratorForAnnotation<FormValue> {
  /// Generator of form queries for classes annotated with [FormValue].
  ///
  /// [FormValue]アノテーションを付与されたクラスに対するフォームクエリーのジェネレーター。
  FormValueGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "`@FormValue()` can only be used on classes.",
        element: element,
      );
    }

    if (!_freezedChecker.hasAnnotationOfExact(element)) {
      throw InvalidGenerationSourceError(
        "The `@freezed` annotation is required to use `@FormValue()`.",
        element: element,
      );
    }

    final classValue = ClassValue(element);
    final autoDisposeWhenUnreferenced =
        annotation.read("autoDisposeWhenUnreferenced").boolValue;

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...formValueClass(
              classValue,
              autoDisposeWhenUnreferenced,
            ),
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
  }
}
