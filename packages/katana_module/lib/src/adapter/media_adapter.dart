part of katana_module;

/// Abstract class for creating adapters for media.
@immutable
abstract class MediaAdapter extends AdapterModule {
  const MediaAdapter();

  /// Display the media dialog and get the data.
  ///
  /// You can limit the media type by specifying [mediaType].
  Future<LocalMedia?> mediaDialog(
    BuildContext context, {
    required String title,
    AdapterMediaType type = AdapterMediaType.all,
  });
}

/// Specifies the media type.
enum AdapterMediaType {
  /// All.
  all,

  /// Image.
  image,

  /// Video.
  video,
}

/// Obtain [AdapterMediaType] from the extension of [path].
AdapterMediaType getAdapterMediaType(String path) {
  final uri = Uri.tryParse(path);
  if (uri == null) {
    return AdapterMediaType.all;
  }
  final ext = uri.path.split(".").lastOrNull;
  if (ext == null) {
    return AdapterMediaType.all;
  }
  switch (ext) {
    case "mp4":
    case "ogv":
    case "webm":
    case "avi":
    case "mov":
    case "mpeg":
      return AdapterMediaType.video;
    case "jpg":
    case "jpeg":
    case "png":
    case "bmp":
    case "tif":
    case "tiff":
    case "gif":
      return AdapterMediaType.image;
  }
  return AdapterMediaType.all;
}
