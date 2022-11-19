part of katana_theme_builder;

class FontNode {
  FontNode(this.value);

  final FontValue value;

  static List<FontNode> parse(Map<String, dynamic> values) {
    return values.values.map((e) => FontNode(e)).toList();
  }

  Method toExtensionSpec(AssetConfig config) {
    return Method(
      (m) => m
        ..name = value.path.toCamelCase()
        ..lambda = true
        ..returns = const Reference("String")
        ..type = MethodType.getter
        ..body = Code("\"${value.path}\""),
    );
  }

  Method toTextStyleSpec(AssetConfig config) {
    return Method(
      (m) => m
        ..name = "with${value.path.toPascalCase()}Font"
        ..lambda = true
        ..returns = const Reference("TextStyle")
        ..body = Code("copyWith(fontFamily: \"${value.path}\")"),
    );
  }
}
