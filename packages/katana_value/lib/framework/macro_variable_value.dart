part of '/katana_value.dart';

/// {@template macro_variable_value}
/// Class that holds variable information for fields and constructors.
///
/// フィールドやコンストラクターの変数情報を保持するクラス。
/// {@endtemplate}
class MacroVariableValue {
  /// {@template macro_variable_value}
  /// Class that holds variable information for fields and constructors.
  ///
  /// フィールドやコンストラクターの変数情報を保持するクラス。
  /// {@endtemplate}
  const MacroVariableValue({
    required this.identifier,
    required this.type,
    this.key,
    this.isRequired = true,
    this.isNamed = true,
    this.defaultValue,
  });

  /// Create a [MacroVariableValue] from [FormalParameterDeclaration].
  ///
  /// [FormalParameterDeclaration]から[MacroVariableValue]を作成します。
  ///
  /// {@macro macro_parameter_value}
  factory MacroVariableValue.fromParameter({
    required FormalParameterDeclaration declaration,
    required DeclarationPhaseIntrospector introspector,
    required Builder builder,
  }) {
    final type = MacroTypeValue(
      type: declaration.type.code,
      introspector: introspector,
      builder: builder,
    );
    final defaultValue = declaration.code.defaultValue?.toString().trim();

    return MacroVariableValue(
      identifier: declaration.identifier,
      defaultValue: defaultValue,
      isRequired: declaration.isRequired,
      isNamed: declaration.isNamed,
      type: type,
    );
  }

  /// Create a [MacroVariableValue] from [FieldDeclaration].
  ///
  /// [FieldDeclaration]から[MacroVariableValue]を作成します。
  ///
  /// {@macro macro_parameter_value}
  factory MacroVariableValue.fromField({
    required FieldDeclaration declaration,
    required DeclarationPhaseIntrospector introspector,
    required Builder builder,
  }) {
    final type = MacroTypeValue(
      type: declaration.type.code,
      introspector: introspector,
      builder: builder,
    );

    return MacroVariableValue(
      identifier: declaration.identifier,
      isRequired: !type.isNullable,
      isNamed: true,
      type: type,
    );
  }

  /// Variable Name.
  ///
  /// 変数名。
  String get name => identifier.name;

  /// Variable identifier.
  ///
  /// 変数の識別子。
  final Identifier identifier;

  /// Variable type.
  ///
  /// 変数の型。
  final MacroTypeValue type;

  /// Key for Json.
  ///
  /// Json用のキー。
  final String? key;

  /// `True` if the variable is required.
  ///
  /// 変数が必須の場合は`true`。
  final bool isRequired;

  /// `True` if the variable is named.
  ///
  /// 変数が名前付きの場合は`true`。
  final bool isNamed;

  /// Default value of the variable.
  ///
  /// 変数のデフォルト値。
  final String? defaultValue;

  @override
  int get hashCode {
    return toString().hashCode;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  String toString() {
    return "$name#$type";
  }

  // /// Converts to string for constructor parameters.
  // ///
  // /// コンストラクターのパラメーター用の文字列に変換します。
  // String toConstructorParameter() {
  //   final builder = CodeBuilder();
  //   if (isNamed && isRequired) {
  //     builder.append("required ");
  //   }
  //   builder.append("$type $name");
  //   if (defaultValue != null) {
  //     builder.append(" = ");
  //     builder.append(defaultValue);
  //   }
  //   return builder.build();
  // }

  // /// Converts to a string for a class field.
  // ///
  // /// クラスのフィールド用の文字列に変換します。
  // String toClassField() {
  //   final builder = CodeBuilder();
  //   builder.append("final $type $name;");
  //   return builder.build();
  // }
}

// /// Extension method for a list of [MacroParameterValue].
// ///
// /// [MacroParameterValue]のリスト用の拡張メソッド。
// extension MacroParameterValueListExtension on List<MacroParameterValue> {
//   /// Outputs the class constructor string from the list in [MacroParameterValue].
//   ///
//   /// Pass the class name in [className] and the constructor name in [constructorName].
//   ///
//   /// [MacroParameterValue]のリストからクラスのコンストラクターの文字列を出力します。
//   ///
//   /// [className]にクラス名、[constructorName]にコンストラクター名を渡してください。
//   String toConstructor({
//     required String className,
//     String? constructorName,
//   }) {
//     final optionalParams = where((e) => e.isNamed).toList();
//     final positionalParams = where((e) => !e.isNamed).toList();

//     final code = CodeBuilder();
//     code.append("augment const $className");
//     if (constructorName != null) {
//       code.append(".$constructorName");
//     }
//     code.append("(");
//     if (positionalParams.isNotEmpty) {
//       code.appendAll(
//           positionalParams.map((e) => "${e.toConstructorParameter()},"));
//     }
//     if (optionalParams.isNotEmpty) {
//       code.append("{");
//       code.appendAll(
//           optionalParams.map((e) => "${e.toConstructorParameter()},"));
//       code.append("}");
//     }
//     code.append(")");
//     if (isNotEmpty) {
//       code.append(" : ");
//       for (final param in this) {
//         code.append("${param.name} = ${param.name}");
//         code.append(",");
//       }
//       code.removeLast();
//     }
//     code.append(";");
//     return code.build();
//   }

//   /// Outputs the class field from the list in [MacroParameterValue].
//   ///
//   /// [MacroParameterValue]のリストからクラスのフィールドを出力します。
//   List<String> toClassFields() {
//     final code = <String>[];
//     for (final param in this) {
//       if (param.isNamed) {
//         continue;
//       }
//       code.add(param.toConstructorParameter());
//     }
//     return code;
//   }
// }
