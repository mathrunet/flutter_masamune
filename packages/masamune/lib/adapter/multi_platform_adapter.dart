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
    AdapterMediaType type = AdapterMediaType.all,
  }) async {
    return null;
  }
}
