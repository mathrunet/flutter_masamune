part of '/katana_value.dart';

class _FromJson {
  const _FromJson(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    builder.declareInType(
      DeclarationCode.fromParts([
        "external factory ",
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

    final (method, fields) = await (
      builder.buildConstructor(fromJson.identifier),
      source.fieldOrDefaultParameters,
    ).wait;

    // return method.augment(
    //   FunctionBodyCode.fromParts(
    //     [
    //       "{",
    //       "return \"",
    //       source.name,
    //       "(\${",
    //       "{${fields.map((e) => "\"${e.name}\": ${e.name}").join(",")}}.entries.where((e) => e.value != null).map((e) => \"\${e.key}: \${e.value.toString()}\").join(\", \")",
    //       "})\";",
    //       "}",
    //     ],
    //   ),
    // );
  }
}
