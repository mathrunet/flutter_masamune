part of masamune_builder;

class ControllerGenerator extends GeneratorForAnnotation<Controller> {
  ControllerGenerator();

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
        "`@Controller()` can only be used on classes.",
        element: element,
      );
    }

    final _class = ClassValue(element);

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...controllerClass(_class),
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
