part of "/masamune_markdown.dart";

/// Media tools.
///
/// メディアツール。
enum MarkdownToolMedia {
  /// Image from camera.
  ///
  /// カメラから画像を選択します。
  imageFromCamera,

  /// Image from library.
  ///
  /// ライブラリから画像を選択します。
  imageFromLibrary,

  /// Video from camera.
  ///
  /// カメラからビデオを選択します。
  videoFromCamera,

  /// Video from library.
  ///
  /// ライブラリからビデオを選択します。
  videoFromLibrary;

  /// Get the label for the tool.
  ///
  /// ツールのラベルを取得します。
  String label(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    final locale = context.locale;
    switch (this) {
      case MarkdownToolMedia.imageFromCamera:
        return adapter?.toolsConfig.imageFromCameraLabel.title.value(locale) ??
            "";
      case MarkdownToolMedia.imageFromLibrary:
        return adapter?.toolsConfig.imageFromLibraryLabel.title.value(locale) ??
            "";
      case MarkdownToolMedia.videoFromCamera:
        return adapter?.toolsConfig.videoFromCameraLabel.title.value(locale) ??
            "";
      case MarkdownToolMedia.videoFromLibrary:
        return adapter?.toolsConfig.videoFromLibraryLabel.title.value(locale) ??
            "";
    }
  }

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  IconData icon(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    switch (this) {
      case MarkdownToolMedia.imageFromCamera:
        return adapter?.toolsConfig.imageFromCameraLabel.icon ??
            Icons.photo_camera;
      case MarkdownToolMedia.imageFromLibrary:
        return adapter?.toolsConfig.imageFromLibraryLabel.icon ??
            Icons.photo_library;
      case MarkdownToolMedia.videoFromCamera:
        return adapter?.toolsConfig.videoFromCameraLabel.icon ??
            Icons.video_camera_back;
      case MarkdownToolMedia.videoFromLibrary:
        return adapter?.toolsConfig.videoFromLibraryLabel.icon ??
            Icons.video_library;
    }
  }

  /// Execute the tool.
  ///
  /// ツールを実行します。
  Future<void> onTap(BuildContext context, MarkdownToolRef ref) async {
    switch (this) {
      case MarkdownToolMedia.imageFromCamera:
        ref.focusedController?.addFormattedLine(null);
        break;
      case MarkdownToolMedia.imageFromLibrary:
        ref.focusedController?.addFormattedLine(Attribute.h1);
        break;
      case MarkdownToolMedia.videoFromCamera:
        ref.focusedController?.addFormattedLine(Attribute.h3);
        break;
      case MarkdownToolMedia.videoFromLibrary:
        ref.focusedController?.addFormattedLine(Attribute.h3);
        break;
    }
  }
}
