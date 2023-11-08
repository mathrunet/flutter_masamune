part of '/masamune_builder.dart';

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
    return DartFormatter().format(
      code.isEmpty ? "// no code." : code,
    );
  }
}
