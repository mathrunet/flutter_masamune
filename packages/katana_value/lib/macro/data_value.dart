part of '/katana_value.dart';

/// {@template data_value}
/// Macro for generating immutable data classes.
///
/// [copyWith], [hashCode], [operator ==], and [toString] are automatically generated.
///
/// In addition, [toJson] and [fromJson] are automatically generated to enable JSON conversion.
///
/// ## How to use
///
/// ### How to create from constructor
///
/// Give `@DataValue()` to the class you want to use.
/// Create a corresponding default constructor and set `required` or default values if necessary.
///
/// Named parameters as well as positional parameters are available.
///
/// ```dart
/// @DataValue()
/// class Example {
///   Example(String name, {int? age, required String text});
/// }
/// ```
///
/// ### How to create from field values
///
/// Give `@DataValue()` to the class you want to use.
/// Declare the field values you want to use with `final`.
///
/// Constructors are automatically generated and available as named parameters.
/// If created with a null-allowed type, a parameter with `required` will be created.
///
/// ```dart
/// @DataValue()
/// class Example {
///   final String name;
///   final int? age;
///   final String text;
/// }
/// ```
///
/// It can be objectified and used as is.
///
/// ```dart
/// final example = Example(name: "name", text: "text");
/// ```
///
/// ----
///
/// イミュータブルなデータクラスを生成するためのマクロです。
///
/// [copyWith]と[hashCode]、[operator ==]、[toString]が自動生成されます。
///
/// また、[toJson]と[fromJson]が自動生成され、JSON変換が可能です。
///
/// ## 利用方法
///
/// ### コンストラクターから作成する方法
///
/// `@DataValue()`を利用したいクラスに付与します。
/// 対応するデフォルトコンストラクターを作成し、必要であれば`required`やデフォルト値を設定します。
///
/// 名前付きパラメーターだけでなく、位置指定パラメーターも利用可能です。
///
/// ```dart
/// @DataValue()
/// class Example {
///   Example(String name, {int? age, required String text});
/// }
/// ```
///
/// ### フィールド値から作成する方法
///
/// `@DataValue()`を利用したいクラスに付与します。
/// 使用したいフィールド値を`final`付きで宣言します。
///
/// コンストラクターが自動生成され名前付きパラメーターとして利用可能です。
/// null許容型で作成した場合、`required`が付与されたパラメーターが作成されます。
///
/// ```dart
/// @DataValue()
/// class Example {
///   final String name;
///   final int? age;
///   final String text;
/// }
/// ```
///
/// そのままオブジェクト化して利用することが可能です。
///
/// ```dart
/// final example = Example(name: "name", text: "text");
/// ```
/// {@endtemplate}
macro class DataValue implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// {@macro data_value}
  const DataValue();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration declaration,
    MemberDeclarationBuilder builder,
  ) async {
    final source = MacroClassValue.fromDeclarationBuilder(
      declaration: declaration,
      builder: builder,
    );
    await [
      _Constructor(source).buildDeclarations(builder),
      _Fields(source).buildDeclarations(builder),
      // _ToJson(source).buildDeclarations(builder),
      _CopyWith(source).buildDeclarations(builder),
      _ToString(source).buildDeclarations(builder),
      _EqualOperator(source).buildDeclarations(builder),
    ].wait;
  }

  @override
  FutureOr<void> buildDefinitionForClass(
    ClassDeclaration declaration,
    TypeDefinitionBuilder builder,
  ) async {
    final source = MacroClassValue.fromDefinitionBuilder(
      declaration: declaration,
      builder: builder,
    );
    await [
      _Constructor(source).buildDefinition(builder),
      _Fields(source).buildDefinition(builder),
      // _ToJson(source).buildDefinition(builder),
      _CopyWith(source).buildDefinition(builder),
      _ToString(source).buildDefinition(builder),
      _EqualOperator(source).buildDefinition(builder),
    ].wait;
  }
}
