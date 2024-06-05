part of '/katana_value.dart';

extension on MacroVariableValue {
  List<Object>? toToJsonParts({
    String variableName = "value",
    required NamedTypeAnnotationCode mapEntryCode,
    required NamedTypeAnnotationCode macroJsonConverterCode,
  }) {
    if (!type.isValid) {
      return null;
    }
    final key = this.key ?? name;
    return [
      ...["\"", key, "\""],
      ": ",
      ...type.toToJsonParts(
            variableName: variableName,
            mapEntryCode: mapEntryCode,
            macroJsonConverterCode: macroJsonConverterCode,
          ) ??
          []
    ];
  }
}

class _ToJson {
  const _ToJson(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    builder.declareInType(
      DeclarationCode.fromString("external Map<String, Object?> toJson();"),
    );
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await source.methods;
    final toJson = methods.firstWhereOrNull((m) => m.name == "toJson");
    if (toJson == null) {
      return;
    }

    final (method, mapEntry, macroJsonConverter, fields) = await (
      builder.buildMethod(toJson.identifier),
      MacroCode.mapEntry.code(builder),
      MacroCode.macroJsonConverter.code(builder),
      source.fieldOrDefaultParameters,
    ).wait;

    return method.augment(
      FunctionBodyCode.fromParts(
        [
          "{",
          "return ",
          "{",
          ...fields.mapAndRemoveEmpty((e) {
            return e.toToJsonParts(
                variableName: e.name,
                mapEntryCode: mapEntry,
                macroJsonConverterCode: macroJsonConverter);
          }).insertEvery([", "], 1).expand((e) => e),
          "};",
          "}",
        ],
      ),
    );
  }
}
