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

        final redirectMatch = _redirectRegExp.firstMatch(source);
        if (redirectMatch != null) {
          redirectQueries = redirectMatch
                  .group(1)
                  ?.split(",")
                  .map((e) => e.trim())
                  .toList() ??
              const [];
        } else {
          redirectQueries = const [];
        }

        final keyMatch = _keyRegExp.firstMatch(source);
        if (keyMatch != null) {
          final key = keyMatch
              .group(1)
              ?.replaceAll(redirectMatch?.group(0) ?? "", "")
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
    keyString = "null";
    redirectQueries = const [];
  }

  static final _keyRegExp = RegExp(r"key\s*:\s*(.+),?\s*\)\s*$");
  static final _redirectRegExp = RegExp(r"redirect\s*:\s*\[([^\]]*)\]");

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

  /// Key string.
  ///
  /// Keyの文字列。
  late final String keyString;

  @override
  String toString() {
    return "$runtimeType(${redirectQueries.map((e) => e.toString()).join(", ")})";
  }
}
