part of "/masamune_builder.dart";

/// Generator of controller groups for classes annotated with the [ControllerGroup] annotation.
///
/// [ControllerGroup]アノテーションを付与されたクラスに対するコントローラーグループのジェネレーター。
class ControllerGroupGenerator extends GeneratorForAnnotation<ControllerGroup> {
  /// Generator of controller groups for classes annotated with the [ControllerGroup] annotation.
  ///
  /// [ControllerGroup]アノテーションを付与されたクラスに対するコントローラーグループのジェネレーター。
  ControllerGroupGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        "`@ControllerGroup()` can only be used on classes.",
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
            ...controllerGroupClass(
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
