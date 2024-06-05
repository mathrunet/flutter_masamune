part of '/katana_value.dart';

extension on MacroVariableValue {
  List<Object>? toHashCodeDefinitionParts(
      {required NamedTypeAnnotationCode deepHashCode}) {
    if (!type.isValid) {
      return null;
    }
    if (type.isIterable) {
      return [deepHashCode, "(", name, ")"];
    }
    return [name];
  }

  List<Object>? toEqualsDefinitionParts(
      {String otherVariableName = "other",
      required NamedTypeAnnotationCode identicalCode,
      required NamedTypeAnnotationCode deepEqualsCode}) {
    if (!type.isValid) {
      return null;
    }
    if (type.isIterable) {
      return [
        deepEqualsCode,
        "(",
        ...[otherVariableName, ".", name, ", ", name],
        ")"
      ];
    }
    return [
      "(",
      ...[identicalCode, "(", otherVariableName, ".", name, ", ", name, ")"],
      " || ",
      ...[otherVariableName, ".", name, " == ", name],
      ")"
    ];
  }
}

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

    final (method, identical, deepEquals, fields) = await (
      builder.buildMethod(equality.identifier),
      MacroCode.identical.code(builder),
      MacroCode.deepEquals.code(builder),
      source.fieldOrDefaultParameters,
    ).wait;
    return method.augment(
      FunctionBodyCode.fromParts([
        "{",
        ...["if (", identical, "(this, other)) ", "return true;"],
        ...[
          "if (",
          ...["other.runtimeType", " != ", "runtimeType"],
          " || ",
          ...["other is! ", source.name],
          ") ",
          "return false;"
        ],
        "return ",
        ...fields
            .mapAndRemoveEmpty((e) => e.toEqualsDefinitionParts(
                identicalCode: identical, deepEqualsCode: deepEquals))
            .insertEvery([" && "], 1).expand((e) => e),
        ";",
        "}",
      ]),
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

    final (method, object, deepHash, fields) = await (
      builder.buildMethod(hashCode.identifier),
      MacroCode.object.code(builder),
      MacroCode.deepHash.code(builder),
      source.fieldOrDefaultParameters,
    ).wait;

    var superclass = await source.superClass;
    while (superclass != null) {
      fields.addAll(await superclass.fields);
      superclass = await superclass.superClass;
    }

    if (fields.isEmpty) {
      return method.augment(
        FunctionBodyCode.fromParts(
          [
            "{",
            "return ",
            object,
            ".hashAll([",
            "runtimeType",
            "]);",
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
          "runtimeType,",
          ...fields
              .mapAndRemoveEmpty(
                  (e) => e.toHashCodeDefinitionParts(deepHashCode: deepHash))
              .insertEvery([", "], 1).expand((e) => e),
          "]);",
          "}",
        ],
      ),
    );
  }
}
