part of '/katana_value.dart';

class _ToString {
  const _ToString(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    builder.declareInType(
      DeclarationCode.fromString("external String toString();"),
    );
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await source.methods;
    final copyWith = methods.firstWhereOrNull((m) => m.name == "toString");
    if (copyWith == null) {
      return;
    }

    final (method, fields) = await (
      builder.buildMethod(copyWith.identifier),
      source.fieldOrDefaultParameters,
    ).wait;
    return method.augment(
      FunctionBodyCode.fromParts(
        [
          "{",
          "return \"",
          source.name,
          "(\${",
          "{${fields.map((e) => "\"${e.name}\": ${e.name}").join(",")}}.entries.where((e) => e.value != null).map((e) => \"\${e.key}: \${e.value.toString()}\").join(\", \")",
          "})\";",
          "}",
        ],
      ),
    );
  }
}
