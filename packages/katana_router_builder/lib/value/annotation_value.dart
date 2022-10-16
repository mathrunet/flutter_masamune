part of katana_router_builder;

/// Class for storing annotation values.
/// アノテーションの値を保存するためのクラス。
///
/// Specify the class element in [element] and the annotation type in [annotationType].
/// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
class AnnotationValue {
  /// Class for storing annotation values.
  /// アノテーションの値を保存するためのクラス。
  ///
  /// Specify the class element in [element] and the annotation type in [annotationType].
  /// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
  AnnotationValue(this.element, this.annotationType) {
    final matcher = TypeChecker.fromRuntime(annotationType);

    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        final source = meta.toSource();
        final match = _regExp.firstMatch(source);
        if (match == null) {
          continue;
        }
        redirectQueries =
            match.group(1)?.split(",").map((e) => e.trim()).toList() ??
                const [];
        return;
      }
    }
    redirectQueries = const [];
  }

  static final _regExp = RegExp(r"redirect:\s*\[([^\]]*)\]");

  /// Class Element.
  /// クラスエレメント。
  final ClassElement element;

  /// Annotation Type
  /// アノテーションのタイプ
  final Type annotationType;

  /// List of `RedirectQuery`.
  /// `RedirectQuery`の一覧。
  late final List<String> redirectQueries;

  @override
  String toString() {
    return "$runtimeType(${redirectQueries.map((e) => e.toString()).join(", ")})";
  }
}
