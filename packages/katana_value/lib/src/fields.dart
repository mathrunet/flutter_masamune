part of '/katana_value.dart';

class _Fields {
  const _Fields(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    final parameters = await source.defaultParameters;
    if (parameters.isEmpty) {
      return;
    }
    final (fields, superClass) = await (
      source.fields,
      source.superClass,
    ).wait;
    final superClassDefaultConstructorParameters =
        (await superClass?.defaultParameters) ?? [];

    for (final param in parameters) {
      if (!param.type.isValid) {
        continue;
      }
      if (fields.any((e) => e.name == param.name)) {
        continue;
      }
      if (superClassDefaultConstructorParameters
          .any((element) => element.name == param.name)) {
        continue;
      }

      builder.declareInType(
        DeclarationCode.fromParts([
          "final ",
          param.type.toString(),
          " ",
          param.name,
          ";",
        ]),
      );
    }
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) =>
      Future.value();
}
