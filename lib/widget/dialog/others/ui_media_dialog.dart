part of masamune.dialog.others;

/// Displays a dialog to select media.
///
/// [type] is asset selection type.
/// [title] is default title.
///
/// [disableBackKey] is `true` to disable the back key.
///
/// [popOnPress] is `true` if the dialog should be closed together when the button is pressed.
///
/// [willShowRepetition] is `true` if the dialog will continue to be displayed unless you press the regular close button.
class UIMediaDialog {
  const UIMediaDialog._();

  /// Displays a dialog to select media.
  ///
  /// [type] is asset selection type.
  /// [title] is default title.
  ///
  /// [disableBackKey] is `true` to disable the back key.
  ///
  /// [popOnPress] is `true` if the dialog should be closed together when the button is pressed.
  ///
  /// [willShowRepetition] is `true` if the dialog will continue to be displayed unless you press the regular close button.
  static Future<LocalMedia?> show(
    BuildContext context, {
    UIMediaDialogType type = UIMediaDialogType.both,
    required String title,
    String imageLabel = "Image",
    String videoLabel = "Video",
    String cameraLabel = "Taken with camera",
    String libraryLabel = "Read from library",
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    Future<LocalMedia>? res;
    AssetType? assetType;
    switch (type) {
      case UIMediaDialogType.image:
        assetType = AssetType.image;
        break;
      case UIMediaDialogType.video:
        assetType = AssetType.video;
        break;
      default:
        await UISelectDialog.show(
          context,
          selectors: {
            imageLabel.localize(): () {
              assetType = AssetType.image;
            },
            videoLabel.localize(): () {
              assetType = AssetType.video;
            }
          },
          title: title,
          disableBackKey: disableBackKey,
          popOnPress: popOnPress,
          willShowRepetition: willShowRepetition,
        );
        break;
    }
    if (assetType == null) {
      return null;
    }
    final localMedia = readProvider(localMediaProvider(
        "$uuid.${assetType == AssetType.video ? "mp4" : "jpg"}"));
    if (assetType == AssetType.image) {
      res = localMedia.image(source: ImageSource.gallery);
    } else {
      res = localMedia.video(source: ImageSource.gallery);
    }
    return await res;
  }
}

/// The type of media to acquire.
enum UIMediaDialogType {
  /// Image.
  image,

  /// Video.
  video,

  /// Image and video.
  both,
}
