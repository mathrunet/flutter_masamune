part of '/katana_value.dart';

class _EqualOperator {
  const _EqualOperator(this.source);

  final MacroClassValue source;

  Future<void> buildDeclarations(
    MemberDeclarationBuilder builder,
  ) async {
    builder.declareInType(
      DeclarationCode.fromString("external bool operator==(Object other);"),
    );
    builder.declareInType(
      DeclarationCode.fromString("external int get hashCode;"),
    );
  }

  Future<void> buildDefinition(
    TypeDefinitionBuilder builder,
  ) {
    return [
      _buildEquals(builder),
      _buildHashCode(builder),
    ].wait;
  }

  Future<void> _buildEquals(
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await source.methods;
    final equality = methods.firstWhereOrNull(
      (m) => m.name == "==",
    );
    if (equality == null) {
      return;
    }

    final method = await builder.buildMethod(equality.identifier);
    return method.augment(
      FunctionBodyCode.fromString("=> hashCode == other.hashCode;"),
    );
  }

  Future<void> _buildHashCode(
    TypeDefinitionBuilder builder,
  ) async {
    final methods = await source.methods;
    final hashCode = methods.firstWhereOrNull(
      (m) => m.identifier.name == "hashCode",
    );
    if (hashCode == null) {
      return;
    }


    final (method, object, fields) = await (
      builder.buildMethod(hashCode.identifier),
      MacroCode.object.getCode(builder),
      source.fieldOrDefaultParameters,
    ).wait;

    var superclass = await source.superClass;
    while (superclass != null) {
      fields.addAll(await superclass.fields);
      superclass = await superclass.superClass;
    }

    if(fields.isEmpty){
      return method.augment(
        FunctionBodyCode.fromParts(
          [
            "{",
            "return ",
            object,
            ".hashAll([runtimeType]);",
            "}",
          ],
        ),
      );
    }

    return method.augment(
      FunctionBodyCode.fromParts(
        [
          "{",
          "return ",
          object,
          ".hashAll([",
          fields.map((e) => e.name).join(", "),
          "]);",
          "}",
        ],
      ),
    );
  }
}
