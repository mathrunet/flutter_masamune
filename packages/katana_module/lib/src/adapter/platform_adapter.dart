part of katana_module;

/// Abstract class for creating adapters for platforms.
@immutable
abstract class PlatformAdapter extends AdapterModule {
  const PlatformAdapter();

  /// Display the media dialog and get the data.
  ///
  /// You can limit the media type by specifying [mediaType].
  Future<LocalMedia?> mediaDialog(
    BuildContext context, {
    required String title,
    PlatformMediaType type = PlatformMediaType.all,
  });
}

/// Specifies the media type.
enum PlatformMediaType {
  /// All.
  all,

  /// Image.
  image,

  /// Video.
  video,
}

/// Obtain [PlatformMediaType] from the extension of [path].
PlatformMediaType getPlatformMediaType(String path) {
  final uri = Uri.tryParse(path);
  if (uri == null) {
    return PlatformMediaType.all;
  }
  final ext = uri.path.split(".").lastOrNull;
  if (ext == null) {
    return PlatformMediaType.all;
  }
  switch (ext) {
    case "mp4":
    case "ogv":
    case "webm":
    case "avi":
    case "mov":
    case "mpeg":
      return PlatformMediaType.video;
    case "jpg":
    case "jpeg":
    case "png":
    case "bmp":
    case "tif":
    case "tiff":
    case "gif":
      return PlatformMediaType.image;
  }
  return PlatformMediaType.all;
}
