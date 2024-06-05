part of '/katana_value.dart';

extension on MacroVariableValue {
  List<Object>? toFromJsonDefinitionParts({
    String variableName = "json",
    required NamedTypeAnnotationCode mapEntryCode,
    required NamedTypeAnnotationCode macroJsonConverterCode,
  }) {
    if (!type.isValid) {
      return null;
    }
    final key = this.key ?? name;
    return [
      name,
      " = ",
      ...type.toFromJsonParts(
              keyName: key,
              variableName: "$variableName[\"$key\"]",
              mapEntryCode: mapEntryCode,
              macroJsonConverterCode: macroJsonConverterCode) ??
          []
    ];
  }
}

class _FromJson {
  const _FromJson(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    builder.declareInType(
      DeclarationCode.fromParts([
        "external ",
        source.name,
        ".fromJson(Map<String, Object?> json);",
      ]),
    );
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) async {
    final constructors = await source.constructors;
    final fromJson = constructors.firstWhereOrNull((m) => m.name == "fromJson");
    if (fromJson == null) {
      return;
    }

    final (constructor, mapEntry, macroJsonConverter, fields, superClass) =
        await (
      builder.buildConstructor(fromJson.identifier),
      MacroCode.mapEntry.code(builder),
      MacroCode.macroJsonConverter.code(builder),
      source.fieldOrDefaultParameters,
      source.superClass,
    ).wait;

    final superClassMethods = await superClass?.methods;
    final fromJsonMethod =
        superClassMethods.firstWhereOrNull((m) => m.name == "fromJson");

    if (fromJsonMethod != null) {
      return constructor.augment(
        initializers: [
          RawCode.fromString("super(json)"),
        ],
      );
    }

    return constructor.augment(
      initializers: [
        RawCode.fromParts(
          [
            ...fields.mapAndRemoveEmpty((e) {
              return e.toFromJsonDefinitionParts(
                variableName: "json",
                mapEntryCode: mapEntry,
                macroJsonConverterCode: macroJsonConverter,
              );
            }).insertEvery([", "], 1).expand((e) => e),
          ],
        ),
      ],
    );
  }
}
