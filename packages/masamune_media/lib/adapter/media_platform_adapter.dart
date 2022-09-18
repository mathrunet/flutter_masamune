part of masamune_media;

/// Adapter for mobile/web media.
///
/// IOS, Android, and Web support are available.
@immutable
class DefaultMediaAdapter extends MediaAdapter {
  /// Adapter for mobile/web media.
  ///
  /// IOS, Android, and Web support are available.
  const DefaultMediaAdapter();

  /// Display the media dialog and get the data.
  ///
  /// You can limit the media type by specifying [mediaType].
  @override
  Future<LocalMedia?> mediaDialog(
    BuildContext context, {
    required String title,
    AdapterMediaType type = AdapterMediaType.all,
  }) async {
    return UIMediaDialog.show(
      context,
      title: title,
      type: _toUIMediaDialogType(type),
    );
  }

  UIMediaDialogType _toUIMediaDialogType(AdapterMediaType type) {
    switch (type) {
      case AdapterMediaType.image:
        return UIMediaDialogType.image;
      case AdapterMediaType.video:
        return UIMediaDialogType.video;
      default:
        return UIMediaDialogType.both;
    }
  }
}
