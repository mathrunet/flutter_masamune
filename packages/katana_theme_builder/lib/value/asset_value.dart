part of "/katana_theme_builder.dart";

/// Stored data for Asset.
///
/// Asset用の格納データ。
class AssetValue {
  /// Stored data for Asset.
  ///
  /// Asset用の格納データ。
  AssetValue({
    required this.path,
    required this.type,
  });

  /// Path of the asset.
  ///
  /// アセットのパス。
  final String path;

  /// Asset type.
  ///
  /// アセットのタイプ。
  final AssetValueType type;
}

AssetValueType _type(String path) {
  switch (path.last(separator: ".").toLowerCase()) {
    case "jpeg":
    case "jpg":
    case "png":
    case "gif":
    case "webp":
    case "bmp":
      return AssetValueType.image;
    case "svg":
      return AssetValueType.svg;
    case "mp4":
      return AssetValueType.video;
    case "otf":
    case "ttf":
    case "ttc":
      return AssetValueType.font;
  }
  return AssetValueType.text;
}

/// Asset type.
///
/// アセットタイプ。
enum AssetValueType {
  /// Image.
  ///
  /// 画像。
  image,

  /// SVG image.
  ///
  /// SVG画像。
  svg,

  /// Text.
  ///
  /// テキスト。
  text,

  /// Video.
  ///
  /// ビデオ。
  video,

  /// Font data.
  ///
  /// フォントデータ。
  font,
}
