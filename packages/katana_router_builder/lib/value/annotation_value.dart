part of katana_router_builder;

/// Class for storing annotation values.
///
/// Specify the class element in [element] and the annotation type in [annotationType].
///
/// アノテーションの値を保存するためのクラス。
///
/// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
class AnnotationValue {
  /// Class for storing annotation values.
  ///
  /// Specify the class element in [element] and the annotation type in [annotationType].
  ///
  /// アノテーションの値を保存するためのクラス。
  ///
  /// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
  AnnotationValue(this.element, this.annotationType) {
    final matcher = TypeChecker.fromRuntime(annotationType);

    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        final source = meta.toSource();
        name = obj.getField("name")?.toStringValue();

        final redirectMatch = _redirectRegExp.firstMatch(source);
        if (redirectMatch != null) {
          redirectQueries = redirectMatch
                  .group(1)
                  ?.split(",")
                  .map((e) => e.trim().trimString("'").trimString('"'))
                  .toList() ??
              const [];
        } else {
          redirectQueries = const [];
        }

        final transitionMatch = _transitionRegExp.firstMatch(source);
        if (transitionMatch != null) {
          transition =
              transitionMatch.group(1)?.trim().trimString("'").trimString('"');
        } else {
          transition = null;
        }

        final implementTypeMatch = _implementTypeRegExp.firstMatch(source);
        if (implementTypeMatch != null) {
          implementType = implementTypeMatch
              .group(1)
              ?.trim()
              .trimString("'")
              .trimString('"');
        } else {
          implementType = null;
        }

        final keyMatch = _keyRegExp.firstMatch(source);
        if (keyMatch != null) {
          final nameMatch = _nameWithSingleQuoteRegExp.firstMatch(source) ??
              _nameWithDoubleQuoteRegExp.firstMatch(source) ??
              _nameWithVariableRegExp.firstMatch(source);
          final key = keyMatch
              .group(1)
              ?.replaceAll(redirectMatch?.group(0) ?? "", "")
              .replaceAll(nameMatch?.group(0) ?? "", "")
              .replaceAll(transitionMatch?.group(0) ?? "", "")
              .replaceAll(implementTypeMatch?.group(0) ?? "", "")
              .trim()
              .trimString(",")
              .trim();
          if (key.isNotEmpty) {
            keyString = key!;
          } else {
            keyString = "null";
          }
        } else {
          keyString = "null";
        }
        return;
      }
    }
    name = null;
    keyString = "null";
    transition = null;
    redirectQueries = const [];
  }

  static final _keyRegExp = RegExp(r"key\s*:\s*(.+),?\s*\)\s*$");
  static final _nameWithSingleQuoteRegExp = RegExp(r"name\s*:\s*('[^']+'),?");
  static final _nameWithDoubleQuoteRegExp = RegExp(r'name\s*:\s*("[^"]+"),?');
  static final _nameWithVariableRegExp =
      RegExp(r'name\s*:\s*([a-zA-Z0-9$._-]+),?');
  static final _transitionRegExp =
      RegExp("transition\\s*:\\s*([a-zA-Z0-9\$._'\"-]+),?");
  static final _implementTypeRegExp =
      RegExp("implementType\\s*:\\s*([a-zA-Z0-9\$._'\"-]+),?");
  static final _redirectRegExp = RegExp(r"redirect\s*:\s*\[([^\]]*)\],?");

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement element;

  /// Annotation Type
  ///
  /// アノテーションのタイプ
  final Type annotationType;

  /// List of `RedirectQuery`.
  ///
  /// `RedirectQuery`の一覧。
  late final List<String> redirectQueries;

  /// Transition settings.
  ///
  /// トランジションの設定。
  late final String? transition;

  /// Page Name.
  ///
  /// ページの名前。
  late final String? name;

  /// Key string.
  ///
  /// Keyの文字列。
  late final String keyString;

  /// Implement type.
  ///
  /// 実装タイプ。
  late final String? implementType;

  @override
  String toString() {
    return "$runtimeType(${redirectQueries.map((e) => e.toString()).join(", ")})";
  }
}
