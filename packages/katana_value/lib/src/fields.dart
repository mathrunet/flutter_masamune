part of '/katana_value.dart';

extension on MacroVariableValue {
  List<Object>? toFieldDeclarationParts() {
    if (!type.isValid) {
      return null;
    }
    return ["final ", type.toString(), " ", name, ";"];
  }
}

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
      if (fields.any((e) => e.name == param.name)) {
        continue;
      }
      if (superClassDefaultConstructorParameters
          .any((element) => element.name == param.name)) {
        continue;
      }
      final code = param.toFieldDeclarationParts();
      if (code == null) {
        continue;
      }

      builder.declareInType(DeclarationCode.fromParts(code));
    }
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) =>
      Future.value();
}
