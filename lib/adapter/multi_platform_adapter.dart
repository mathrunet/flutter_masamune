part of masamune;

@immutable
class MultiPlatformAdapter extends PlatformAdapter {
  const MultiPlatformAdapter();

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

  @override
  MultiPlatformAdapter? fromMap(DynamicMap map) {
    if (map.get("type", "") != type) {
      return null;
    }
    return const MultiPlatformAdapter();
  }

  @override
  DynamicMap toMap() {
    return <String, dynamic>{
      "type": type,
    };
  }
}
