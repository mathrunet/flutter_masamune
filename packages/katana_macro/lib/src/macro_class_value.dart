part of '/katana_macro.dart';

/// {@template macro_class_value}
/// Class for storing class values.
///
/// クラスの値を保存するためのクラス。
/// {@endtemplate}
class MacroClassValue {
  /// {@template macro_class_value}
  /// Class for storing class values.
  ///
  /// クラスの値を保存するためのクラス。
  /// {@endtemplate}
  const MacroClassValue({
    required ClassDeclaration declaration,
    required DeclarationPhaseIntrospector introspector,
    required Builder builder,
  })  : _declaration = declaration,
        _builder = builder,
        _introspector = introspector;

  /// Generate a [MacroClassValue] using [DeclarationBuilder].
  ///
  /// [DeclarationBuilder]を用いて[MacroClassValue]を生成します。
  ///
  /// {@macro macro_class_value}
  factory MacroClassValue.fromDeclarationBuilder({
    required ClassDeclaration declaration,
    required DeclarationBuilder builder,
  }) {
    return MacroClassValue(
      declaration: declaration,
      builder: builder,
      introspector: builder,
    );
  }

  /// Generate a [MacroClassValue] using [DefinitionBuilder].
  ///
  /// [DefinitionBuilder]を用いて[MacroClassValue]を生成します。
  ///
  /// {@macro macro_class_value}
  factory MacroClassValue.fromDefinitionBuilder({
    required ClassDeclaration declaration,
    required DefinitionBuilder builder,
  }) {
    return MacroClassValue(
      declaration: declaration,
      builder: builder,
      introspector: builder,
    );
  }

  final ClassDeclaration _declaration;
  final Builder _builder;
  final DeclarationPhaseIntrospector _introspector;

  /// Class name.
  ///
  /// クラス名。
  String get name => identifier.name;

  /// Class identifier.
  ///
  /// クラスの識別子。
  Identifier get identifier => _declaration.identifier;

  /// Class type.
  ///
  /// クラスの型。
  MacroTypeValue get type => MacroTypeValue(
        type: NamedTypeAnnotationCode(
          name: _declaration.identifier,
          typeArguments: _declaration.typeParameters.mapAndRemoveEmpty(
            (e) => e.bound?.code,
          ),
        ),
        introspector: _introspector,
        builder: _builder,
      );

  /// Class constructor.
  ///
  /// クラスのコンストラクター。
  Future<List<MacroConstructorValue>> get constructors async {
    final constructors = await _introspector.constructorsOf(_declaration);
    return constructors.mapAndRemoveEmpty(
      (e) => MacroConstructorValue(
        declaration: e,
        introspector: _introspector,
        builder: _builder,
      ),
    );
  }

  /// Default class constructor.
  ///
  /// デフォルトのクラスコンストラクター。
  Future<MacroConstructorValue?> get defaultConstructor async {
    final constructors = await this.constructors;
    return constructors.firstWhereOrNull((e) => e.name.isEmpty);
  }

  /// Default class constructor parameters.
  ///
  /// デフォルトのクラスコンストラクターのパラメーター。
  Future<List<MacroVariableValue>> get defaultParameters async {
    final defaultConstructor = await this.defaultConstructor;
    if (defaultConstructor == null) {
      return [];
    }
    return defaultConstructor.parameters;
  }

  /// Class fields.
  ///
  /// クラスのフィールド。
  Future<List<MacroVariableValue>> get fields async {
    final fields = await _introspector.fieldsOf(_declaration);
    return fields.mapAndRemoveEmpty(
      (e) => MacroVariableValue.fromField(
        declaration: e,
        introspector: _introspector,
        builder: _builder,
      ),
    );
  }

  /// Class fields or default parameters.
  ///
  /// If the default constructor parameters are not present, the field is returned.
  ///
  /// クラスのフィールドまたはデフォルトのパラメーター。
  ///
  /// デフォルトのコンストラクターのパラメーターが存在しない場合は、フィールドを返します。
  Future<List<MacroVariableValue>> get fieldOrDefaultParameters async {
    final defaultParameters = await this.defaultParameters;
    if (defaultParameters.isNotEmpty) {
      return defaultParameters;
    }
    return fields;
  }

  /// Class methods.
  ///
  /// クラスのメソッド。
  Future<List<MacroMethodValue>> get methods async {
    final methods = await _introspector.methodsOf(_declaration);
    return methods.mapAndRemoveEmpty(
      (e) => MacroMethodValue(
        declaration: e,
        introspector: _introspector,
        builder: _builder,
      ),
    );
  }

  /// Class super class.
  ///
  /// Returns [Null] if it does not exist.
  ///
  /// クラスのスーパークラス。
  ///
  /// 存在しない場合[Null]を返します。
  Future<MacroClassValue?> get superClass async {
    final superClass = _declaration.superclass;
    final superClassType = superClass != null
        ? await _introspector.typeDeclarationOf(superClass.identifier)
        : null;
    return superClassType is ClassDeclaration
        ? MacroClassValue(
            declaration: superClassType,
            builder: _builder,
            introspector: _introspector,
          )
        : null;
  }

  /// List of superclasses of class.
  ///
  /// Returns an empty list if it does not exist.
  ///
  /// クラスのスーパークラスの一覧。
  ///
  /// 存在しない場合空のリストを返します。
  Future<List<MacroClassValue>> get superClasses async {
    var superClass = await this.superClass;
    final superClasses = <MacroClassValue>[];
    while (superClass != null) {
      superClasses.add(superClass);
      superClass = await superClass.superClass;
    }
    return superClasses;
  }

  /// Default constructor parameters of the superclass.
  ///
  /// Returns an empty list if it does not exist.
  ///
  /// スーパークラスのデフォルトコンストラクターのパラメーター。
  ///
  /// 存在しない場合空のリストを返します。
  Future<List<MacroVariableValue>>
      get superClassDefaultConstructorParameters async {
    final superClass = await this.superClass;
    if (superClass == null) {
      return [];
    }
    return superClass.defaultParameters;
  }

  bool hasAnnotation(String annotation) {
    return _declaration.metadata.any((e) =>
        e is ConstructorMetadataAnnotation &&
        e.type.identifier.name == annotation);
  }
}
