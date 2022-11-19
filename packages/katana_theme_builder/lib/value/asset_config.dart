part of katana_theme_builder;

class AssetConfig {
  const AssetConfig({required this.useSvg});

  final bool useSvg;

  bool checkEnabled(AssetValueType type) {
    switch (type) {
      case AssetValueType.svg:
        return useSvg;
      case AssetValueType.font:
        return false;
      default:
        return true;
    }
  }
}
