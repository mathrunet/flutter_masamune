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
  String toString() {
    return "$name#$type";
  }

  @override
  int get hashCode {
    return toString().hashCode;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
