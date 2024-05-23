// ignore_for_file: unused_field

part of '/katana_value.dart';

/// {@template macro_method_value}
/// Class for storing methods and functions.
///
/// メソッドや関数を保存するためのクラス。
/// {@endtemplate}
class MacroMethodValue {
  /// {@template macro_method_value}
  /// Class for storing methods and functions.
  ///
  /// メソッドや関数を保存するためのクラス。
  /// {@endtemplate}
  const MacroMethodValue({
    required MethodDeclaration declaration,
    required DeclarationPhaseIntrospector introspector,
    required Builder builder,
  })  : _declaration = declaration,
        _introspector = introspector,
        _builder = builder;

  final MethodDeclaration _declaration;
  final Builder _builder;
  final DeclarationPhaseIntrospector _introspector;

  /// Method name.
  /// 
  /// メソッド名。
  String get name => identifier.name;

  /// Method identifier.
  /// 
  /// メソッドの識別子。
  Identifier get identifier => _declaration.identifier;
}
