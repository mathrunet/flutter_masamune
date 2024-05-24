part of '/katana_value.dart';

extension on MacroVariableValue {
  List<Object>? toParametersDeclarationParts({bool forceNullable = false}) {
    if (!type.isValid) {
      return null;
    }
    if (forceNullable) {
      return [type.toNullable().toString(), name];
    }
    return [type.toString(), name];
  }

  List<Object>? toCopyWithParametersDefinitionParts(
      {bool namedParameter = true, String? suffix}) {
    if (!type.isValid) {
      return null;
    }
    if (namedParameter) {
      return [name, ": ", name, " ?? ", "this.", name, suffix ?? ""];
    }
    return [name, " ?? ", "this.", name, suffix ?? ""];
  }
}

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
          " copyWith",
          "({",
          ...fields.mapAndRemoveEmpty(
            (e) {
              return e.toParametersDeclarationParts(forceNullable: true);
            },
          ).insertEvery([","], 1).expand((e) => e),
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
            return e.toCopyWithParametersDefinitionParts(
              namedParameter: false,
              suffix: ",",
            );
          }).expand((e) => e),
          ...namedFields.mapAndRemoveEmpty((e) {
            return e.toCopyWithParametersDefinitionParts(
              namedParameter: true,
              suffix: ",",
            );
          }).expand((e) => e),
          ");",
          "}",
        ],
      ),
    );
  }
}
