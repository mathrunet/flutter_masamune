part of '/katana_value.dart';

extension on MacroVariableValue {
  List<Object>? toConstructorInitializerDefinisionParts({String? suffix}) {
    if (!type.isValid) {
      return null;
    }
    return ["this.", name, " = ", name, suffix ?? ""];
  }

  List<Object>? toConstructorSuperParametersDefinitionParts({String? suffix}) {
    if (!type.isValid) {
      return null;
    }
    return [name, ": ", name, suffix ?? ""];
  }
}

class _Constructor {
  const _Constructor(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    final defaultConstructor = await source.defaultConstructor;

    if (defaultConstructor != null) {
      return;
    }

    final (fields, superClass) = await (source.fields, source.superClass).wait;
    final superClassDefaultConstructorParameters =
        (await superClass?.defaultParameters) ?? [];

    if (fields.isEmpty && superClassDefaultConstructorParameters.isEmpty) {
      builder.declareInType(
        DeclarationCode.fromParts([
          "external ",
          source.name,
          "();",
        ]),
      );
      return;
    }

    builder.declareInType(
      DeclarationCode.fromParts([
        "external ",
        source.name,
        "({",
        ...[...fields, ...superClassDefaultConstructorParameters]
            .mapAndRemoveEmpty(
          (e) {
            return [e.isRequired ? "required " : "", e.type.code!, " ", e.name];
          },
        ).insertEvery([","], 1).expand((e) => e),
        "});",
      ]),
    );
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) async {
    final defaultConstructor = await source.defaultConstructor;

    if (defaultConstructor == null) {
      return;
    }

    final (constructor, fieldOrDefaultParameters, superClass) = await (
      builder.buildConstructor(defaultConstructor.identifier),
      source.fieldOrDefaultParameters,
      source.superClass,
    ).wait;
    final superClassDefaultConstructorParameters =
        (await superClass?.defaultParameters) ?? [];

    if (fieldOrDefaultParameters.isEmpty &&
        superClassDefaultConstructorParameters.isEmpty) {
      return;
    }

    return constructor.augment(
      initializers: [
        RawCode.fromParts(
          [
            ...fieldOrDefaultParameters.mapAndRemoveEmpty(
              (e) {
                if (superClassDefaultConstructorParameters
                    .any((element) => element.name == e.name)) {
                  return null;
                }
                return e.toConstructorInitializerDefinisionParts();
              },
            ).insertEvery([","], 1).expand((e) => e),
            if (superClass != null) ...[
              ", ",
              "super(",
              ...fieldOrDefaultParameters.mapAndRemoveEmpty(
                (e) {
                  if (!superClassDefaultConstructorParameters
                      .any((element) => element.name == e.name)) {
                    return null;
                  }
                  return e.toConstructorSuperParametersDefinitionParts();
                },
              ).insertEvery([","], 1).expand((e) => e),
              ")",
            ],
          ],
        ),
      ],
    );
  }
}
