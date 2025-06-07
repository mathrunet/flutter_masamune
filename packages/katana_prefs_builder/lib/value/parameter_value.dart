part of "/katana_prefs_builder.dart";

final _regexp = RegExp(r"@Default\(([^\)]+)\)");
final _classRegExp = RegExp(r"[a-zA-Z0-9_$-]+\(([^\)]+)\)");
final _listRegExp = RegExp(r"(<[^>]+>)?\[([^\]]*)\]");
final _mapRegExp = RegExp(r"(<[^>]+>)?\{([^\}]*)\}");

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
    var exists = false;
    type = element.type as InterfaceType;
    required = element.isRequired;
    for (final meta in element.metadata) {
      final match = _regexp.firstMatch(meta.toSource());
      if (match == null) {
        continue;
      }
      exists = true;
      final code = match.group(1)?.trim();
      if (_classRegExp.hasMatch(code ?? "") ||
          _listRegExp.hasMatch(code ?? "") ||
          _mapRegExp.hasMatch(code ?? "")) {
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
  late final InterfaceType type;

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
