part of masamune;

@immutable
class MultiPlatformAdapter extends PlatformAdapter {
  const MultiPlatformAdapter();

  @override
  Future<dynamic> mediaDialog(
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
}
