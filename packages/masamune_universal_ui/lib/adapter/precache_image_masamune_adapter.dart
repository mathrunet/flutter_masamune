part of "/masamune_universal_ui.dart";

/// An adapter that allows you to precache images.
///
/// 画像をプリキャッシュするためのアダプター。
class PrecacheImageMasamuneAdapter extends MasamuneAdapter {
  /// An adapter that allows you to precache images.
  ///
  /// 画像をプリキャッシュするためのアダプター。
  const PrecacheImageMasamuneAdapter({
    this.images = const [],
  });

  /// The images to precache.
  ///
  /// プリキャッシュする画像。
  final List<ImageProvider> images;

  @override
  FutureOr<void> onPreRunApp(WidgetsBinding binding) async {
    final context = binding.rootElement as BuildContext?;
    if (context == null) {
      return;
    }
    for (final image in images) {
      await precacheImage(image, context);
    }
    return super.onPreRunApp(binding);
  }
}
