part of katana_model_openapi_builder;

/// Creates classes created by Freezed.
///
/// Pass the map generated from OepnAPI to [definitions].
///
/// Freezedで作成されるクラスを作成します。
///
/// [definitions]にOepnAPIから生成されたマップを渡します。
List<Spec> freezedClass(
  Map<String, APISchemaObject> definitions,
) {
  return [
    ...definitions.entries.mapAndRemoveEmpty((define) {
      final parameters = define.value.properties ?? {};
      final required = define.value.required ?? [];
      return Class(
        (c) => c
          ..name = define.key.toPascalCase()
          ..annotations.addAll([
            const Reference("freezed"),
          ])
          ..mixins.addAll([Reference("_\$${define.key.toPascalCase()}")])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..optionalParameters.addAll([
                  ...parameters.toList((key, value) {
                    return Parameter(
                      (p) => p
                        ..name = key.toCamelCase()
                        ..named = true
                        ..annotations.addAll([
                          if (value?.type == APIType.array &&
                              !required.contains(key))
                            const Reference("Default([])"),
                          Reference("JsonKey(name: \"$key\")"),
                        ])
                        ..type = Reference(
                          value?.toDartType(
                            key,
                            required: required,
                          ),
                        )
                        ..required = required.contains(key),
                    );
                  }),
                ])
                ..factory = true
                ..constant = true
                ..redirect = Reference("_${define.key.toPascalCase()}"),
            ),
            Constructor(
              (c) => c
                ..name = "fromJson"
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "json"
                      ..type = const Reference("Map<String, Object?>"),
                  ),
                ])
                ..factory = true
                ..lambda = true
                ..body = Code("_\$${define.key.toPascalCase()}FromJson(json)"),
            )
          ]),
      );
    }),
  ];
}
