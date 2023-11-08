part of '/katana_theme_builder.dart';

/// Create an extension method.
///
/// Pass [assets] a node for assets, [fonts] a node for fonts, and [config] an asset config.
///
/// 拡張メソッドを作成します。
///
/// [assets]にアセット用のノード、[fonts]にフォント用のノード、[config]にアセットコンフィグを渡します。
List<Spec> extension(
  List<AssetNode> assets,
  List<FontNode> fonts,
  AssetConfig config,
) {
  return [
    if (assets.isNotEmpty) ...[
      Extension(
        (e) => e
          ..name = r"$ThemeAssetsExtensions"
          ..on = const Reference("AssetThemeData")
          ..methods.addAll([
            ...assets.map((node) {
              return node.toExtensionSpec(config);
            })
          ]),
      ),
      Extension(
        (e) => e
          ..name = r"$FontAssetsExtensions"
          ..on = const Reference("FontThemeData")
          ..methods.addAll([
            ...fonts.map((node) {
              return node.toExtensionSpec(config);
            })
          ]),
      ),
      Extension(
        (e) => e
          ..name = r"$FontTextStyleExtensions"
          ..on = const Reference("TextStyle")
          ..methods.addAll([
            ...fonts.map((node) {
              return node.toTextStyleSpec(config);
            })
          ]),
      ),
      ...assets.expand((node) {
        return node.toClassSpec(config);
      })
    ],
  ];
}
