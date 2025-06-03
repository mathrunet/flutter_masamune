part of "/katana_theme_builder.dart";

/// Node data for fonts.
///
/// フォント用のノードデータ。
class FontNode {
  /// Node data for fonts.
  ///
  /// フォント用のノードデータ。
  FontNode(this.value);

  /// Font data.
  ///
  /// フォントデータ。
  final FontValue value;

  /// Parses to a list of [FontNode] by passing [values].
  ///
  /// [values]を渡して[FontNode]のリストにパースします。
  static List<FontNode> parse(Map<String, dynamic> values) {
    return values.values.map((e) => FontNode(e)).toList();
  }

  /// Create an extension method by passing [config].
  ///
  /// [config]を渡して拡張メソッドを作成します。
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

  /// Pass [config] to create a text style.
  ///
  /// [config]を渡してテキストスタイルを作成します。
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
