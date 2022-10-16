part of katana_router_builder;

class AnnotationValue {
  AnnotationValue(this.element, this.type) {
    final matcher = TypeChecker.fromRuntime(type);

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

  final ClassElement element;
  final Type type;

  late final List<String> redirectQueries;

  @override
  String toString() {
    return "$runtimeType(${redirectQueries.map((e) => e.toString()).join(", ")})";
  }
}
