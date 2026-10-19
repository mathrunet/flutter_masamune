part of "/masamune_builder.dart";

/// Generator of controllers for classes annotated with the [Controller] annotation.
///
/// [Controller]アノテーションを付与されたクラスに対するコントローラーのジェネレーター。
class ControllerGenerator extends GeneratorForAnnotation<Controller> {
  /// Generator of controllers for classes annotated with the [Controller] annotation.
  ///
  /// [Controller]アノテーションを付与されたクラスに対するコントローラーのジェネレーター。
  ControllerGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "`@Controller()` can only be used on classes.",
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
            ...controllerClass(
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
