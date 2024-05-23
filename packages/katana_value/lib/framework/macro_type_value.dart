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

  /// Type identifier.
  ///
  /// タイプの識別子。
  Identifier? get identifier => _checkNamed?.name;

  /// Returns `true` if the type has been successfully retrieved.
  ///
  /// タイプが正常に取得されている場合`true`を返します。
  bool get isValid => _checkNamed != null;

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

  /// Returns [MacroType] if the type can be treated as Json in the macro.
  ///
  /// マクロ内でJsonとして扱うことが可能な型の場合[MacroType]を返します。
  MacroType? get type {
    final macroType = MacroType.fromMacroTypeValue(this);
    if (macroType == null) {
      _builder.print("Unsupported types are used.", isError: true);
    }
    return macroType;
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

  @override
  int get hashCode {
    return toString().hashCode;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  String toString() {
    final suffix = isNullable ? "?" : "";
    final typeArguments = this.typeArguments;
    if (typeArguments.isNotEmpty) {
      return "$name<${typeArguments.map((e) => e.toString()).join(",")}>$suffix";
    }
    return "$name$suffix";
  }

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
    if (type is OmittedTypeAnnotationCode) {
      // _builder.report(
      //   Diagnostic(
      //     DiagnosticMessage(
      //       "Only fields with explicit types are allowed on data classes, please add a type.",
      //     ),
      //     Severity.info,
      //   ),
      // );
    } else {
      // _builder.report(
      //   Diagnostic(
      //     DiagnosticMessage(
      //       "Only fields with named types are allowed on data classes.",
      //     ),
      //     Severity.info,
      //   ),
      // );
    }
    return null;
  }
}
