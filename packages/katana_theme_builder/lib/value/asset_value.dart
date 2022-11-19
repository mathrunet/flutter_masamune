part of katana_theme_builder;

class AssetValue {
  AssetValue({
    required this.path,
    required this.type,
  });

  final String path;
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

enum AssetValueType {
  image,
  svg,
  text,
  video,
  font,
}
