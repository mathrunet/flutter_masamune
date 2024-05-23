part of '/katana_value.dart';

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

    final (method, fields) = await (
      builder.buildMethod(toJson.identifier),
      source.fieldOrDefaultParameters,
    ).wait;

    final activeFields =
        fields.where((e) => e.type.isValid && e.type.type != null);

    return method.augment(
      FunctionBodyCode.fromParts(
        [
          "{",
          "return {",
          ...activeFields.expand(
            (e) => [
              if(e.type.isNullable)
              "if(${e.name} != null)"
                "\"${e.name}\": ${e.type.type?.toToJsonString(e) ?? "null"},",
            ],
          ),
          "};",
          "}",
        ],
      ),
    );
  }
}
