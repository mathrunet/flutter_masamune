part of '/katana_model_openapi_builder.dart';

/// Creates classes created by Freezed.
///
/// Pass the map generated from OepnAPI to [schemas].
///
/// Freezedで作成されるクラスを作成します。
///
/// [schemas]にOepnAPIから生成されたマップを渡します。
List<Spec> freezedClass(
  Map<String, APISchemaObject> schemas,
) {
  return [
    ...schemas.entries.mapAndRemoveEmpty((schema) {
      final parameters = schema.value.properties ?? {};
      final required = schema.value.required ?? [];
      return Class(
        (c) => c
          ..name = schema.key.toPascalCase()
          ..annotations.addAll([
            const Reference("freezed"),
          ])
          ..mixins.addAll([Reference("_\$${schema.key.toPascalCase()}")])
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
                ..redirect = Reference("_${schema.key.toPascalCase()}"),
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
                ..body = Code("_\$${schema.key.toPascalCase()}FromJson(json)"),
            )
          ]),
      );
    }),
  ];
}
