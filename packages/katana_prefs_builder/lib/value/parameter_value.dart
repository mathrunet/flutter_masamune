part of katana_prefs_builder;

final _regexp = RegExp(r"@Default\(([^\)]+)\)");
final _classRegExp = RegExp(r"[a-zA-Z0-9_$-]+\(([^\)]+)\)");

/// Parameter Value.
///
/// Specify the parameter element in [element].
///
/// パラメーターの値。
///
/// [element]にパラメーターエレメントを指定します。
class ParamaterValue {
  /// Parameter Value.
  ///
  /// Specify the parameter element in [element].
  ///
  /// パラメーターの値。
  ///
  /// [element]にパラメーターエレメントを指定します。
  ParamaterValue(this.element) {
    name = element.displayName;
    if (_ignoreWords.contains(name)) {
      throw Exception(
        "`$name` is a prohibited word. This word cannot be set as a parameter. Please specify another name.",
      );
    }
    bool exists = false;
    type = element.type;
    required = element.isRequired;
    for (final meta in element.metadata) {
      final match = _regexp.firstMatch(meta.toSource());
      if (match == null) {
        continue;
      }
      exists = true;
      final code = match.group(1);
      if (_classRegExp.hasMatch(code ?? "")) {
        defaultValueCode = "const $code";
      } else {
        defaultValueCode = code;
      }
      break;
    }
    if (!exists) {
      defaultValueCode = null;
    }
  }

  /// Parameter Element.
  ///
  /// パラメーターエレメント。
  final ParameterElement element;

  /// Parameter Type.
  ///
  /// パラメーターのタイプ。
  late final DartType type;

  /// Name of parameter.
  ///
  /// パラメーターの名前。
  late final String name;

  /// True if Required.
  ///
  /// Requiredな場合true.
  late final bool required;

  /// Default value code.
  ///
  /// デフォルト値のコード。
  late final String? defaultValueCode;

  @override
  String toString() {
    return "$name($type)";
  }
}
