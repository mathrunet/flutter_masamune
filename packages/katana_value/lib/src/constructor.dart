part of '/katana_value.dart';

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
        [...fields, ...superClassDefaultConstructorParameters].map(
          (e) {
            final requiredText = e.isRequired ? "required " : "";
            return "$requiredText${e.type} ${e.name}";
          },
        ).join(","),
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
            fieldOrDefaultParameters.mapAndRemoveEmpty(
              (e) {
                if (!e.type.isValid) {
                  return null;
                }
                if (superClassDefaultConstructorParameters
                    .any((element) => element.name == e.name)) {
                  return null;
                }
                return "this.${e.name} = ${e.name}";
              },
            ).join(","),
            if (superClass != null) ...[
              ", super(",
              fieldOrDefaultParameters.mapAndRemoveEmpty(
                (e) {
                  if (!e.type.isValid) {
                    return null;
                  }
                  if (!superClassDefaultConstructorParameters
                      .any((element) => element.name == e.name)) {
                    return null;
                  }
                  return "${e.name}: ${e.name}";
                },
              ).join(","),
              ")",
            ],
          ],
        ),
      ],
    );
  }
}
