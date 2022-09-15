part of masamune_media;

/// Adapter for media platforms.
///
/// IOS, Android, and Web support are available.
@immutable
class MediaPlatformAdapter extends PlatformAdapter {
  /// Adapter for media platforms.
  ///
  /// IOS, Android, and Web support are available.
  const MediaPlatformAdapter();

  /// Display the media dialog and get the data.
  ///
  /// You can limit the media type by specifying [mediaType].
  @override
  Future<LocalMedia?> mediaDialog(
    BuildContext context, {
    required String title,
    PlatformMediaType type = PlatformMediaType.all,
  }) async {
    return UIMediaDialog.show(
      context,
      title: title,
      type: _toUIMediaDialogType(type),
    );
  }

  UIMediaDialogType _toUIMediaDialogType(PlatformMediaType type) {
    switch (type) {
      case PlatformMediaType.image:
        return UIMediaDialogType.image;
      case PlatformMediaType.video:
        return UIMediaDialogType.video;
      default:
        return UIMediaDialogType.both;
    }
  }
}
