part of '/katana_value.dart';

/// {@template macro_type_value}
/// Class for storing type values in macros.
///
/// マクロ内のタイプの値を保存するためのクラス。
/// {@endtemplate}
class MacroTypeValue {
  /// {@template macro_type_value}
  /// Class for storing type values in macros.
  ///
  /// マクロ内のタイプの値を保存するためのクラス。
  /// {@endtemplate}
  const MacroTypeValue({
    required TypeAnnotationCode type,
    required DeclarationPhaseIntrospector introspector,
    required Builder builder,
  })  : _type = type,
        _builder = builder,
        _introspector = introspector;

  final TypeAnnotationCode _type;
  final Builder _builder;
  final DeclarationPhaseIntrospector _introspector;

  /// Type name.
  ///
  /// タイプ名。
  String? get name => identifier?.name.trimStringRight("?");

  /// Type code.
  ///
  /// タイプのコード。
  TypeAnnotationCode? get code => _type;

  /// Type identifier.
  ///
  /// タイプの識別子。
  Identifier? get identifier => _checkNamed?.name;

  /// Returns `true` if the type has been successfully retrieved.
  ///
  /// タイプが正常に取得されている場合`true`を返します。
  bool get isValid => _checkNamed != null;

  /// Returns `true` if the type is a collection.
  ///
  /// タイプがコレクションの場合`true`を返します。
  bool get isIterable {
    switch (name) {
      case "Iterable":
      case "List":
      case "Set":
      case "Map":
        return true;
      default:
        return false;
    }
  }

  /// Get the type arguments of the type.
  ///
  /// タイプの型引数を取得します。
  List<MacroTypeValue> get typeArguments {
    final namedType = _checkNamed;
    if (namedType == null) {
      return [];
    }
    return namedType.typeArguments.mapAndRemoveEmpty(
      (e) => MacroTypeValue(
        type: e,
        introspector: _introspector,
        builder: _builder,
      ),
    );
  }

  /// Returns `true` if the type is nullable.
  ///
  /// タイプがnull許容型の場合`true`を返します。
  bool get isNullable => _type.isNullable;

  /// Converts to and returns a [MacroTypeValue] of null-allowed type.
  ///
  /// null許容型の[MacroTypeValue]に変換して返します。
  MacroTypeValue toNullable() {
    return MacroTypeValue(
      type: _type.asNullable,
      builder: _builder,
      introspector: _introspector,
    );
  }

  /// Converts to and returns a [MacroTypeValue] of a non-null-allowed type.
  ///
  /// null非許容型の[MacroTypeValue]に変換して返します。
  MacroTypeValue toNonNullable() {
    return MacroTypeValue(
      type: _type.asNonNullable,
      builder: _builder,
      introspector: _introspector,
    );
  }

  /// Converts from type to a string part available in `fromJson` and returns it.
  ///
  /// [variableName] specifies the name of the variable and [mapEntryCode] is passed the code of [MapEntry].
  ///
  /// タイプから`fromJson`で利用可能な文字列パートに変換して返します。
  ///
  /// [variableName]は変数名を指定し、[mapEntryCode]に[MapEntry]のコードを渡します。
  List<Object>? toFromJsonParts({
    required String variableName,
    required NamedTypeAnnotationCode mapEntryCode,
  }) {
    if (!isValid) {
      return [variableName];
    }
    switch (name) {
      case "dynamic":
        return [variableName];
      case "bool":
      case "int":
      case "num":
      case "double":
      case "String":
      case "Object":
        return [variableName, " as ", code!];
      case "Iterable":
        if (typeArguments.isEmpty) {
          if (!isNullable) {
            return [variableName, " as ", code!];
          } else {
            return [variableName, " as ", code!];
          }
        } else {
          final type = typeArguments.first;
          if (!isNullable) {
            return [
              ...["(", variableName, " as ", code!, ")"],
              ".map(",
              "(e) => ",
              ...type.toFromJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ...[".cast<", type.code!, ">()"]
            ];
          } else {
            return [
              ...[variableName, " == ", "null", " ? ", "null", " : "],
              ...["(", variableName, " as ", code!, ")"],
              "?.map(",
              "(e) => ",
              ...type.toFromJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ...[".cast<", type.code!, ">()"]
            ];
          }
        }
      case "List":
        if (typeArguments.isEmpty) {
          if (!isNullable) {
            return [variableName, " as ", code!];
          } else {
            return [variableName, " as ", code!];
          }
        } else {
          final type = typeArguments.first;
          if (!isNullable) {
            return [
              ...["(", variableName, " as ", code!, ")"],
              ".map(",
              "(e) => ",
              ...type.toFromJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ...[".cast<", type.code!, ">()"],
              ".toList()",
            ];
          } else {
            return [
              ...[variableName, " == ", "null", " ? ", "null", " : "],
              ...["(", variableName, " as ", code!, ")"],
              "?.map(",
              "(e) => ",
              ...type.toFromJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ...[".cast<", type.code!, ">()"],
              ".toList()",
            ];
          }
        }
      case "Set":
        if (typeArguments.isEmpty) {
          if (!isNullable) {
            return [variableName, " as ", code!];
          } else {
            return [variableName, " as ", code!];
          }
        } else {
          final type = typeArguments.first;
          if (!isNullable) {
            return [
              ...["(", variableName, " as ", code!, ")"],
              ".map(",
              "(e) => ",
              ...type.toFromJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ...[".cast<", type.code!, ">()"],
              ".toSet()",
            ];
          } else {
            return [
              ...[variableName, " == ", "null", " ? ", "null", " : "],
              ...["(", variableName, " as ", code!, ")"],
              "?.map(",
              "(e) => ",
              ...type.toFromJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ...[".cast<", type.code!, ">()"],
              ".toSet()",
            ];
          }
        }
      case "Map":
        if (typeArguments.length < 2) {
          if (!isNullable) {
            return [variableName, " as ", code!];
          } else {
            return [variableName, " as ", code!];
          }
        } else {
          final type1 = typeArguments.first;
          final type2 = typeArguments.last;
          if (!isNullable) {
            return [
              ...["(", variableName, " as ", code!, ")"],
              ".map(",
              "(k, v) => ",
              ...[
                mapEntryCode,
                "(",
                ...type1.toFromJsonParts(
                        variableName: "k", mapEntryCode: mapEntryCode) ??
                    [],
                ",",
                ...type2.toFromJsonParts(
                        variableName: "v", mapEntryCode: mapEntryCode) ??
                    [],
                ")",
              ],
              ")",
              ...[".cast<", type1.code!, ",", type2.code!, ">()"],
            ];
          } else {
            return [
              ...[variableName, " == ", "null", " ? ", "null", " : "],
              ...["(", variableName, " as ", code!, ")"],
              "?.map(",
              "(k, v) => ",
              ...[
                mapEntryCode,
                "(",
                ...type1.toFromJsonParts(
                        variableName: "k", mapEntryCode: mapEntryCode) ??
                    [],
                ",",
                ...type2.toFromJsonParts(
                        variableName: "v", mapEntryCode: mapEntryCode) ??
                    [],
                ")",
              ],
              ")",
              ...[".cast<", type1.code!, ",", type2.code!, ">()"],
            ];
          }
        }
    }
    return null;
  }

  /// Converts from type to a string available in `toJson` and returns it.
  ///
  /// [variableName] specifies the name of the variable and [mapEntryCode] is passed the code of [MapEntry].
  ///
  /// タイプから`toJson`で利用可能な文字列に変換して返します。
  ///
  /// [variableName]は変数名を指定し、[mapEntryCode]に[MapEntry]のコードを渡します。
  List<Object>? toToJsonParts({
    required String variableName,
    required NamedTypeAnnotationCode mapEntryCode,
  }) {
    if (!isValid) {
      return [variableName];
    }
    switch (name) {
      case "bool":
      case "int":
      case "num":
      case "double":
      case "String":
      case "Object":
      case "dynamic":
        return [variableName];
      case "Iterable":
        if (typeArguments.isEmpty) {
          return [variableName];
        } else {
          final type = typeArguments.first;
          if (!isNullable) {
            return [
              variableName,
              ".map(",
              "(e) => ",
              ...type.toToJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")"
            ];
          } else {
            return [
              variableName,
              "?.map(",
              "(e) => ",
              ...type.toToJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")"
            ];
          }
        }
      case "List":
        if (typeArguments.isEmpty) {
          return [variableName];
        } else {
          final type = typeArguments.first;
          if (!isNullable) {
            return [
              variableName,
              ".map(",
              "(e) => ",
              ...type.toToJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ".toList()"
            ];
          } else {
            return [
              variableName,
              "?.map(",
              "(e) => ",
              ...type.toToJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ".toList()"
            ];
          }
        }
      case "Set":
        if (typeArguments.isEmpty) {
          return [variableName];
        } else {
          final type = typeArguments.first;
          if (!isNullable) {
            return [
              variableName,
              ".map(",
              "(e) => ",
              ...type.toToJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ".toSet()"
            ];
          } else {
            return [
              variableName,
              "?.map(",
              "(e) => ",
              ...type.toToJsonParts(
                      variableName: "e", mapEntryCode: mapEntryCode) ??
                  [],
              ")",
              ".toSet()"
            ];
          }
        }
      case "Map":
        if (typeArguments.length < 2) {
          return [variableName];
        } else {
          final type1 = typeArguments.first;
          final type2 = typeArguments.last;
          if (!isNullable) {
            return [
              variableName,
              ".map(",
              "(k, v) => ",
              ...[
                mapEntryCode,
                "(",
                ...type1.toToJsonParts(
                        variableName: "k", mapEntryCode: mapEntryCode) ??
                    [],
                ",",
                ...type2.toToJsonParts(
                        variableName: "v", mapEntryCode: mapEntryCode) ??
                    [],
                ")"
              ],
              ")",
            ];
          } else {
            return [
              variableName,
              "?.map(",
              "(k, v) => ",
              ...[
                mapEntryCode,
                "(",
                ...type1.toToJsonParts(
                        variableName: "k", mapEntryCode: mapEntryCode) ??
                    [],
                ",",
                ...type2.toToJsonParts(
                        variableName: "v", mapEntryCode: mapEntryCode) ??
                    [],
                ")"
              ],
              ")",
            ];
          }
        }
    }
    return null;
  }

  @override
  String toString() {
    final suffix = isNullable ? "?" : "";
    final typeArguments = this.typeArguments;
    if (typeArguments.isNotEmpty) {
      return "$name<${typeArguments.map((e) => e.toString()).join(",")}>$suffix";
    }
    return "$name$suffix";
  }

  @override
  int get hashCode {
    return toString().hashCode;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  NamedTypeAnnotationCode? get _checkNamed {
    var type = _type;
    if (type is NamedTypeAnnotationCode) {
      return type;
    }
    if (type is NullableTypeAnnotationCode) {
      type = type.asNonNullable;
      if (type is NamedTypeAnnotationCode) {
        return type;
      }
    }
    return null;
  }
}
