part of '/katana_value.dart';

class _CopyWith {
  const _CopyWith(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    final fields = await source.fieldOrDefaultParameters;
    if (fields.isEmpty) {
      builder.declareInType(
        DeclarationCode.fromParts([
          "external ",
          source.name,
          " copyWith();",
        ]),
      );
    } else {
      builder.declareInType(
        DeclarationCode.fromParts([
          "external ",
          source.name,
          " copyWith({",
          fields.mapAndRemoveEmpty(
            (e) {
              if (!e.type.isValid) {
                return null;
              }
              final nullable = e.type.toNullable();
              return "$nullable ${e.name}";
            },
          ).join(","),
          "});",
        ]),
      );
    }
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await source.methods;
    final copyWith = methods.firstWhereOrNull((m) => m.name == "copyWith");
    if (copyWith == null) {
      return;
    }

    final (method, fields) = await (
      builder.buildMethod(copyWith.identifier),
      source.fieldOrDefaultParameters,
    ).wait;

    final positionalFields = fields.where((e) => !e.isNamed);
    final namedFields = fields.where((e) => e.isNamed);
    return method.augment(
      FunctionBodyCode.fromParts(
        [
          "{",
          "return ",
          source.name,
          "(",
          ...positionalFields.mapAndRemoveEmpty((e) {
            if (!e.type.isValid) {
              return null;
            }
            return "${e.name} ?? this.${e.name},";
          }),
          ...namedFields.mapAndRemoveEmpty((e) {
            if (!e.type.isValid) {
              return null;
            }
            return "${e.name}: ${e.name} ?? this.${e.name},";
          }),
          ");",
          "}",
        ],
      ),
    );
  }
}
