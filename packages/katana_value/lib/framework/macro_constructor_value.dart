part of '/katana_value.dart';

/// {@template macro_constructor_value}
/// Class for storing class constructor values.
///
/// クラスのコンストラクターの値を保存するためのクラス。
/// {@endtemplate}
class MacroConstructorValue {
  /// {@template macro_constructor_value}
  /// Class for storing class constructor values.
  ///
  /// クラスのコンストラクターの値を保存するためのクラス。
  /// {@endtemplate}
  const MacroConstructorValue({
    required ConstructorDeclaration declaration,
    required DeclarationPhaseIntrospector introspector,
    required Builder builder,
  })  : _declaration = declaration,
        _introspector = introspector,
        _builder = builder;

  final ConstructorDeclaration _declaration;
  final DeclarationPhaseIntrospector _introspector;
  final Builder _builder;

  /// Constructor name.
  ///
  /// コンストラクター名。
  String get name => identifier.name;

  /// Constructor identifier.
  ///
  /// コンストラクターの識別子。
  Identifier get identifier => _declaration.identifier;

  /// Get the parameters of the constructor.
  ///
  /// コンストラクターのパラメーターを取得します。
  List<MacroVariableValue> get parameters {
    return _declaration.parameters.mapAndRemoveEmpty((e) {
      final param = MacroVariableValue.fromParameter(
        declaration: e,
        introspector: _introspector,
        builder: _builder,
      );
      return param;
    });
  }
}
