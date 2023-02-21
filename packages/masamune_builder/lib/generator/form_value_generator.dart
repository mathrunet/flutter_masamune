part of masamune_builder;

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
    return DartFormatter().format(
      code.isEmpty ? "// no code." : code,
    );
  }
}
