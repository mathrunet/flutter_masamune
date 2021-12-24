part of masamune;

/// Adapter for multiple platforms.
///
/// IOS, Android, and Web support are available.
@immutable
class MultiPlatformAdapter extends PlatformAdapter {
  /// Adapter for multiple platforms.
  ///
  /// IOS, Android, and Web support are available.
  const MultiPlatformAdapter();

  /// Display the media dialog and get the data.
  ///
  /// You can limit the media type by specifying [mediaType].
  @override
  Future<LocalMedia?> mediaDialog(
    BuildContext context, {
    required String title,
    PlatformMediaType type = PlatformMediaType.all,
  }) {
    return UIMediaDialog.show(
      context,
      title: title,
      type: _convertMediaType(type),
    );
  }

  UIMediaDialogType _convertMediaType(PlatformMediaType type) {
    switch (type) {
      case PlatformMediaType.image:
        return UIMediaDialogType.image;
      case PlatformMediaType.video:
        return UIMediaDialogType.video;
      default:
        return UIMediaDialogType.both;
    }
  }

  /// Convert the module information from [DynamicMap].
  @override
  MultiPlatformAdapter? fromMap(DynamicMap map) {
    if (map.get("type", "") != type) {
      return null;
    }
    return const MultiPlatformAdapter();
  }

  /// Convert the module information to [DynamicMap].
  @override
  DynamicMap toMap() {
    return <String, dynamic>{
      "type": type,
    };
  }
}
