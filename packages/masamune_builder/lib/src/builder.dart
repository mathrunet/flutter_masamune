part of masamune_builder;

Builder masamuneBuilderFactory(BuilderOptions options) {
  return PartBuilder([MasamuneGenerator()], ".m.dart");
}

class MasamuneGenerator extends GeneratorForAnnotation<ModelPath> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (!element.library!.isNonNullableByDefault) {
      throw InvalidGenerationSourceError(
        'Generator cannot target libraries that have not been migrated to '
        'null-safety.',
        element: element,
      );
    }

    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@module` can only be used on classes.',
        element: element,
      );
    }

    final mixin = Library(
      (b) => b
        ..body.addAll(
          [
            Method(
              (m) => m
                ..name = "_\$${element.name}FromMap"
                ..requiredParameters.addAll([
                  Parameter(
                    (b) => b
                      ..name = "map"
                      ..type = const Reference("DynamicMap"),
                  ),
                  Parameter(
                    (b) => b
                      ..name = "ref"
                      ..type = Reference(element.name),
                  )
                ])
                ..returns = refer("${element.name}?")
                ..body = Code(
                    "if(map.isEmpty || map.get(\"type\", \"\") != ref.type){ return null; } return ${element.name}(${_generateFromMapCode(element)});"),
            ),
            Method(
              (m) => m
                ..name = "_\$${element.name}ToMap"
                ..requiredParameters.addAll([
                  Parameter(
                    (b) => b
                      ..name = "ref"
                      ..type = Reference(element.name),
                  )
                ])
                ..returns =
                    refer("DynamicMap", "package:masamune/masamune.dart")
                ..body = Code(
                    "return <String, dynamic>{${_generateToMapCode(element)}};"),
            ),
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format('${mixin.accept(emitter)}');
  }

  String _generateFromMapCode(ClassElement element) {
    return [
      ...element.constructors.first.parameters
          .map(
            (e) => e.codeFromMap,
          )
          .where((e) => e.isNotEmpty),
    ].join(",");
  }

  String _generateToMapCode(ClassElement element) {
    return [
      "\"type\": ref.type",
      ...element.constructors.first.parameters
          .map(
            (e) => e.codeToMap,
          )
          .where((e) => e.isNotEmpty),
    ].join(",");
  }
}
