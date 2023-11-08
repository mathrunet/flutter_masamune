part of '/katana_theme_builder.dart';

/// Config data for the asset.
///
/// [useSvg] to set whether to use SVG data.
///
/// アセット用のコンフィグデータ。
///
/// [useSvg]でSVGデータを利用するかを設定します。
class AssetConfig {
  /// Config data for the asset.
  ///
  /// [useSvg] to set whether to use SVG data.
  ///
  /// アセット用のコンフィグデータ。
  ///
  /// [useSvg]でSVGデータを利用するかを設定します。
  const AssetConfig({required this.useSvg});

  /// `true` if you use SVG data.
  ///
  /// SVGデータを利用する場合`true`。
  final bool useSvg;

  /// Get whether or not to use as Assets according to [type].
  ///
  /// Returns `true` if used as Assets.
  ///
  /// [type]に応じてAssetsとして利用するかどうかを取得します。
  ///
  /// Assetsとして利用する場合`true`を返します。
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
